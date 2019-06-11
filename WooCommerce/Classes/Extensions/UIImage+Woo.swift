import Foundation
import UIKit
import Gridicons


/// WooCommerce UIImage Assets
///
extension UIImage {

    /// Add Icon
    ///
    static var addOutlineImage: UIImage {
        return Gridicon.iconOfType(.addOutline)
    }

    /// Aside Image
    ///
    static var asideImage: UIImage {
        return Gridicon.iconOfType(.aside)
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Camera Icon
    ///
    static var cameraImage: UIImage {
        return Gridicon.iconOfType(.camera)
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// WooCommerce Styled Checkmark
    ///
    static var checkmarkImage: UIImage {
        let tintColor = StyleManager.wooCommerceBrandColor
        return Gridicon.iconOfType(.checkmark).imageWithTintColor(tintColor)!
    }

    /// Chevron pointing right
    ///
    static var chevronImage: UIImage {
        let tintColor = StyleManager.wooGreyMid
        return Gridicon.iconOfType(.chevronRight).imageWithTintColor(tintColor)!
    }

    /// Chevron pointing down
    ///
    static var chevronDownImage: UIImage {
        return Gridicon.iconOfType(.chevronDown)
    }

    /// Chevron pointing up
    ///
    static var chevronUpImage: UIImage {
        return Gridicon.iconOfType(.chevronUp)
    }

    /// Cog image
    ///
    static var cogImage: UIImage {
        return Gridicon.iconOfType(.cog)
    }

    /// Delete icon
    ///
    static var deleteImage: UIImage {
        let tintColor = StyleManager.wooCommerceBrandColor
        return Gridicon.iconOfType(.crossCircle)
            .imageWithTintColor(tintColor)!
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Ellipsis icon
    ///
    static var ellipsisImage: UIImage {
        return Gridicon.iconOfType(.ellipsis)
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Error State Image
    ///
    static var errorStateImage: UIImage {
        return UIImage(named: "woo-error-state")!
    }

    /// External link Icon
    ///
    static var externalImage: UIImage {
        return Gridicon.iconOfType(.external)
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Filter icon
    ///
    static var filterImage: UIImage {
        return Gridicon.iconOfType(.filter)
    }

    /// Gravatar Placeholder Image
    ///
    static var gravatarPlaceholderImage: UIImage {
        return UIImage(named: "gravatar")!
    }

    /// Heart outline
    ///
    static var heartOutlineImage: UIImage {
        return Gridicon.iconOfType(.heartOutline)
    }

    /// Jetpack Logo Image
    ///
    static var jetpackLogoImage: UIImage {
        return UIImage(named: "icon-jetpack-gray")!
    }

    /// Invisible image
    ///
    static var invisibleImage: UIImage {
        return Gridicon.iconOfType(.image)
    }

    /// Mail icon
    ///
    static var mailImage: UIImage {
        return Gridicon.iconOfType(.mail)
    }

    /// More icon
    ///
    static var moreImage: UIImage {
        let tintColor = StyleManager.wooCommerceBrandColor
        return ellipsisImage.imageWithTintColor(tintColor)!
    }

    /// Product Placeholder Image
    ///
    static var productPlaceholderImage: UIImage {
        let tintColor = StyleManager.wooGreyLight
        return Gridicon.iconOfType(.product).imageWithTintColor(tintColor)!
    }

    /// Product Image
    ///
    static var productImage: UIImage {
        return Gridicon.iconOfType(.product)
    }

    /// Pencil Icon
    ///
    static var pencilImage: UIImage {
        let tintColor = StyleManager.wooCommerceBrandColor
        return Gridicon.iconOfType(.pencil)
            .imageWithTintColor(tintColor)!
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Quote Image
    ///
    static var quoteImage: UIImage {
        return Gridicon.iconOfType(.quote)
    }

    /// Pages icon
    ///
    static var pagesImage: UIImage {
        return Gridicon.iconOfType(.pages)
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Search icon
    ///
    static var searchImage: UIImage {
        return Gridicon.iconOfType(.search)
            .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Stats icon
    ///
    static var statsImage: UIImage {
        return Gridicon.iconOfType(.stats)
        .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Stats Alt icon
    static var statsAltImage: UIImage {
        return Gridicon.iconOfType(.statsAlt)
        .imageFlippedForRightToLeftLayoutDirection()
    }

    /// Creates a bitmap image of the Woo "bubble" logo based on a vector image in our asset catalog.
    ///
    /// - Parameters:
    ///   - size: desired size of the resulting bitmap image
    ///   - tintColor: desired tint color of the resulting bitmap image
    /// - Returns: a bitmap image
    ///
    static func wooLogoImage(withSize size: CGSize = Metrics.defaultWooLogoSize, tintColor: UIColor = .white) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let vectorImage = UIImage(named: "woo-logo")!
        let renderer = UIGraphicsImageRenderer(size: size)
        let im2 = renderer.image { ctx in
            vectorImage.draw(in: rect)
        }

        return im2.imageWithTintColor(tintColor)
    }

    /// Waiting for Customers Image
    ///
    static var waitingForCustomersImage: UIImage {
        return UIImage(named: "woo-waiting-customers")!
    }
}

private extension UIImage {

    enum Metrics {
        static let defaultWooLogoSize = CGSize(width: 30, height: 18)
    }
}
