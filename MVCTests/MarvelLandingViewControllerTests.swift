import XCTest

@testable import MVC

final class MarvelLandingViewControllerTests: XCTestCase {
    func test_canInit() throws {
        let _ = try makeSUT()
    }

    func test_tableView_datasourceAndDelegateCannotNil() throws {
        let landingViewController = try makeSUT()
        landingViewController.loadViewIfNeeded()
        XCTAssertNotNil(landingViewController.tableView.dataSource, "Expecting datasource")
        XCTAssertNotNil(landingViewController.tableView.delegate, "Expecting delegate")
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> MarvelLandingViewController {
        let bundle = Bundle(for: MarvelLandingViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let landingViewController = navigationController?.topViewController as? MarvelLandingViewController
        landingViewController?.apiClient = APIClientMock()
        return try XCTUnwrap(landingViewController, file: file, line: line)
    }
}

class APIClientMock: APIProtocol {
    func get<T: Codable>(endpoint: Endpoint, completion: @escaping (Result<T, NetworkError>) -> Void) {
    }
}
