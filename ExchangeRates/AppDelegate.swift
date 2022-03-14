//
//  AppDelegate.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                        
        self.configureRootViewController()
                
        self.setupUIAppearance()
        return true
    }
    
}

// MARK: - Additional Methods
extension AppDelegate {
    
    fileprivate func setupUIAppearance() {
    }
    
    fileprivate func configureRootViewController() {
        let rootWireframe = RootWireframe()
        let viewController = rootWireframe.createModule()
        
        if let window = self.window {
            window.rootViewController = viewController
        }
    }
    
}


