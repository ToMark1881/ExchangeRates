//
//  ExchangeRateTableViewCell.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import UIKit

class ExchangeRateTableViewCell: UITableViewCell {

    @IBOutlet weak var pbRateLabel: UILabel!
    @IBOutlet weak var pbView: UIView!
    @IBOutlet weak var nationalBankRateLabel: UILabel!
    @IBOutlet weak var currensiesLabel: UILabel!
    
    
    func setupCell(with object: ExchangeRate) {
        if let currency = object.currency {
            self.currensiesLabel.text = "\(object.baseCurrency)\n\(currency)"
        } else {
            self.currensiesLabel.text = "\(object.baseCurrency)"
        }
        
        if let pbPurchaseRate = object.purchaseRate, let pbSaleRate = object.saleRate {
            self.pbView.isHidden = false
            self.pbRateLabel.text = "\(pbPurchaseRate) / \(pbSaleRate)"
        } else {
            self.pbView.isHidden = true
        }
        
        self.nationalBankRateLabel.text = "\(object.nationalBankPurchaseRate) / \(object.nationalBankSaleRate)"
    }
    
}
