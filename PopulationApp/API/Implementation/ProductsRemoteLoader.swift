import Foundation

public final class ProductsRemoteLoader: ProductsLoader {
    
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = ProductsLoaderResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.getUrl(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(ProductsRemoteLoader.map(data: data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map (data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ProductsRemoteItemMapper.map(data, from: response)
            return .success(items.toModels())
        } catch let error {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteProductItem {
    func toModels() -> [Product] {
        return map {
            Product(
                id: $0.id,
                title: $0.title,
                description: $0.description,
                price: $0.price,
                discountPercentage: $0.discountPercentage,
                rating: $0.rating,
                stock: $0.stock,
                brand: $0.brand,
                category: $0.category,
                thumbnail: $0.thumbnail,
                images: $0.images
            )
        }
    }
}


