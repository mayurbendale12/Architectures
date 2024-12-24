import Core
import Kingfisher
import UIKit

protocol MarvelDetailViewContract: AnyObject {
    func showSpinner()
    func hideSpinner()
    func render(viewModel: MarvelDetailViewModel)
}

struct MarvelDetailViewModel {
    let name: String
    let description: String?
    let imageURL: URL?
}

class MarvelDetailViewController: UIViewController {
    @IBOutlet private weak var marvelImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    private lazy var presenter: MarvelDetailPresenterContract = {
        return MarvelDetailPresenter(apiClient: APIClient.shared,
                                     view: self,
                                     id: id)
    }()

    var id: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewLoaded()
    }
}

extension MarvelDetailViewController: MarvelDetailViewContract {
    func showSpinner() {
        Spinner.start()
    }

    func hideSpinner() {
        Spinner.stop()
    }

    func render(viewModel: MarvelDetailViewModel) {
        marvelImageView.kf.setImage(with: viewModel.imageURL)
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        title = viewModel.name
    }
}
