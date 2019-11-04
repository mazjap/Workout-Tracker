//
//  AppDelegate.swift
//  Workout Tracker
//
//  Created by Jordan Christensen on 8/31/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            Client.shared = try Client(dsn: "https://f00820e0e17b401c976d46cca963db9e@sentry.io/1806280")
            try Client.shared?.startCrashHandler()
        } catch {
            print("\(error)")
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
