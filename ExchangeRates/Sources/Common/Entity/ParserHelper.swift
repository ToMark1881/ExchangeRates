//
//  ParserHelper.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

class ParserHelper {
    
    class func convertDataToArray(_ data: Data?) throws -> [NSDictionary]? {
        if let data = data {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [NSDictionary]
        } else {
            return nil
        }
    }
    
    class func convertDataToDictionary(_ data: Data?) throws -> NSDictionary? {
        if let data = data {
            return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
        } else {
            return nil
        }
    }
}
