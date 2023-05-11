import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        
        configureWindow()
    }
    
    func configureWindow() {
         
         let remoteUserURL = URL (string: "https://dummyjson.com/users")!
         let remoteProductURL = URL (string: "https://dummyjson.com/products")!
         let remotePostURL = URL (string: "https://dummyjson.com/posts")!

        let remoteUserLoader = UsersRemoteLoader(url: remoteUserURL, client: httpClient)
        let remoteProductLoader = ProductsRemoteLoader(url: remoteProductURL, client: httpClient)
        let remotePostLoader = PostsRemoteLoader(url: remotePostURL, client: httpClient)

         let mainLoaderComposite = MainUIComposer.mainComposedWith(
            usersLoader: remoteUserLoader,
            productsLoader: remoteProductLoader,
            postsLoader: remotePostLoader
         )
         
         window?.rootViewController = UINavigationController(rootViewController: mainLoaderComposite)
         
         window?.makeKeyAndVisible()
     }
}

