import Foundation

public final class PostsRemoteLoader: PostsLoader {
    
    private let client: HTTPClient
    private let url: URL

    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }

    public typealias Result = PostsLoaderResult
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (Result) -> Void) {
        client.getUrl(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(PostsRemoteLoader.map(data: data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map (data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try PostsRemoteItemMapper.map(data, from: response)
            return .success(items.toModels())
        } catch let error {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemotePostItem {
    func toModels() -> [Post] {
        return map {
            Post(id: $0.id, title: $0.title, body: $0.body, tags: $0.tags, reactions: $0.reactions)
        }
    }
}

