import Foundation

protocol LocalFileManagerType {
    func readJSONFile<T: Decodable>(with url: URL) throws -> T
}

final class LocalFileManager: LocalFileManagerType {
    func readJSONFile<T: Decodable>(with url: URL) throws -> T {
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
