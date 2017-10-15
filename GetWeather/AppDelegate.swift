//
//  AppDelegate.swift
//  GetWeather
//
//  Created by Jianyu ZHU on 13/10/17.
//  Copyright © 2017 Unimelb. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = WeatherViewController()
        
        return true
    }

    

}

