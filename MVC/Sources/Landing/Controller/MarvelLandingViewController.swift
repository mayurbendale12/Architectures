import UIKit

class MarvelLandingViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView!

    private(set) var marvels = [MarvelResult]()
    private(set) var filterdMarvels: [MarvelResult] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private(set) var searchController = UISearchController()
    var apiClient: APIProtocol = APIClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchMarvelList()
        setupSearchController()
        title = "marvel_landing_screen_navigation_title".localize()
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

    private func fetchMarvelList() {
        Spinner.start()

        apiClient.get(endpoint: .list) { [weak self] (result: Result<MarvelCharacterModel, NetworkError>) in
            guard let self else { return }
            Spinner.stop()
            switch result {
            case .success(let model):
                self.marvels = model.data?.results ?? []
                self.filterdMarvels = self.marvels
            case .failure(let error):
                print(error.errorDescription)
            }
        }
    }
}

extension MarvelLandingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterdMarvels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let marvelCharacterCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MarvelCharacterCell.self)) as? MarvelCharacterCell else {
            return UITableViewCell()
        }
        let marvelModel = filterdMarvels[indexPath.row]

        marvelCharacterCell.setup(name: marvelModel.name ?? "",
                                  imageUrl: marvelModel.thumbnail?.url)
        return marvelCharacterCell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let marvel = filterdMarvels[indexPath.row]
        let marvelDetailViewController = MarvelDetailViewController.instantiate()
        marvelDetailViewController.id = marvel.id
        navigationController?.pushViewController(marvelDetailViewController, animated: true)
    }
}

extension MarvelLandingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fiterMarvelResults(searchText: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        fiterMarvelResults(searchText: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterdMarvels = marvels
    }

    private func fiterMarvelResults(searchText: String) {
        guard !searchText.isEmpty else {
            filterdMarvels = marvels
            return
        }

        filterdMarvels = marvels.filter { ($0.name ?? "").localizedCaseInsensitiveContains(searchText) }
    }
}
