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
        
        setUpViewHirerachy()
        setUpCoreData()
        
        return true
    }

    private func setUpViewHirerachy() {
        let navController = UINavigationController.init(rootViewController: FilterViewController())

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    private func setUpCoreData() {
        _ = DataBaseHelper.shared
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        do {
            try DataBaseHelper.shared.mainContext.save()
        } catch {
            debugPrint(error)
        }
    }
}

