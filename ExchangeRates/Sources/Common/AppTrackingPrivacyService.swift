//
//  AppTrackingPrivacyService.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import AppTrackingTransparency

class AppTrackingPrivacyService {
    
    class func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    // Now that we are authorized we can get the IDFA
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
    @available(iOS 14, *)
    class func getCurrentTrackingType() -> ATTrackingManager.AuthorizationStatus {
        let type = ATTrackingManager.trackingAuthorizationStatus
        return type
    }
    
}
