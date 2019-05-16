//
//  AppDelegate.swift
//  LavaCrawler
//
//  Created by Jarvis on 2019/5/16.
//  Copyright © 2019 JQTech. All rights reserved.
//

import UIKit
import Firebase
import LeanCloud

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 对象存储
        configLeanCloud()
        lcTest()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}



extension AppDelegate {
    func configLeanCloud() {
        LCApplication.default.set(id:  "5dDL7DnX1EsrhMGa006nna2H-gzGzoHsz", key: "bvJxHMx1zB4Vrnx46xw35gRs")
        LCApplication.default.logLevel = .debug
        
        //        lcTest()
    }
    
    func lcTest() {
        let test = LCObject(className: "Test")
        
        try? test.set("id", value: "1")
        try? test.set("words", value: "Hello World!")
        
        _ = test.save { result in
            switch result {
            case .success:
                print("test update success")
                break
            case .failure(let error):
                print("test update failed: \(error)")
                break
            }
        }
    }
    
    func registerSubclasses() {
        LCRadio.register()
        LCChannel.register()
    }
}
