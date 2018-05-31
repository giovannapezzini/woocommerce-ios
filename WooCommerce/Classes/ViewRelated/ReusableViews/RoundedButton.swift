import UIKit

class RoundedButton: UIButton {
    var height = 4.0

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 1.0, height: height)
    }
}
