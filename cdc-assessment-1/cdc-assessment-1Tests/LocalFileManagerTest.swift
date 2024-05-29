import XCTest
@testable import cdc_assessment_1

final class LocalFileManagerTests: XCTestCase {
    var subject: LocalFileManager!
    
    override func setUp() {
        super.setUp()
        subject = LocalFileManager()
    }
    
    override func tearDown() {
        super.tearDown()
        subject = nil
    }
    
    func test_readJSONFile_successfully() {
        let fileURL: URL = Bundle.main.url(forResource: "crypto_list", withExtension: "json")!
        let expectedCryptos: [Crypto] = cryptos
        do {
            let cryptoList: CryptoList = try subject.readJSONFile(with: fileURL)
            XCTAssertEqual(cryptoList.cryptos, expectedCryptos)
        } catch {
            XCTFail("Should not catch any error")
        }
    }
    
    func test_readJSONFile_FailedWithInvalidURL() {
        let fileURL: URL = Bundle.main.url(forResource: "", withExtension: "json")!
        do {
            let _: CryptoList = try subject.readJSONFile(with: fileURL)
        } catch {
            XCTAssertThrowsError("Test should fail for invalid file path")
        }
    }
}

private var cryptos: [Crypto] {
    [
        Crypto(title: "Cronos"),
        Crypto(title: "Bitcoin"),
        Crypto(title: "Ethereum"),
    ]
}
