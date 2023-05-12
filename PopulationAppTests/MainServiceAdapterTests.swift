import XCTest
import PopulationApp

struct MainModel: Equatable {
    let posts: [Post]
    let users: [User]
    let products: [Product]
}

protocol MainLoader {
    typealias Result = Swift.Result<MainModel, Error>
    
    func load(completion: @escaping (Result) -> ())
}

class MainLoaderAdapter: MainLoader {
    let postsLoader: PostsLoader
    let usersLoader: UsersLoader
    let productsLoader: ProductsLoader
    
    init(postsLoader: PostsLoader, usersLoader: UsersLoader, productsLoader: ProductsLoader) {
        self.postsLoader = postsLoader
        self.usersLoader = usersLoader
        self.productsLoader = productsLoader
    }
    
    func load(completion: @escaping (MainLoader.Result) -> ()) {
        
    }
}

final class MainServiceAdapterTests: XCTestCase {
    func test() {
        let loader = LoaderStub()
        
        let sut = MainLoaderAdapter(
            postsLoader: loader,
            usersLoader: loader,
            productsLoader: loader
        )
        
        let expectation = expectation(description: "Wait to download service")
        
        var results: MainLoader.Result?
        
        sut.load {
            results = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
        
        XCTAssertEqual(try? results?.get(), loader.stub)
    }
}

extension MainServiceAdapterTests {
    private class LoaderStub: PostsLoader, ProductsLoader, UsersLoader  {
        let stub = MainModel(
            posts: [
                Post(
                    id: 0,
                    title: "any",
                    body: "any",
                    tags: ["any"],
                    reactions: 1
                )
            ],
            users: [
                User(id: 0,
                     firstName: "any",
                     lastName: "any",
                     maidenName: "any",
                     age: -1,
                     email: "any",
                     phone: "any",
                     username: "any",
                     password: "any",
                     birthDate: "any",
                     image: "any",
                     bloodGroup: "any",
                     height: -1,
                     weight: -1,
                     domain: "any",
                     ip: "any",
                     macAddress: "any",
                     university: "any",
                     ein: "any",
                     ssn: "any",
                     userAgent: "any"
                    )
            ],
            products: [
                Product(
                    id: -1,
                    title: "any",
                    description: "any",
                    price: -1,
                    discountPercentage: -1,
                    rating: -1,
                    stock: -1,
                    brand: "any",
                    category: "any",
                    thumbnail: "any",
                    images: ["any"]
                )
            ]
        )
        func load(completion: @escaping (PostsLoaderResult) -> ()) {
            
        }
        
        func load(completion: @escaping (ProductsLoaderResult) -> ()) {
            
        }
        
        func load(completion: @escaping (UsersLoaderResult) -> ()) {
            
        }
    }
}
