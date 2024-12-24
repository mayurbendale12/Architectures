import Core
import UIKit

class MarvelLandingViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private(set) var searchController = UISearchController()
    private lazy var viewModel: MarvelLandingViewModelContract = { MarvelLandingViewModel(apiClient: APIClient.shared,
                                                                                          navigator: MarvelLandingNavigator(viewController: self))
    }()
    private var characterModels = [LandingMarvelCharacterModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "marvel_landing_screen_navigation_title".localize()
        setupTableView()
        setupSearchController()
        bindViewModel()
        viewModel.viewLoaded()
    }

    private func setupSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "marvel_search_placeholder_text".localize()
        navigationItem.searchController = searchController
    }

    private func setupTableView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: MarvelCharacterCell.self), bundle: bundle)

        tableView.register(nib, forCellReuseIdentifier: String(describing: MarvelCharacterCell.self))
        tableView.tableFooterView = UIView()
    }

    private func bindViewModel() {
        viewModel.state.bind { [weak self] state in
            guard let self else { return }

            switch state {
            case .initial:
                break
            case .loading:
                Spinner.start()
            case .render(let characterModels):
                Spinner.stop()
                self.characterModels = characterModels
                self.tableView.reloadData()
            }
        }
    }
}

extension MarvelLandingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let marvelCharacterCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MarvelCharacterCell.self)) as? MarvelCharacterCell else {
            return UITableViewCell()
        }
        let model = characterModels[indexPath.row]
        marvelCharacterCell.setup(name: model.name, imageUrl: model.imageUrl)
        return marvelCharacterCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(at: indexPath.row)
    }
}

extension MarvelLandingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didTapSearchButton(text: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didChangeSearchText(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didTapSearchCancelButton()
    }
}
