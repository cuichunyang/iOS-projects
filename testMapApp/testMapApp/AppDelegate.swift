//
//  AppDelegate.swift
//  testMapApp
//
//  Created by cuichunyang on 2020/03/28.
//  Copyright © 2020 cuichunyang. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    
    func loadLocation()
    {
     
        locationManager.delegate = self as? CLLocationManagerDelegate
        //定位方式
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
     
         //iOS8.0以上才可以使用
        if(UIDevice.current.systemVersion >= "8.0"){
            //始终允许访问位置信息
            locationManager.requestAlwaysAuthorization()
            //使用应用程序期间允许访问位置数据
            locationManager.requestWhenInUseAuthorization()
        }
        //开启定位
        locationManager.startUpdatingLocation()
    }
     
    
   
    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
     
     
      //开启定位
        loadLocation()
     
     return true
    }
   //获取定位信息
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
       //取得locations数组的最后一个
       let location:CLLocation = locations[locations.count-1]
    _ = locations.last!
       //判断是否为空
       if(location.horizontalAccuracy > 0){
        let lat = Double(String(format: "%.1f", location.coordinate.latitude))
        let long = Double(String(format: "%.1f", location.coordinate.longitude))
           print("纬度:\(long!)")
           print("经度:\(lat!)")
           
           //停止定位
           locationManager.stopUpdatingLocation()
       }
    
   }
    
   //出现错误
   func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
    print(error ?? 1)
   }
    
}
    
   


