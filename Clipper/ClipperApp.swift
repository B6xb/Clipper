import SwiftUI

@main
struct ClipperApp: App {
    @StateObject private var clipboardManager = ClipboardManager()
    @State private var isPinned = false
    private let hotKeyManager = HotKeyManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(clipboardManager: clipboardManager)
                .frame(width: 400, height: 450)
                .fixedSize(horizontal: true, vertical: true)
                .onAppear {
                    setupWindow()
                }
                .toolbarBackgroundVisibility(.hidden)
        }
        .windowResizability(.contentSize)
        
        #if os(macOS)
        MenuBarExtra("Clips", systemImage: "clipboard") {
            Button("Show/Hide Clipboard (⇧⌘V)") {
                WindowManager.shared.toggleWindowVisibility()
            }
            
            Divider()
            
            // Pin toggle in menu bar
            Button(isPinned ? "Unpin from Top" : "Pin to Top") {
                isPinned.toggle()
                WindowManager.shared.setPinned(isPinned)
            }
    
            Divider()
            
            ForEach(clipboardManager.items.prefix(5)) { item in
                Button(truncateString(item.content)) {
                    clipboardManager.copyToClipboard(item: item)
                }
            }
            
            if clipboardManager.items.isEmpty {
                Text("No items in clipboard")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            
            Divider()
            
            Button("Clear Clipboard") {
                clipboardManager.clearHistory()
            }
            .disabled(clipboardManager.items.isEmpty)
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        
        Window("About Clipper", id:"about"){
            AboutView()
                .toolbar(removing:.title)
                .containerBackground(.thickMaterial, for: .window)
                .windowMinimizeBehavior(.disabled)
                .windowResizeBehavior(.disabled)
        }
        .windowResizability(.contentSize)
        .restorationBehavior(.disabled)
        
        #endif
    }
    
}
    
    // Set up window properties on launch
    private func setupWindow() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            WindowManager.shared.setWindowOnTop()
            
            // Add notifications to maintain window state
            NotificationCenter.default.addObserver(
                forName: NSWindow.didBecomeKeyNotification,
                object: nil,
                queue: .main
            ) { notification in
                if let window = notification.object as? NSWindow {
                    if !window.isKind(of: NSPanel.self) {
                        WindowManager.shared.setWindowOnTop(window)
                    }
                }
            }
        }
    }
    
    private func truncateString(_ string: String) -> String {
        if string.count > 30 {
            return string.prefix(30) + "..."
        }
        return string
    }



