//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootPresenter.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

final class RootPresenter: BasePresenter {
    
    weak var view: RootViewPresenterInputProtocol?
    
    var interactor: RootInteractorPresenterInputProtocol?
    
    var router: RootRouterPresenterInputProtocol?
    
}

// MARK: - View - Presenter
extension RootPresenter: RootViewPresenterOutputProtocol {
    
    func presentMainController() {
        guard let viewController = self.view else { return }
        self.router?.presentMainController(viewController)
    }
    
}

// MARK: - Interactor - Presenter
extension RootPresenter: RootInteractorPresenterOutputProtocol {
    
}

// MARK: - Router - Presenter
extension RootPresenter: RootRouterPresenterOutputProtocol {
    
}
