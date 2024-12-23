import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButtonTitle = "marvel_alert_ok_button_title".localize()
        alertController.addAction(UIAlertAction(title: okButtonTitle, style: .default))
        present(alertController, animated: true)
    }

    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let identifier = String(describing: self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Couldn't instantiate view controller with identifier: \(identifier)")
        }
        return viewController
    }
}
