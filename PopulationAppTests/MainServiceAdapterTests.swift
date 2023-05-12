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
        postsLoader.load { posts in
            if case let .failure(error) = posts {
                return completion(.failure(error))
            }
            
            self.usersLoader.load { users in
                self.productsLoader.load { products in
                    completion(.success(MainModel(
                        posts: try! posts.get(),
                        users: try! users.get(),
                        products: try! products.get()))
                    )
                }
            }
        }
    }
}

final class MainServiceAdapterTests: XCTestCase {
    func test_load_produces_CombinedLoaderResults() {
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
    
    func test_load_failsWithPostsLoaderError () {
        let loader = LoaderStub()
        loader.postLoaderError = NSError(domain: "any", code: -1)
        
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
        
        XCTAssertEqual(results?.error as NSError?, loader.postLoaderError)
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
        
        var postLoaderError: NSError?
        
        func load(completion: @escaping (PostsLoaderResult) -> ()) {
            if let error = postLoaderError {
                completion(.failure(error))
            } else {
                completion(.success(stub.posts))
            }
        }
        
        func load(completion: @escaping (ProductsLoaderResult) -> ()) {
            completion(.success(stub.products))
        }
        
        func load(completion: @escaping (UsersLoaderResult) -> ()) {
            completion(.success(stub.users))
        }
    }
}

private extension Result {
    var error: Failure? {
        switch self {
        case .success:
            return nil
        case let .failure(error):
            return error
        }
    }
}
