import UIKit
import Gridicons
import Contacts
import MessageUI

class OrderDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var order: Order! {
        didSet {
            refreshViewModel()
        }
    }

    var viewModel: OrderDetailsViewModel!
    var sectionTitles = [String]()
    var billingIsHidden = true
    private var sections = [Section]()

    func refreshViewModel() {
        viewModel = OrderDetailsViewModel(order: order)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = NSLocalizedString("Order #\(order.number)", comment:"Order number title")
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    func configureTableView() {
        configureSections()
        configureNibs()
    }

    func configureSections() {
        let summarySection = Section(title: nil, footer: nil, rows: [.summary])
        let customerNoteSection = Section(title: NSLocalizedString("CUSTOMER PROVIDED NOTE", comment: "Customer note section title"), footer: nil, rows: [.customerNote])

        let infoFooter = billingIsHidden ? NSLocalizedString("Show billing", comment: "Footer text to show the billing cell") : NSLocalizedString("Hide billing", comment: "Footer text to hide the billing cell")
        let infoRows: [Row] = billingIsHidden ? [.shippingAddress] : [.shippingAddress, .billingAddress, .billingPhone, .billingEmail]
        let infoSection = Section(title: NSLocalizedString("CUSTOMER INFORMATION", comment: "Customer info section title"), footer: infoFooter, rows: infoRows)

        let orderNotesSection = Section(title: NSLocalizedString("ORDER NOTES", comment: "Order notes section title"), footer: nil, rows: [.addOrderNote])

        // FIXME: this is temporary
        // the API response always sends customer note data
        // if there is no customer note it sends an empty string
        // but order has customerNote as an optional property right now
        guard let customerNote = order.customerNote,
            !customerNote.isEmpty else {
            sections = [summarySection, infoSection, orderNotesSection]
            return
        }
        sections = [summarySection, customerNoteSection, infoSection, orderNotesSection]
    }

    func configureNibs() {
        for section in sections {
            for row in section.rows {
                let nib = UINib(nibName: row.reuseIdentifier, bundle: nil)
                tableView.register(nib, forCellReuseIdentifier: row.reuseIdentifier)
            }
        }

        let footerNib = UINib(nibName: ShowHideSectionFooter.reuseIdentifier, bundle: nil)
        tableView.register(footerNib, forHeaderFooterViewReuseIdentifier: ShowHideSectionFooter.reuseIdentifier)
    }
}

// MARK: - Table Data Source
//
extension OrderDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = sections[indexPath.section].rows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: row.reuseIdentifier, for: indexPath)
        configure(cell, for: row)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let _ = sections[section].title else {
            // iOS 11 table bug. Must return a tiny value to collapse `nil` or `empty` section headers.
            return CGFloat.leastNonzeroMagnitude
        }

        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let _ = sections[section].footer else {
            // iOS 11 table bug. Must return a tiny value to collapse `nil` or `empty` section footers.
            return CGFloat.leastNonzeroMagnitude
        }

        return Constants.rowHeight
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerText = sections[section].footer else {
            return nil
        }

        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ShowHideSectionFooter.reuseIdentifier) as! ShowHideSectionFooter
        let image = billingIsHidden ? Gridicon.iconOfType(.chevronDown) : Gridicon.iconOfType(.chevronUp)
        cell.configure(text: footerText, image: image)
        cell.didSelectFooter = { [weak self] in
            self?.setShowHideFooter()
            self?.configureTableView()
            let sections = IndexSet(integer: section)
            tableView.reloadSections(sections, with: .fade)
        }
        return cell
    }
}

// MARK: - Table Delegate
//
extension OrderDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if sections[indexPath.section].rows[indexPath.row] == .addOrderNote {
            // TODO: present modal for Add Note screen
        }
    }
}

// MARK: - Extension
//
extension OrderDetailsViewController {
    private func configure(_ cell: UITableViewCell, for row: Row) {
        switch cell {
        case let cell as SummaryTableViewCell:
            cell.configure(with: viewModel)
        case let cell as CustomerNoteTableViewCell:
            cell.configure(with: viewModel)
        case let cell as CustomerInfoTableViewCell where row == .shippingAddress:
            cell.configure(with: viewModel.shippingViewModel)
        case let cell as CustomerInfoTableViewCell where row == .billingAddress:
            cell.configure(with: viewModel.billingViewModel)
        case let cell as BillingDetailsTableViewCell where row == .billingPhone:
            configure(cell, for: .billingPhone)
        case let cell as BillingDetailsTableViewCell where row == .billingEmail:
            configure(cell, for: .billingEmail)
        case let cell as AddItemTableViewCell:
            cell.configure(image: viewModel.addNoteIcon, text: viewModel.addNoteText)
        default:
            fatalError("Unidentified customer info row type")
        }
    }

    private func configure(_ cell: BillingDetailsTableViewCell, for billingRow: Row) {
        if billingRow == .billingPhone {
            cell.configure(text: viewModel.billingViewModel.phoneNumber, image: Gridicon.iconOfType(.ellipsis))
            cell.didTapButton = { [weak self] in
                self?.phoneButtonAction()
            }
        } else if billingRow == .billingEmail {
            cell.configure(text: viewModel.billingViewModel.email, image: Gridicon.iconOfType(.mail))
            cell.didTapButton = { [weak self] in
                self?.emailButtonAction()
            }
        } else {
            fatalError("Unidentified billing detail row")
        }
    }

    @objc func phoneButtonAction() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = StyleManager.wooCommerceBrandColor
        let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss the action sheet"), style: .cancel)
        actionSheet.addAction(dismissAction)

        let callAction = UIAlertAction(title: NSLocalizedString("Call", comment: "Call phone number button title"), style: .default) { [weak self] action in
            let contactViewModel = ContactViewModel(with: (self?.order.billingAddress)!, contactType: .billing)
            guard let phone = contactViewModel.cleanedPhoneNumber else {
                return
            }
            if let url = URL(string: "telprompt://" + phone),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        actionSheet.addAction(callAction)

        let messageAction = UIAlertAction(title: NSLocalizedString("Message", comment: "Message phone number button title"), style: .default) { [weak self] action in
            self?.sendTextMessageIfPossible()
        }
        actionSheet.addAction(messageAction)

        present(actionSheet, animated: true)
    }

    @objc func emailButtonAction() {
        sendEmailIfPossible()
    }

    func setShowHideFooter() {
        billingIsHidden = !billingIsHidden
    }
}

// MARK: - Messages Delgate
//
extension OrderDetailsViewController: MFMessageComposeViewControllerDelegate {
    func sendTextMessageIfPossible() {
        let contactViewModel = ContactViewModel(with: order.billingAddress, contactType: .billing)
        guard let phoneNumber = contactViewModel.cleanedPhoneNumber else {
            return
        }
        if MFMessageComposeViewController.canSendText() {
            sendTextMessage(to: phoneNumber)
        }
    }

    private func sendTextMessage(to phoneNumber: String) {
        let controller = MFMessageComposeViewController()
        controller.recipients = [phoneNumber]
        controller.messageComposeDelegate = self
        present(controller, animated: true, completion: nil)
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Email Delegate
//
extension OrderDetailsViewController: MFMailComposeViewControllerDelegate {
    func sendEmailIfPossible() {
        if MFMailComposeViewController.canSendMail() {
            let contactViewModel = ContactViewModel(with: order.billingAddress, contactType: .billing)
            guard let email = contactViewModel.email else {
                return
            }
            sendEmail(to: email)
        }
    }

    private func sendEmail(to email: String) {
        let controller = MFMailComposeViewController()
        controller.setToRecipients([email])
        controller.mailComposeDelegate = self
        present(controller, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

private extension OrderDetailsViewController {
    struct Constants {
        static let rowHeight = CGFloat(38)
    }

    private struct Section {
        let title: String?
        let footer: String?
        let rows: [Row]
    }

    private enum Row {
        case summary
        case customerNote
        case shippingAddress
        case billingAddress
        case billingPhone
        case billingEmail
        case addOrderNote

        var reuseIdentifier: String {
            switch self {
            case .summary:
                return SummaryTableViewCell.reuseIdentifier
            case .customerNote:
                return CustomerNoteTableViewCell.reuseIdentifier
            case .shippingAddress:
                return CustomerInfoTableViewCell.reuseIdentifier
            case .billingAddress:
                return CustomerInfoTableViewCell.reuseIdentifier
            case .billingPhone:
                return BillingDetailsTableViewCell.reuseIdentifier
            case .billingEmail:
                return BillingDetailsTableViewCell.reuseIdentifier
            case .addOrderNote:
                return AddItemTableViewCell.reuseIdentifier
            }
        }
    }
}
