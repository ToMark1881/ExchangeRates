//
//  BaseInteractor.swift
//  
//
//  Created by macbook on 02.06.2021.
//

import Foundation
import UIKit

class BaseInteractor {
        
    init() {
        Logger.shared.log("🆕 \(self)", type: .lifecycle)
    }
    
    deinit {
        Logger.shared.log("🗑 \(self)", type: .lifecycle)
    }
    
    func completeOnMainThread(completed: @escaping () -> Void) { //use this method to avoid gcd crash (ui on non-main thread)
        DispatchQueue.main.async {
            completed()
        }
    }
    
}
