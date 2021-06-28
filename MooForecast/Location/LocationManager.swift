//
//  LocationManager.swift
//  MooForecast
//
//  Created by 김가람 on 2021/06/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    private override init() {
        manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        super.init()
        
        manager.delegate = self
    }
    
    let manager: CLLocationManager
    
    var currentLocationTitle: String? {
        didSet {
            var userInfo = [AnyHashable: Any]()
            if let location = currentLocation {
                userInfo["location"] = location
                NotificationCenter.default.post(name: LocationManager.currentLocationDidUpdate, object: nil, userInfo: userInfo)
            }
        }
    }
    var currentLocation: CLLocation?
    
    static let currentLocationDidUpdate = Notification.Name.init(rawValue: "currentLocationDidUpdate")
    
    func updateLocation() {
        let status: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            status = manager.authorizationStatus
        } else {
            // Fallback on earlier versions
            status = CLLocationManager.authorizationStatus()
        }
        
        switch status {
        case .notDetermined:
            requestAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .denied, .restricted:
            print("location denied")
        default:
            print("unknown")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    private func requestAuthorization() {
        // 포그라운드일때 실행중일떄만 위치권한 필요하다면,
        // manager.requestWhenInUseAuthorization()
        
        // 백그라운드에서도 사용하고 싶다면,
        // manager.requestAlwaysAuthorization()
        
        manager.requestWhenInUseAuthorization()
    }
    
    private func requestCurrentLocation() {
        // 위치 정보를 지속적으로 받아야하는 경우,
        // manager.startUpdatingLocation()
        
        // 일회성 위치 정보를 받아야하는 경우,
        // manager.requestLocation()
        
        manager.requestLocation()
    }
    
    private func updateAddress(from loaction: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(loaction) { [weak self] (placemarks, error) in
            if let error = error {
                print(error)
                self?.currentLocationTitle = ""
                return
            }
            
            if let placemark = placemarks?.first {
                if let gu = placemark.locality, let dong = placemark.subLocality {
                    self?.currentLocationTitle = "\(gu) \(dong)"
                }
                else {
                    self?.currentLocationTitle = placemark.name ?? "Unkown"
                }
            }
            print(self?.currentLocationTitle)
        }
    }
    
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .notDetermined, .denied, .restricted:
            print("location denied")
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestCurrentLocation()
        case .notDetermined, .denied, .restricted:
            print("location denied")
        default:
            print("unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
            updateAddress(from: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
