import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var httpClient: HTTPClient = {
        //        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        HTTPClientFake(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var baseURL: String = {
        "https://dummyjson.com/"
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        configureWindow()
    }
    
    func configureWindow() {
        
        //        let remoteUserURL = URL (string: baseURL + "users")!
        //        let remoteProductURL = URL (string: baseURL + "products")!
        //        let remotePostURL = URL (string: baseURL + "posts")!
        
        guard let localUserURL = Bundle.main.url(forResource: "users", withExtension: "json") else {
            return
        }
        guard let localPostsURL = Bundle.main.url(forResource: "posts", withExtension: "json") else {
            return
        }
        guard let localProductsURL = Bundle.main.url(forResource: "products", withExtension: "json") else {
            return
        }
        
//        let remoteUserLoader = UsersRemoteLoader(url: remoteUserURL, client: httpClient)
//        let remoteProductLoader = ProductsRemoteLoader(url: remoteProductURL, client: httpClient)
//        let remotePostLoader = PostsRemoteLoader(url: remotePostURL, client: httpClient)
        
        let remoteUserLoader = UsersRemoteLoader(url: localUserURL, client: httpClient)
        let remoteProductLoader = ProductsRemoteLoader(url: localProductsURL, client: httpClient)
        let remotePostLoader = PostsRemoteLoader(url: localPostsURL, client: httpClient)
        
        let mainLoaderComposite = MainUIComposer.mainComposedWith(
            usersLoader: remoteUserLoader,
            productsLoader: remoteProductLoader,
            postsLoader: remotePostLoader
        )
        
        window?.rootViewController = UINavigationController(rootViewController: mainLoaderComposite)
        
        window?.makeKeyAndVisible()
    }
}

