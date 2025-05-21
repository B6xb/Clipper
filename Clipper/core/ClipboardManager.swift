import SwiftUI

class ClipboardManager: ObservableObject {
    @Published var items: [ClipboardItem] = []
    private var maxItems = 25
    private var timer: Timer?
    private var pasteboard = NSPasteboard.general
    private var lastChangeCount: Int
    
    init() {
        lastChangeCount = pasteboard.changeCount
        startMonitoring()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.checkClipboard()
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    private func checkClipboard() {
        let currentChangeCount = pasteboard.changeCount
        
        if currentChangeCount != lastChangeCount {
            lastChangeCount = currentChangeCount
            
            // Handle different content types
            if let string = pasteboard.string(forType: .string) {
                addItem(content: string, type: .text)
            } else if let imageData = pasteboard.data(forType: .tiff),
                      let _ = NSImage(data: imageData) {
                // For demonstration - just note that there was an image
                addItem(content: "[Image Copied]", type: .image)
            } else if let urls = pasteboard.propertyList(forType: .fileURL) as? [String],
                      !urls.isEmpty {
                addItem(content: urls.joined(separator: ", "), type: .file)
            } else {
                addItem(content: "Unknown content", type: .other)
            }
        }
    }
    
    private func addItem(content: String, type: ClipboardItem.ItemType) {
        let newItem = ClipboardItem(content: content, timestamp: Date(), type: type)
        
        if newItem.content.isBlank {
            return
        }
        
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)

        let item = ClipboardItem(content: trimmedContent, timestamp: Date(), type: type)

        
        // Use main thread for UI updates
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Remove duplicate if exists
            if let index = self.items.firstIndex(where: { $0.content == content && $0.type == type }) {
                self.items.remove(at: index)
            }
            
            // Add new item at the beginning
            self.items.insert(item, at: 0)
            
            // Limit the number of items
            if self.items.count > self.maxItems {
                self.items.removeLast()
            }
        }
    }
    
    func copyToClipboard(item: ClipboardItem) {
        pasteboard.clearContents()
        pasteboard.setString(item.content, forType: .string)
        
        // Use main thread for UI updates
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // Move the item to the top
            if let index = self.items.firstIndex(where: { $0.id == item.id }) {
                let item = self.items.remove(at: index)
                self.items.insert(item, at: 0)
            }
        }
    }
    
    func clearHistory() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.items.removeAll()
        }
    }
    
    func removeItem(at indexSet: IndexSet) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.items.remove(atOffsets: indexSet)
        }
    }
    deinit {
        stopMonitoring()
    }
}
