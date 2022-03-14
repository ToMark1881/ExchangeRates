//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ExchangeRateInteractor.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

final class ExchangeRateInteractor: BaseInteractor {
    
    weak var presenter: ExchangeRateInteractorPresenterOutputProtocol?
    
    fileprivate lazy var exchangeRateService = { ExchangeRatesService() }()
    
}

extension ExchangeRateInteractor: ExchangeRateInteractorPresenterInputProtocol {
    
    func loadRates(for date: Date) {
        self.exchangeRateService.loadExchangeRates(for: date) { [weak self] list in
            self?.completeOnMainThread {
                self?.presenter?.didReceive(list: list)
            }
        } failure: { [weak self] error in
            self?.completeOnMainThread {
                self?.presenter?.didReceive(error: error)
            }
        }
    }
    
}
