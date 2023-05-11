import Foundation

public typealias ProductsLoaderResult = Swift.Result<[Product], Error>

public protocol ProductsLoader {
    func load(completion: @escaping (ProductsLoaderResult) -> ())
}
