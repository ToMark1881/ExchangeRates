//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ExchangeRateWireframe.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import UIKit

final class ExchangeRateWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "Content"
    }
    
    override func identifier() -> String {
        return "ExchangeRateViewController"
    }
    
    func pushFrom(_ parent: UINavigationController?) {
        guard let viewController = self.createModule(), let parent = parent else { return }
        self.presentedViewController = viewController
        parent.pushViewController(viewController, animated: true)
    }
    
    func presentIn(_ parent: UIViewController?) {
        guard let viewController = self.createModule(), let parent = parent else { return }
        let navigationController = UINavigationController(rootViewController: viewController)
        self.presentedViewController = viewController
        
        navigationController.modalPresentationStyle = .fullScreen
        parent.present(navigationController, animated: true, completion: nil)
    }
    
    func embeddedIn(_ parent: UIViewController?) {
        guard let viewController = self.createModule(), let parent = parent else { return }
        
        parent.view.addSubview(viewController.view)
        parent.addChild(viewController)
        viewController.didMove(toParent: parent)
    }
    
    func createModule() -> ExchangeRateViewController? {
        guard let view: ExchangeRateViewController = initializeController() else { return nil }
        let presenter: ExchangeRateViewPresenterOutputProtocol & ExchangeRateInteractorPresenterOutputProtocol & ExchangeRateRouterPresenterOutputProtocol = ExchangeRatePresenter()
        let router: ExchangeRateRouterPresenterInputProtocol = ExchangeRateRouter()
        let interactor: ExchangeRateInteractorPresenterInputProtocol = ExchangeRateInteractor()
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        view.presenter = presenter
        router.presenter = presenter
        
        return view
    }
    
}
