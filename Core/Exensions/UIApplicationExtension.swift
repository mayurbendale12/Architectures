import UIKit

public extension UIApplication {
    static var keyWindow: UIWindow? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first
    }

    static func enableInteraction() {
        keyWindow?.isUserInteractionEnabled = true
    }

    static func disableInteraction() {
        keyWindow?.isUserInteractionEnabled = false
    }
}
