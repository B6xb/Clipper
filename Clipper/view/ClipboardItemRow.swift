import SwiftUI

struct ClipboardItemRow: View {
    let item: ClipboardItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.content)
                .lineLimit(2)
                .font(.body)
            
            HStack {
                Image(systemName: iconForType(item.type))
                    .foregroundColor(.secondary)
                
                Text(formattedTime(item.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 10)
    }
    
    private func iconForType(_ type: ClipboardItem.ItemType) -> String {
        switch type {
        case .text:
            return "doc.text"
        case .image:
            return "photo"
        case .file:
            return "folder"
        case .other:
            return "questionmark.square"
        }
    }
    
    private func formattedTime(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
