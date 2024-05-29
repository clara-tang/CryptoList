
struct CryptoList: Codable {
    let cryptos: [Crypto]
    
    private enum CodingKeys: String, CodingKey {
        case cryptos     = "data"
    }
}

struct Crypto: Codable {
    let title: String
}

extension Crypto: Equatable {}
