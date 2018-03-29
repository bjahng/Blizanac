//
//  AppDelegate.swift
//  Blizanac
//
//  Created by admin on 3/20/18.
//  Copyright © 2018 DoughDoughTech. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do {
            _ = try Realm()
        } catch {
            fatalError("Error initializing new realm: \(error)")
        }
        
        return true
        
    }

}

