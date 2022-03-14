//
//  ErrorsHandlerInterface.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

protocol ErrorsHandlerInterface: AnyObject {
    
    func handleError(_ error: NSError?)
    
    func handleWarning(_ title: String?, message: String?, proceed: @escaping () -> Void, cancel: @escaping () -> Void)
    
}
