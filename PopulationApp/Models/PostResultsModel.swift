import Foundation

// MARK: - PostResultsModel
public struct PostResultsModel: Equatable {
    let posts: [Post]?
    let total, skip, limit: Int?
    
    public init(posts: [Post]?, total: Int?, skip: Int?, limit: Int?) {
        self.posts = posts
        self.total = total
        self.skip = skip
        self.limit = limit
    }
}

// MARK: - Post
public struct Post: Equatable {
    let id: Int?
    let title, body: String?
    let userId: Int?
    let tags: [String]?
    let reactions: Int?
    
    public init(id: Int?, title: String?, body: String?, userId: Int? = 1, tags: [String]?, reactions: Int?) {
        self.id = id
        self.title = title
        self.body = body
        self.userId = userId
        self.tags = tags
        self.reactions = reactions
    }
}
