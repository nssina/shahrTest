//
//  UIExtensions.swift
//  ShahrYar
//
//  Created by Sina Rabiei on 5/6/20.
//  Copyright © 2020 Sina Rabiei. All rights reserved.
//

import UIKit

extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }
}

extension Hashable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}




class UIExtensions: UIViewController {

    
    static let shared = UIExtensions()
    
    fileprivate var currentVc: UIViewController?
    
    func hideNavigationBar(vc: UIViewController) {
        currentVc = vc
        currentVc?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        currentVc?.navigationController?.navigationBar.shadowImage = UIImage()
        currentVc?.navigationController?.navigationBar.isTranslucent = true
        currentVc?.navigationController?.navigationBar.tintColor = .white
    }
    
    func setCornerRedius(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.width / 2
    }
}