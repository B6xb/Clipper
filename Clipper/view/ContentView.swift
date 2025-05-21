import SwiftUI

struct ContentView: View {
    @ObservedObject var clipboardManager: ClipboardManager
    @State private var showingSettings = false
    @State private var isPinned = false
    @State private var isHovering = false
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                List {
                    ForEach(clipboardManager.items) { item in
                        ClipboardItemRow(item: item)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                clipboardManager.copyToClipboard(item: item)
                            }
                    }
                    .onDelete(perform: clipboardManager.removeItem)
                }
                .safeAreaInset(edge: .top) {
                    Spacer().frame(height: 15)
                }
                .listStyle(PlainListStyle())
                .frame(maxWidth: .infinity)
                
                if clipboardManager.items.isEmpty {
                    ContentUnavailableView(
                        "No Clipboard History",
                        systemImage: "clipboard",
                        description: Text("Copy some text to see it here")
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView(clipboardManager: ClipboardManager())
}
