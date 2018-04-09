//
//  AppDelegate.swift
//  mvPhotosApp
//
//  Created by Mikhail Kirillov on 09/04/2018.
//  Copyright © 2018 Mikhail Kirillov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navController = UINavigationController.init(rootViewController: FilterViewController())
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

