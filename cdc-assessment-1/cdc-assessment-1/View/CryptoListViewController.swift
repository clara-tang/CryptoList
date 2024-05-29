import UIKit
import RxCocoa
import RxSwift

final class CryptoListViewController: UIViewController {
    
    // MARK: - UI Components
    @IBOutlet private weak var cryptoTableView: UITableView!
    
    private lazy var loadButton: UIButton = {
        let button: UIButton = UIButton()
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: self.view.frame.width/2.0),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
        
        return button
    }()
    
    // MARK: - Private Properties
    private let viewModel: CryptoListViewModelType = CryptoListViewModel()

    private var disposeBag: DisposeBag = .init()
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // MARK: - Private Methods
    private func setupUI() {
        setupLoadButton()
        setupCryptoTableView()
    }
    
    private func setupLoadButton() {
        loadButton.setTitleColor(UIColor.blue, for: .normal)
        loadButton.setTitle (Constants.loadButtonTitle, for: [])
        loadButton.addTarget(self, action: #selector(loadCryptos), for: .touchUpInside)
    }

    private func bindViewModel() {
        let cellIdentifier: String = CryptoCell.reuseIdentifier
        viewModel.cryptoSubject
            .bind(to: cryptoTableView.rx.items(cellIdentifier: cellIdentifier, cellType: CryptoCell.self)) { (_, model: Crypto, cell: CryptoCell) in
                cell.setTitle(model.title)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorSubject
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                let alert = UIAlertController(title: Constants.errorMessageTitle,
                                              message: String(describing: error),
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Constants.errorButtonTitle, style: .default))
                self?.present(alert, animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func setupCryptoTableView() {
        cryptoTableView.isHidden = true
        cryptoTableView.delegate = self
        cryptoTableView.register(
            CryptoCell.self,
            forCellReuseIdentifier: CryptoCell.reuseIdentifier
        )
    }
    
    @objc private func loadCryptos() {
        updateView()

        _ = viewModel.loadCryptos()
            .subscribe()
    }
    
    private func updateView() {
        loadButton.isHidden = true
        cryptoTableView.isHidden = false
    }
}

// MARK: - UITableViewDelegate
extension CryptoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cryptoDetailVC = CryptoDetailViewController()
        navigationController?.pushViewController(cryptoDetailVC, animated: true)
    }
}

private extension CryptoListViewController {
    private enum Constants {
        static let loadButtonTitle: String = "Load Crypto"
        static let errorMessageTitle: String = "Load Crypto With Error"
        static let errorButtonTitle: String = "Dismiss"
        static let buttonHeight: CGFloat = 100.0
        static let cellHeight: CGFloat = 100.0
    }
}
