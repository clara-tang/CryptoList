import Foundation
import RxSwift

// MARK: - CryptoListViewModelType
protocol CryptoListViewModelType {
    var cryptoSubject: PublishSubject<[Crypto]> { get }
    var errorSubject: PublishSubject<Error> { get }
    func loadCryptos() -> Single<[Crypto]>
}

final class CryptoListViewModel: CryptoListViewModelType {
    public init(fileManager: LocalFileManagerType = LocalFileManager(),
                resourceURL: URL? = Constants.resourceURL) {
        self.fileManager = fileManager
        self.resourceURL = resourceURL
    }
    
    // MARK: - Public Properties
    public let cryptoSubject: PublishSubject<[Crypto]> = .init()
    public let errorSubject: PublishSubject<Error> = .init()
    
    // MARK: - Private Properties
    private let fileManager: LocalFileManagerType
    private let resourceURL: URL?
    
    // MARK: - Public Methods
    public func loadCryptos() -> Single<[Crypto]> {
        guard let url = resourceURL else {
            let error: RequestError = .invalidFilePath
            errorSubject.onNext(error)
            return .error(error)
        }
        do {
            let cryptoList: CryptoList = try fileManager.readJSONFile(with: url)
            let cryptos: [Crypto] = cryptoList.cryptos
            cryptoSubject.onNext(cryptos)
            return .just(cryptos)
        } catch {
            let error: RequestError = .decodingFailed
            errorSubject.onNext(error)
            return .error(error)
        }
    }
}

private extension CryptoListViewModel {
    enum Constants {
        static let resourceURL: URL? = Bundle.main
            .url(forResource: "crypto_list", withExtension: "json")
    }
}
