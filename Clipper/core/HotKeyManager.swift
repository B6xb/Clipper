import Foundation
import Carbon
import AppKit

class HotKeyManager {
    private var eventHandler: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?
    
    init() {
        registerHotKey()
    }
    
    private func registerHotKey() {
        // Register for Command + Shift + V
        let signature = OSType("CLIP".fourCharCodeValue)
        let hotKeyID = EventHotKeyID(signature: signature, id: UInt32(1))
        
        let modifiers: UInt32 = UInt32(cmdKey | shiftKey)
        let keyCode = UInt32(kVK_ANSI_V) // 'V' key
        
        // Install event handler
        let eventSpec = [
            EventTypeSpec(eventClass: OSType(kEventClassKeyboard),
                         eventKind: UInt32(kEventHotKeyPressed))
        ]
        
        // Create callback - now toggles window visibility
        let callback: EventHandlerUPP = { _, eventRef, _ -> OSStatus in
            // Run on main thread to avoid UI issues
            DispatchQueue.main.async {
                WindowManager.shared.toggleWindowVisibility()
            }
            return noErr
        }
        
        var handlerRef: EventHandlerRef?
        InstallEventHandler(GetApplicationEventTarget(),
                          callback,
                          1,
                          eventSpec,
                          nil,
                          &handlerRef)
        self.eventHandler = handlerRef
        
        // Register hot key
        RegisterEventHotKey(keyCode,
                          modifiers,
                          hotKeyID,
                          GetApplicationEventTarget(),
                          0,
                          &hotKeyRef)
    }
    
    deinit {
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
        }
    }
}

extension String {
    var fourCharCodeValue: FourCharCode {
        var result: FourCharCode = 0
        if let data = self.data(using: String.Encoding.macOSRoman) {
            data.withUnsafeBytes { ptr in
                if let addr = ptr.baseAddress, ptr.count >= 4 {
                    result = UInt32(bigEndian: addr.loadUnaligned(as: UInt32.self))
                }
            }
        }
        return result
    }
}
