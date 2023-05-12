import UIKit

public final class MainUIComposer {
    private init() {}
    
    public static func mainComposedWith (
        usersLoader: UsersLoader,
        productsLoader: ProductsLoader,
        postsLoader: PostsLoader
    ) -> UIViewController {
        
        let mainLoaderAdapter = MainLoaderAdapter(
            postsLoader: postsLoader,
            usersLoader: usersLoader,
            productsLoader: productsLoader
        )
        
        let loaderAdapter = MainLoaderPresentationAdapter(mainLoader: mainLoaderAdapter)
        
        let viewController = MainViewController.makeMainViewController(
            delegate: loaderAdapter,
            title: "Hola"
        )
        
        return viewController
    }
    
}

private extension MainViewController {
    static func makeMainViewController(delegate: MainViewControllerDelegate, title: String) -> UIViewController {
        let vc = MainViewController()
        vc.delegate = delegate
        vc.view.backgroundColor = .darkGray
        return vc
    }
}

