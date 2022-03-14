//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootProtocols.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import UIKit

// MARK: - View - Presenter
protocol RootViewPresenterInputProtocol: BaseViewControllerProtocol {
    
    var presenter: RootViewPresenterOutputProtocol? { get set }
    
}

protocol RootViewPresenterOutputProtocol: AnyObject {
    
    var view: RootViewPresenterInputProtocol? { get set }
    
    func presentMainController()
        
}

// MARK: - Interactor - Presenter
protocol RootInteractorPresenterInputProtocol: AnyObject {
    
    var presenter: RootInteractorPresenterOutputProtocol? { get set }
    
}

protocol RootInteractorPresenterOutputProtocol: AnyObject {
    
    var interactor: RootInteractorPresenterInputProtocol? { get set }
    
}

// MARK: - Router - Presenter
protocol RootRouterPresenterInputProtocol: AnyObject {
    
    var presenter: RootRouterPresenterOutputProtocol? { get set }
    
    func presentMainController(_ parent: UIViewController)
    
}

protocol RootRouterPresenterOutputProtocol: AnyObject {
    
    var router: RootRouterPresenterInputProtocol? { get set }
    
}
