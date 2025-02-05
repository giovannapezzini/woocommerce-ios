import Foundation


// MARK: - Array Helpers
//
extension Array where Element == Int64 {

    /// Returns a sorted, de-duplicated array of integer values as a comma-separated String.
    ///
    func sortedUniqueIntToString() -> String {
        let uniqued: Array = Array(Set<Int64>(self))

        let items = uniqued.sorted()
        .map { String($0) }
        .filter { !$0.isEmpty }
        .joined(separator: ",")

        return items
    }
}

// MARK: - Collection Helpers
//
extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    ///
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
