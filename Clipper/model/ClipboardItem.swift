import Foundation

// MARK: - Data Models
struct ClipboardItem: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let timestamp: Date
    let type: ItemType
    
    enum ItemType: String {
        case text
        case image
        case file
        case other
    }
    
    static func == (lhs: ClipboardItem, rhs: ClipboardItem) -> Bool {
        return lhs.id == rhs.id
    }
}

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}
