//
//  SceneDelegate.swift
//  ShahrYar
//
//  Created by Sina Rabiei on 5/4/20.
//  Copyright © 2020 Sina Rabiei. All rights reserved.
//

import UIKit

@available(iOS 13, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func showRootView(id: String) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: id)
            if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
                    window.rootViewController = vc
                    self.window = window
                    window.makeKeyAndVisible()
                }
        }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
//         let userLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//
//         if userLoggedIn == true {
//            showRootView(id: "homeVc")
//             print("YES")
//         } else {
//             print("NO")
//            showRootView(id: "introVc")
//        }
        
        
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
//        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
//        window = UIWindow(windowScene: windowScene)
//        
//        let isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let mainVC = mainStoryboard.instantiateViewController(withIdentifier: "homeVc") as! HomeViewController
//        let logInVC = mainStoryboard.instantiateViewController(withIdentifier: "introVc") as! IntroViewController
//        let rootVC = isLoggedIn ? mainVC : logInVC
//        
//        window?.rootViewController = rootVC
//        window?.makeKeyAndVisible()
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

