import SwiftUI
import AppKit

class WindowManager {
    static let shared = WindowManager()
    private var isWindowVisible = true
    private var isPinned = false
    
    func toggleWindowVisibility() {
        if let window = NSApplication.shared.windows.first(where: { !($0 is NSPanel) }) {
            if isWindowVisible {
                window.miniaturize(nil)
            } else {
                window.deminiaturize(nil)
                setWindowLevel(window)
            }
            isWindowVisible = !isWindowVisible
        }
    }
    
    func setPinned(_ pinned: Bool) {
        isPinned = pinned
        if let window = NSApplication.shared.windows.first(where: { !($0 is NSPanel) }) {
            setWindowLevel(window)
        }
    }
    
    func setWindowOnTop(_ window: NSWindow? = nil) {
        let targetWindow = window ?? NSApplication.shared.windows.first(where: { !($0 is NSPanel) })
        guard let window = targetWindow else { return }
        
        window.orderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        setWindowLevel(window)
        
        if window.isMiniaturized {
            window.deminiaturize(nil)
        }
        
        isWindowVisible = true
    }
    
    private func setWindowLevel(_ window: NSWindow) {
        // Set normal level if not pinned, floating level if pinned
        window.level = isPinned ? .floating : .normal
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
    }
}
