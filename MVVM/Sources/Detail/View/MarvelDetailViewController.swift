import Combine
import Kingfisher
import UIKit

protocol DetailViewContract: AnyObject {
    func render(viewModel: MarvelDetailViewModel)
}

class MarvelDetailViewController: UIViewController {
    @IBOutlet private weak var marvelImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    private lazy var viewModel: MarvelDetailViewModel = {
        MarvelDetailViewModel(apiClient: APIClient.shared, id: id)
    }()
    private var cancellables: Set<AnyCancellable> = []

    var id: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewLoaded()
        bindViewModel()
    }

    func bindViewModel() {
        viewModel.$state.sink { [weak self] state in
            guard let self else { return }

            switch state {
            case .initial:
                break
            case .loading:
                Spinner.start()
            case .render(let characterDetailModel):
                Spinner.stop()
                self.render(characterDetailModel)
            }
        }.store(in: &cancellables)
    }

    private func render(_ model: MarvelDetailModel) {
        marvelImageView.kf.setImage(with: model.imageURL)
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        title = model.name
    }
}
