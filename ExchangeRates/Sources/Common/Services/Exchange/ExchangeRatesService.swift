//
//  ExchangeRatesService.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

class ExchangeRatesService: BaseService {
    
    var api: ExchangeRatesAPIInterfrace?
    
    override init() {
        self.api = ExchangeRatesAPIService()
        super.init()
    }
    
    func loadExchangeRates(for date: Date, completed: @escaping ((ExchangeList) -> Void), failure: @escaping FailureCallback) {
        self.networkQueue.async {
            self.api?.loadExchangeRates(for: date, completed: { data, count in
                self.parsingQueue.async {
                    self.parseExchangeRates(data, completed: completed, failure: failure)
                }
            }, failure: failure)
        }
    }
    
    
    fileprivate func parseExchangeRates(_ data: Data?, completed: ((ExchangeList) -> Void), failure: FailureCallback) {
        guard let data = data else { failure(ErrorsFactory.General.parsingError); return }
        Logger.shared.log(nil, type: .responses)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        do {
            let result = try decoder.decode(ExchangeList.self, from: data)
            completed(result)
        }
        catch let error {
            failure(error as NSError)
        }
        
    }
    
}
