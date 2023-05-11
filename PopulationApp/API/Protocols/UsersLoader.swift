import Foundation

public typealias UsersLoaderResult = Swift.Result<[User], Error>

public protocol UsersLoader {
    func load(completion: @escaping (UsersLoaderResult) -> ())
}
