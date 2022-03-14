//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootViewController.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import UIKit

final class RootViewController: BaseViewController {
    
    var presenter: RootViewPresenterOutputProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension RootViewController: RootViewPresenterInputProtocol {

}
