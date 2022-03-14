//
//  BaseService.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

class BaseService {

    var parsingQueue: DispatchQueue!
    var networkQueue: DispatchQueue!

    init() {
        self.parsingQueue = DispatchQueue(label: "com.tomark.exchange.parsing.queue.\(String(describing: type(of: self)))")
        self.networkQueue = DispatchQueue(label: "com.tomark.exchange.network.queue.\(String(describing: type(of: self)))")
        
        let parsingQueueWithoutStringDescribing = DispatchQueue(label: "com.tomark.exchange.parsing.queue.\(type(of: self))")
        Logger.shared.log("actual: \(String(describing: self.parsingQueue)) and older one: \(parsingQueueWithoutStringDescribing)", type: .gcd)
        
        let networkQueueWithoutStringDescribing = DispatchQueue(label: "com.tomark.exchange.network.queue.\(type(of: self))")
        Logger.shared.log("actual: \(String(describing: self.parsingQueue)) and older one: \(networkQueueWithoutStringDescribing)", type: .gcd)
    }
    
    final func nonHandle(_ completed: (() -> Void)? = nil) -> ((Error?) -> Void) {
        return { (error: Error?) -> Void in
            Logger.shared.log(error)
            completed?()
        }
    }
    
}
