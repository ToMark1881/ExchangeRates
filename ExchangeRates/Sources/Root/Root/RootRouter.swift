//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootRouter.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import UIKit

final class RootRouter: BaseRouter {
    
    weak var presenter: RootRouterPresenterOutputProtocol?
    
    fileprivate lazy var exchangeRateWireframe = { ExchangeRateWireframe() }()
    
}

extension RootRouter: RootRouterPresenterInputProtocol {
    
    // MARK: - Present
    func presentMainController(_ parent: UIViewController) {
        self.exchangeRateWireframe.embeddedIn(parent)
    }
    
    // MARK: - Dismiss
    
}


