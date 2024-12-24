import Core
import UIKit

struct MarvelLandingViewModel {
    let name: String
    let imageURL: URL?
}

protocol MarvelLandingViewContract: AnyObject {
    func showSpinner()
    func hideSpinner()
    func render(viewModels: [MarvelLandingViewModel])
}

class MarvelLandingViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!

    private(set) var searchController = UISearchController()
    private lazy var viewModels: [MarvelLandingViewModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private lazy var presenter: MarvelLandingPresenterContract = {
        let interactor: MarvelLandingInteractorContract = MarvelLandingInteractor()
        let router: MarvelLandingRouterContract = MarvelLandingRouter(viewController: self)
        return MarvelLandingPresenter(view: self,
                                      interactor: interactor,
                                      router: router)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "marvel_landing_screen_navigation_title".localize()
        setupTableView()
        setupSearchController()
        presenter.viewLoaded()
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
}

extension MarvelLandingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let marvelCharacterCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MarvelCharacterCell.self)) as? MarvelCharacterCell else {
            return UITableViewCell()
        }
        let model = viewModels[indexPath.row]
        marvelCharacterCell.setup(name: model.name, imageUrl: model.imageURL)
        return marvelCharacterCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelect(at: indexPath.row)
    }
}

extension MarvelLandingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didTapSearchBUtton(text: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didChangeSearchText(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.didTapSearchCancelButton()
    }
}

extension MarvelLandingViewController: MarvelLandingViewContract {
    func showSpinner() {
        Spinner.start()
    }

    func hideSpinner() {
        Spinner.stop()
    }
    
    func render(viewModels: [MarvelLandingViewModel]) {
        self.viewModels = viewModels
    }
}
