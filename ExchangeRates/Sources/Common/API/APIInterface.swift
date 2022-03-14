//
//  APIService.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import CoreLocation

typealias SuccessCallback = (Data?, Int) -> Void
typealias FailureCallback = (NSError?) -> Void

protocol NetworkAPIInterface: AnyObject {
    func cancelRequest()
}
