import Foundation

internal class PostsRemoteItemMapper {

    private struct Root: Decodable {
        let posts: [RemotePostItem]
    }

    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemotePostItem] {
        guard response.isOK,
              let root = try? JSONDecoder().decode(Root.self, from: data) else { throw PostsRemoteLoader.Error.invalidData }
        return root.posts
    }
}

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

