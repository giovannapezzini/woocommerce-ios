import Foundation
import Storage


// Storage.Site: ReadOnlyConvertible Conformance.
//
extension Storage.Site: ReadOnlyConvertible {

    /// Indicates if the receiver is the Storage.Entity, backing up the specified ReadOnly.Entity.
    ///
    public func represents(readOnlyEntity: Any) -> Bool {
        guard let readOnlySite = readOnlyEntity as? Yosemite.Site else {
            return false
        }

        return readOnlySite.siteID == Int(siteID)
    }

    /// Updates the Storage.Site with the a ReadOnly.
    ///
    public func update(with site: Yosemite.Site) {
        siteID = Int64(site.siteID)
        name = site.name
        tagline = site.description
        url = site.url
        isWooCommerceActive = NSNumber(booleanLiteral: site.isWooCommerceActive)
        isWordPressStore = NSNumber(booleanLiteral: site.isWordPressStore)
    }

    /// Returns a ReadOnly version of the receiver.
    ///
    public func toReadOnly() -> Yosemite.Site {
        return Site(siteID: Int(siteID),
                    name: name ?? "",
                    description: tagline ?? "",
                    url: url ?? "",
                    isWooCommerceActive: isWooCommerceActive?.boolValue ?? false,
                    isWordPressStore: isWordPressStore?.boolValue ?? false)
    }
}
