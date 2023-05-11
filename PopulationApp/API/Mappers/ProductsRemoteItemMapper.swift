import Foundation

internal class ProductsRemoteItemMapper {

    private struct Root: Decodable {
        let products: [RemoteProductItem]
    }

    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [RemoteProductItem] {
        guard response.isOK,
              let root = try? JSONDecoder().decode(Root.self, from: data) else { throw PostsRemoteLoader.Error.invalidData }
        return root.products
    }
}
