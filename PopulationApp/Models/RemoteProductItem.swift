import Foundation

internal struct RemoteProductItem : Decodable {
    internal let id: Int
    internal let title, description: String?
    internal let price: Int?
    internal let discountPercentage, rating: Double?
    internal let stock: Int?
    internal let brand, category: String?
    internal let thumbnail: String?
    internal let images: [String]?
}
