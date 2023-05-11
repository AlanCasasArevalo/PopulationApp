import Foundation

internal struct RemotePostItem : Decodable {
    internal let id: Int
    internal let title: String?
    internal let body: String?
    internal let tags: [String]?
    let reactions: Int?
}
