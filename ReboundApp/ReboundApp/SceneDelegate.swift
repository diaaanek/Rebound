//
//  SceneDelegate.swift
//  ReboundApp
//
//  Created by Ethan Keiser on 2/23/22.
//
import Swiftagram
import UIKit
import ReboundiOS
import Rebound
import WebKit
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    lazy var path = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    lazy var cache = try! CoreDataStore(storeURL: path.appendingPathComponent("test.sqlite"))

    var window: UIWindow?
    var bin: Set<AnyCancellable> = []
    @Published private(set) var current: User?
    var navigationController = UINavigationController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let mainNavigationFlow = MainNavigationFlow(coreDateCache: cache)
        let rv = MainFeedComposer().makeMainFeedController(cache: self.cache, mainNavigationFlow: mainNavigationFlow)
        mainNavigationFlow.refreshData = { rv.reloadCollectionView() }
        let introController = IntroComposer().makeIntro(navigation: {
            self.navigationController.setViewControllers([rv], animated: true)
        }, secretCompletion: { secret in
            let data =  try! Secret.encoding(secret)
            let userDefaults = UserDefaults()
            userDefaults.set(data, forKey: "secret")
            userDefaults.synchronize()
        })
        
        if let secretData = UserDefaults.standard.data(forKey: "secret") {
            navigationController = UINavigationController(rootViewController: rv)
            let secret = try! Secret.decoding(secretData)
            print(secret.identifier)
        } else {
            self.navigationController = UINavigationController(rootViewController: introController)
        }
        
        mainNavigationFlow.accountNavigation = AccountNavigation(intro: introController, navigation: self.navigationController)
        NotificationPolicy.getNotificationSettings()
        mainNavigationFlow.navigationController = navigationController
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

