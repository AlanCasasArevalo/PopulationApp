import Foundation

class MainLoaderAdapter: MainLoader {
    let postsLoader: PostsLoader
    let usersLoader: UsersLoader
    let productsLoader: ProductsLoader
    
    private let queue = DispatchQueue(label: "MainLoaderAdapter")
    
    init(postsLoader: PostsLoader, usersLoader: UsersLoader, productsLoader: ProductsLoader) {
        self.postsLoader = postsLoader
        self.usersLoader = usersLoader
        self.productsLoader = productsLoader
    }
    
    struct PartialResult {
        var posts: [Post]?{
            didSet { checkCompletion() }
        }
        
        var users: [User]?{
            didSet { checkCompletion() }
        }
        
        var products: [Product]?{
            didSet { checkCompletion() }
        }

        var error: Error?{
            didSet { checkCompletion() }
        }
        
        var completion: ((MainLoader.Result) -> ())?
        
        private mutating func checkCompletion() {
            if let error = error {
                completion?(.failure(error))
                completion = nil
            } else if let posts = posts, let users = users, let products = products {
                completion?(
                    .success(
                        MainModel(posts: posts, users: users, products: products)
                    )
                )
                completion = nil
            }
        }
    }
    
    func load(completion: @escaping (MainLoader.Result) -> ()) {
        
        var partialResult = PartialResult(completion: completion)
        
        postsLoader.load { result in
            self.queue.sync {
                switch result {
                case .success(let value):
                    partialResult.posts = value
                case .failure(let error):
                    partialResult.error = error
                }
            }
        }
        
        usersLoader.load { result in
            self.queue.sync {
                switch result {
                case .success(let value):
                    partialResult.users = value
                case .failure(let error):
                    partialResult.error = error
                }
            }
        }
        
        productsLoader.load { result in
            self.queue.sync {
                switch result {
                case .success(let value):
                    partialResult.products = value
                case .failure(let error):
                    partialResult.error = error
                }
            }
        }
    }
}
