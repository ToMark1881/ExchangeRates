//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ExchangeRatePresenter.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

final class ExchangeRatePresenter: BasePresenter {
    
    weak var view: ExchangeRateViewPresenterInputProtocol?
    
    var interactor: ExchangeRateInteractorPresenterInputProtocol?
    
    var router: ExchangeRateRouterPresenterInputProtocol?
    
}

// MARK: - View - Presenter
extension ExchangeRatePresenter: ExchangeRateViewPresenterOutputProtocol {
    
    func loadRates(for date: Date) {
        self.interactor?.loadRates(for: date)
    }
    
}

// MARK: - Interactor - Presenter
extension ExchangeRatePresenter: ExchangeRateInteractorPresenterOutputProtocol {
    
    func didReceive(list: ExchangeList) {
        self.view?.didReceive(list: list)
    }
    
    func didReceive(error: NSError?) {
        self.view?.didReceive(error: error)
    }
    
}

// MARK: - Router - Presenter
extension ExchangeRatePresenter: ExchangeRateRouterPresenterOutputProtocol {
    
}
