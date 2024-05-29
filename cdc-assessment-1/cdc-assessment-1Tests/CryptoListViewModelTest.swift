import XCTest
@testable import cdc_assessment_1
import RxBlocking
import RxSwift
import RxTest

final class CryptoListViewModelTests: XCTestCase {
    var subject: CryptoListViewModel!
    
    override func setUp() {
        super.setUp()
        subject = CryptoListViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        subject = nil
    }
    
    func test_loadCryptos_successfully() {
        subject = CryptoListViewModel()
        
        let result = subject.loadCryptos()
            .toBlocking()
            .materialize()
        
        switch result {
        case .completed(let elements):
            XCTAssertEqual(elements.first, cryptos)
        case .failed(_, let error):
            XCTFail("Expected result to complete without error, but received \(error).")
        }
    }
    
    func test_loadCryptos_failedWithInvalidResourcePath() {
        let url: URL? = testBundle.url(forResource: "crypto_list", withExtension: "json")
        subject = CryptoListViewModel(resourceURL: url)
        
        let result = subject.loadCryptos()
            .toBlocking()
            .materialize()
        
        switch result {
        case .completed(let elements):
            XCTFail("Expected result to complete with an error, but received elements \(elements).")
        case .failed(_, let error):
            XCTAssertEqual(error as? RequestError, RequestError.invalidFilePath)
        }
    }

    func test_loadCryptos_failedWithJSONDecodingError() {
        let url: URL? = testBundle.url(forResource: "invalid_objects", withExtension: "json")
        subject = CryptoListViewModel(resourceURL: url)
        
        let result = subject.loadCryptos()
            .toBlocking()
            .materialize()
        
        switch result {
        case .completed(let elements):
            XCTFail("Expected result to complete with an error, but received elements \(elements).")
        case .failed(_, let error):
            XCTAssertEqual(error as? RequestError, RequestError.decodingFailed)
        }
    }
}

private extension CryptoListViewModelTests {
    var testBundle: Bundle { Bundle(for: type(of: self)) }
    
    var cryptos: [Crypto] {
        [
            Crypto(title: "Cronos"),
            Crypto(title: "Bitcoin"),
            Crypto(title: "Ethereum"),
        ]
    }
}
