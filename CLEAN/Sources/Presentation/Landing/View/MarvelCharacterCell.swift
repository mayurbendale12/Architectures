import Kingfisher
import UIKit

final class MarvelCharacterCell: UITableViewCell {
    @IBOutlet private weak var marvelImageView: UIImageView!
    @IBOutlet private weak var characterLabel: UILabel!

    func setup(name: String, imageUrl: URL?) {
        characterLabel.text = name
        marvelImageView.kf.setImage(with: imageUrl)
    }
}
