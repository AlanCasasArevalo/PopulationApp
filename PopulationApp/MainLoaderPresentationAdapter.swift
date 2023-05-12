import Foundation

final class MainLoaderPresentationAdapter: MainViewControllerDelegate {
    private let mainLoader: MainLoader

    init(mainLoader: MainLoader) {
        self.mainLoader = mainLoader
    }
        
    func didRequestRefresh() {
        mainLoader.load { [weak self] result in
            switch result {
            case let .success(mainResult):
                print("Success => result")
            case let .failure(error):
                print(error)
            }
        }
    }
}

