//
//  AppDelegate.swift
//  ToDo
//
//  Created by hpc on 2020/1/19.
//  Copyright © 2020 hpc. All rights reserved.
//

import UIKit
import UserNotifications
@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerNotifications(application)
        return true
    }
    //MARK:  注册推送
    func registerNotifications(_ application: UIApplication) {
        //-- 注册推送
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self as? UNUserNotificationCenterDelegate
            center.getNotificationSettings { (setting) in
                if setting.authorizationStatus == .notDetermined{
                    center.requestAuthorization(options: [.badge,.sound,.alert]) { (result, error) in
                        print("显示内容：\(result) error：\(String(describing: error))")
                        if(result){
                            if !(error != nil){
                                print("注册成功了！")
                                application.registerForRemoteNotifications()
                            }
                        } else{
                            print("用户不允许推送")
                        }
                    }
                } else if (setting.authorizationStatus == .denied){
                    
                }else if (setting.authorizationStatus == .authorized){
                    
                    self.registerForRemoteNotifications()
                }else{
                    
                }
            }
        }
    }
        

    // 注册通知，获取deviceToken
    func registerForRemoteNotifications() {
        // 请求授权时异步进行的，这里需要在主线程进行通知的注册
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

