import Foundation
import UIKit

class Spinner {
    private static var spinner = UIActivityIndicatorView()
    private static var style: UIActivityIndicatorView.Style = .large
    private static var baseBackColor = UIColor.black.withAlphaComponent(0.5)
    private static var baseColor = UIColor.red
    
    static func start(style: UIActivityIndicatorView.Style = style, backColor: UIColor = baseBackColor, baseColor: UIColor = baseColor) {
        DispatchQueue.main.async {
            if let window = UIApplication.keyWindow {
                let frame = UIScreen.main.bounds
                spinner = UIActivityIndicatorView(frame: frame)
                spinner.backgroundColor = backColor
                spinner.style = style
                spinner.color = baseColor
                window.addSubview(spinner)
                spinner.startAnimating()
                UIApplication.disableInteraction()
            }
        }
    }
    
    static func stop() {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            UIApplication.enableInteraction()
        }
    }
}
