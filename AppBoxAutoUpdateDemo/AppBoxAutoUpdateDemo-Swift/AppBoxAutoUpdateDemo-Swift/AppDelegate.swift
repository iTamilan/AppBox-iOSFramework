//
//  AppDelegate.swift
//  AppBoxAutoUpdateDemo-Swift
//
//  Created by Vineet Choudhary on 02/02/17.
//  Copyright © 2017 Developer Insider. All rights reserved.
//

import UIKit
import AppBox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Check for update
        AppNewVersionNotifier.initWithKey("49lsofdx9lsi61j")
        
        return true
    }

}

