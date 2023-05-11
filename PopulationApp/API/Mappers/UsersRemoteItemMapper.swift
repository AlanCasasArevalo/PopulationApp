import Foundation

internal class UsersRemoteItemMapper {

    private struct Root: Decodable {
        let users: [RemoteUserItem]
    }

    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteUserItem] {
        guard response.isOK,
              let root = try? JSONDecoder().decode(Root.self, from: data) else { throw UsersRemoteLoader.Error.invalidData }
        return root.users
    }
}
