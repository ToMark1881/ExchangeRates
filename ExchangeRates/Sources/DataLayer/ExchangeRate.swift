//
//  ExchangeRate.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

struct ExchangeRate: Decodable {
    
    private(set) var baseCurrency: String
    private(set) var currency: String?
    private(set) var nationalBankSaleRate: Double // NB
    private(set) var nationalBankPurchaseRate: Double // NB
    private(set) var saleRate: Double?
    private(set) var purchaseRate: Double?
    
    fileprivate enum CodingKeys: String, CodingKey {
        case baseCurrency
        case currency
        case nationalBankSaleRate = "saleRateNB"
        case nationalBankPurchaseRate = "purchaseRateNB"
        case saleRate
        case purchaseRate
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.baseCurrency = try container.decode(String.self, forKey: .baseCurrency)
        self.currency = try? container.decode(String.self, forKey: .currency)
        self.nationalBankSaleRate = try container.decode(Double.self, forKey: .nationalBankSaleRate)
        self.nationalBankPurchaseRate = try container.decode(Double.self, forKey: .nationalBankPurchaseRate)
        self.saleRate = try? container.decode(Double.self, forKey: .saleRate)
        self.purchaseRate = try? container.decode(Double.self, forKey: .purchaseRate)
        Logger.shared.log(String(describing: type(of: self)), type: .parserEntity)
    }
    
}
