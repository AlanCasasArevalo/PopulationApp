import Foundation

final class MainLoaderPresentationAdapter: MainViewControllerDelegate {
    private let postsLoader: PostsLoader
    private let productsLoader: ProductsLoader
    private let usersLoader: UsersLoader
    
    init(postsLoader: PostsLoader, productsLoader: ProductsLoader, usersLoader: UsersLoader) {
        self.postsLoader = postsLoader
        self.productsLoader = productsLoader
        self.usersLoader = usersLoader
    }
    
    func didRequestRefresh() {
        postsLoader.load { [weak self] result in
            switch result {
            case let .success(posts):
                print(posts)
            case let .failure(error):
                print(error)
            }
        }
                
        usersLoader.load { [weak self] result in
            switch result {
            case let .success(users):
                print(users)
            case let .failure(error):
                print(error)
            }
        }
                        
        productsLoader.load { [weak self] result in
            switch result {
            case let .success(products):
                print(products)
            case let .failure(error):
                print(error)
            }
        }
    }
}

