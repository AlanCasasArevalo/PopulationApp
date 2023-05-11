import UIKit

protocol MainViewControllerDelegate {
    func didRequestRefresh()
}

class MainViewController: UIViewController {
    var delegate: MainViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didRequestRefresh()
    }
}
