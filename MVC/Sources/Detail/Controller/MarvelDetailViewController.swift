import Core
import Kingfisher
import UIKit

class MarvelDetailViewController: UIViewController {
    @IBOutlet private weak var marvelImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    var id: Int?
    var apiClient: APIProtocol = APIClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchMarvelDetails()
    }

    private func fetchMarvelDetails() {
        guard let id else {
            return
        }

        Spinner.start()
        apiClient.get(endpoint: .detail(id: id)) { (result: Result<MarvelCharacterModel, NetworkError>) in
            Spinner.stop()
            switch result {
            case .success(let model):
                self.configureMarvelDetails(model)
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }

    private func configureMarvelDetails(_ model: MarvelCharacterModel) {
        guard let marvelResult = model.data?.results?.first else { return }
        marvelImageView.kf.setImage(with: marvelResult.thumbnail?.url)
        nameLabel.text = marvelResult.name
        descriptionLabel.text = marvelResult.description
        title = marvelResult.name
    }
}
