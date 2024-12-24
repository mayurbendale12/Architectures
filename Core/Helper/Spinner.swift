import Foundation
import UIKit

public class Spinner {
    private static var spinner = UIActivityIndicatorView()
    public private(set) static var style: UIActivityIndicatorView.Style = .large
    public private(set) static var baseBackColor = UIColor.black.withAlphaComponent(0.5)
    public private(set) static var baseColor = UIColor.red

    public static func start(style: UIActivityIndicatorView.Style = style,
                             backColor: UIColor = baseBackColor,
                             baseColor: UIColor = baseColor) {
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
    
    public static func stop() {
        DispatchQueue.main.async {
            spinner.stopAnimating()
            spinner.removeFromSuperview()
            UIApplication.enableInteraction()
        }
    }
}
