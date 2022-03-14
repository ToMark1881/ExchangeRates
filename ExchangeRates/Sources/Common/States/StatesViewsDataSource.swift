//
//  StatesViewController.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import UIKit

enum ViewState: String {
    case initial
    case content
    case loading
    case error
    case nothing
}

protocol StatesViewsDataSource: AnyObject {
    func initialView() -> UIView
    func contentView() -> UIView
    func loadingView() -> UIView
    func errorView() -> UIView
    func nothingView() -> UIView
}
