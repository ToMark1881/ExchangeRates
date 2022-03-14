//
//  ExchangeRatesAPIService.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import Alamofire

class ExchangeRatesAPIService: BaseAPIService, ExchangeRatesAPIInterfrace {
    
    func loadExchangeRates(for date: Date, completed: @escaping SuccessCallback, failure: @escaping FailureCallback) {
        
        let parameters: Parameters = ["date": date.stringWithFormat("dd.MM.yyyy"), "json": ""]
        
        sendRequest(.get, serverUrl: APIConstants.serverURL, path: "/p24api/exchange_rates", parameters: parameters, success: completed, failure: failure)
    }
    
}
