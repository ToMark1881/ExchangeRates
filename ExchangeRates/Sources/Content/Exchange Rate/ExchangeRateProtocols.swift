//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ExchangeRateProtocols.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import UIKit

// MARK: - View - Presenter
protocol ExchangeRateViewPresenterInputProtocol: BaseViewControllerProtocol {
    
    var presenter: ExchangeRateViewPresenterOutputProtocol? { get set }
    
    var exchangeList: ExchangeList? { get set }
    
    func didReceive(list: ExchangeList)
    
    func didReceive(error: NSError?)
    
}

protocol ExchangeRateViewPresenterOutputProtocol: AnyObject {
    
    var view: ExchangeRateViewPresenterInputProtocol? { get set }
    
    func loadRates(for date: Date)
        
}

// MARK: - Interactor - Presenter
protocol ExchangeRateInteractorPresenterInputProtocol: AnyObject {
    
    var presenter: ExchangeRateInteractorPresenterOutputProtocol? { get set }
    
    func loadRates(for date: Date)
    
}

protocol ExchangeRateInteractorPresenterOutputProtocol: AnyObject {
    
    var interactor: ExchangeRateInteractorPresenterInputProtocol? { get set }
    
    func didReceive(list: ExchangeList)
    
    func didReceive(error: NSError?)
    
}

// MARK: - Router - Presenter
protocol ExchangeRateRouterPresenterInputProtocol: AnyObject {
    
    var presenter: ExchangeRateRouterPresenterOutputProtocol? { get set }
    
    
}

protocol ExchangeRateRouterPresenterOutputProtocol: AnyObject {
    
    var router: ExchangeRateRouterPresenterInputProtocol? { get set }
    
}
