import Kingfisher
import UIKit

protocol MarvelDetailViewContract: AnyObject {
    func showSpinner()
    func hideSpinner()
    func render(viewModel: MarvelDetailViewModel)
}

class MarvelDetailViewController: UIViewController {
    @IBOutlet private weak var marvelImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    private lazy var presenter: MarvelDetailPresenterContract = {
        let getCharacterDetailUseCase = GetMarvelCharacterDetailUseCase(marvelCharacterDetailRepository: MarvelCharacterDetailRepository())
        return MarvelDetailPresenter(view: self,
                                     getCharacterDetailUseCase: getCharacterDetailUseCase,
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
