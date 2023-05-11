import Foundation

// MARK: - ProductResultsModel
public struct ProductResultsModel {
    let products: [Product]?
    let total, skip, limit: Int?
    
    public init(products: [Product]?, total: Int?, skip: Int?, limit: Int?) {
        self.products = products
        self.total = total
        self.skip = skip
        self.limit = limit
    }
}

// MARK: - Product
public struct Product {
    let id: Int?
    let title, description: String?
    let price: Int?
    let discountPercentage, rating: Double?
    let stock: Int?
    let brand, category: String?
    let thumbnail: String?
    let images: [String]?
    
    public init(id: Int?, title: String?, description: String?, price: Int?, discountPercentage: Double?, rating: Double?, stock: Int?, brand: String?, category: String?, thumbnail: String?, images: [String]?) {
        self.id = id
        self.title = title
        self.description = description
        self.price = price
        self.discountPercentage = discountPercentage
        self.rating = rating
        self.stock = stock
        self.brand = brand
        self.category = category
        self.thumbnail = thumbnail
        self.images = images
    }
}
