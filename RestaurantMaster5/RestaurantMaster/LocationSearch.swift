//
//  LocationSearch.swift
//  RestaurantMaster
//
//  Created by cuichunyang on 2020/03/22.
//  Copyright © 2020 cuichunyang. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation


class LocationSearch: UIViewController , UITextFieldDelegate , CLLocationManagerDelegate {
   

    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    
    override func viewDidLoad() {
           super.viewDidLoad()
           inputText.delegate = self
           
    
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //キーボードを閉じる(1)
        textField.resignFirstResponder()
        
        
        //入力された文字を取り出す(2)
        if let searchKey = textField.text{
            
            //入力された文字をデバッグエリアに表示(3)
            print(searchKey)
            
            // CLGeocoderインスタンスを取得(5)
            let geocoder = CLGeocoder()
            
            // 入力された文字から位置情報を取得(6)
            geocoder.geocodeAddressString(searchKey , completionHandler: { (placemarks, Error) in
                
        //位置情報が存在する場合は、unwrapPlacemarksに取り出す(7)
                if let unwrapPlacemarks = placemarks {
                    
                    // 1件目の情報を取り出す(8)
                    if let firstPlacemark = unwrapPlacemarks.first{
                        
                        // 位置情報を取り出す(9)
                        if let location = firstPlacemark.location {
                            // 位置情報から経度緯度をtargetCoordinateに取り出す(10)
                            let targetCoordinate = location.coordinate
                            
                            // 緯度経度をデバッグエリアに表示(11)
                            print(targetCoordinate)
                            
                            //  MKPointAnnotationインスタンスを取得し、ピンを生成(12)
                            let pin = MKPointAnnotation()
                            
                            // ピンの置く場所に緯度経度を設定(13)
                            pin.coordinate = targetCoordinate
                            
                            // ピンのタイトルを設定(14)
                            pin.title = searchKey
                            
                            //ピンを地図に置く(15)
                            self.dispMap.addAnnotation(pin)
                            
                            //緯度経度を中心にして半径500mの範囲を表示(16)
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                            
                        }
                    }
                }
                
            })
        }
        
        return true
    }
    
    @IBAction func presentLocation(_ sender: Any) {
        // CLLocationManagerのインスタンス生成
               var locationManager = CLLocationManager()
         
        //位置情報サービスの確認
        CLLocationManager.locationServicesEnabled()
         
        // セキュリティ認証のステータス
        let status = CLLocationManager.authorizationStatus()
                
        if(status == CLAuthorizationStatus.notDetermined) {
         
            // 許可をリクエスト
            locationManager.requestWhenInUseAuthorization()
            
            return
         
        }
        
        if status == .denied || status == .restricted {
             let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
             
             let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
             alert.addAction(okAction)
             
             present(alert, animated: true, completion: nil)
             return
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let currentLocation = locations.last!
            print("Current location: \(currentLocation)")
            
            
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Error \(error)")
        }
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
//        var titleInsets: UIEdgeInsets
//        var imageInsets: UIEdgeInsets
//
        
    }
    @IBAction func changeMapButton(_ sender: Any) {
        
       
        // mapTypeプロパティー値をトグル
        
        //  標準　-> 航空写真　-> 航空写真+標準
        if dispMap.mapType == .standard {
            dispMap.mapType = .satellite
        }else if dispMap.mapType == .satellite{
            dispMap.mapType = .hybrid
        }else if dispMap.mapType == .hybrid{
            dispMap.mapType = .satelliteFlyover
        }else if dispMap.mapType == .satelliteFlyover{
            dispMap.mapType = .hybridFlyover
        }else if dispMap.mapType == .hybridFlyover {
            dispMap.mapType = .mutedStandard
        } else {
            dispMap.mapType = .standard
        }
    }
}

