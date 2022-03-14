//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootInteractor.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation

final class RootInteractor: BaseInteractor {
    
    weak var presenter: RootInteractorPresenterOutputProtocol?
    
}

extension RootInteractor: RootInteractorPresenterInputProtocol {
    
}
