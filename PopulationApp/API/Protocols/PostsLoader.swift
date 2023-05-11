import Foundation

public typealias PostsLoaderResult = Swift.Result<[Post], Error>

public protocol PostsLoader {
    func load(completion: @escaping (PostsLoaderResult) -> ())
}

