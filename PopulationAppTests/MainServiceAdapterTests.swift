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

final class MainServiceAdapterTests: XCTestCase {
    func test_load_produces_CombinedLoaderResults() {
        let (sut, loader) = makeSUT()

        let results = getResult(sut)
        
        XCTAssertEqual(try? results?.get(), loader.stub)
    }
    
    func test_load_failsWithPostsLoaderError () {
        let (sut, loader) = makeSUT()
        loader.postsLoaderError = NSError(domain: "any", code: -1)

        let results = getResult(sut)
        
        XCTAssertEqual(results?.error as NSError?, loader.postsLoaderError)
    }
    
    func test_load_failsWithUsersLoaderError () {
        let (sut, loader) = makeSUT()
        loader.usersLoaderError = NSError(domain: "any", code: -1)

        let results = getResult(sut)
        
        XCTAssertEqual(results?.error as NSError?, loader.usersLoaderError)
    }
    
    func test_load_failsWithProductsLoaderError () {
        let (sut, loader) = makeSUT()
        loader.productsLoaderError = NSError(domain: "any", code: -1)

        let results = getResult(sut)
        
        XCTAssertEqual(results?.error as NSError?, loader.productsLoaderError)
    }
}

extension MainServiceAdapterTests {
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: MainLoaderAdapter, loader: LoaderStub) {
        let loader = LoaderStub()
        let sut = MainLoaderAdapter(postsLoader: loader, usersLoader: loader, productsLoader: loader)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
}

extension MainServiceAdapterTests {
    private func getResult (_ sut: MainLoaderAdapter) -> MainLoader.Result? {
        let expectation = expectation(description: "Wait to download service")
        
        var results: MainLoader.Result?
        
        sut.load {
            results = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.2)
        
        return results
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
        
        var postsLoaderError: NSError?
        var usersLoaderError: NSError?
        var productsLoaderError: NSError?

        func load(completion: @escaping (PostsLoaderResult) -> ()) {
            DispatchQueue.global().async {
                if let error = self.postsLoaderError {
                    completion(.failure(error))
                } else {
                    completion(.success(self.stub.posts))
                }
            }
        }
        
        func load(completion: @escaping (ProductsLoaderResult) -> ()) {
            DispatchQueue.global().async {
                if let error = self.productsLoaderError {
                    completion(.failure(error))
                } else {
                    completion(.success(self.stub.products))
                }
            }
        }
        
        func load(completion: @escaping (UsersLoaderResult) -> ()) {
            DispatchQueue.global().async {
                if let error = self.usersLoaderError {
                    completion(.failure(error))
                } else {
                    completion(.success(self.stub.users))
                }
            }
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
