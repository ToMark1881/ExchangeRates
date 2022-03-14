//
//  ExchangeList.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

struct ExchangeList: Decodable {
    
    private(set) var date: Date
    private(set) var bankShortName: String
    private(set) var baseCurrency: Int
    private(set) var baseCurrencyTitle: String
    private(set) var exchangeRateObjects: [ExchangeRate]
    
    fileprivate enum CodingKeys: String, CodingKey {
        case date
        case bankShortName = "bank"
        case baseCurrency
        case baseCurrencyTitle = "baseCurrencyLit"
        case exchangeRateObjects = "exchangeRate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        self.date = try container.decode(Date.self, forKey: .date)
        self.bankShortName = try container.decode(String.self, forKey: .bankShortName)
        self.baseCurrency = try container.decode(Int.self, forKey: .baseCurrency)
        self.baseCurrencyTitle = try container.decode(String.self, forKey: .baseCurrencyTitle)
        self.exchangeRateObjects = try container.decode([ExchangeRate].self, forKey: .exchangeRateObjects)
        Logger.shared.log(String(describing: type(of: self)), type: .parserEntity)
    }
    
}
