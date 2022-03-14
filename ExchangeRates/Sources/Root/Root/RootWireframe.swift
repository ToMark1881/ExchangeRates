//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootWireframe.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import Foundation
import UIKit

final class RootWireframe: BaseWireframe {
    
    override func storyboardName() -> String {
        return "Root"
    }
    
    override func identifier() -> String {
        return "RootViewController"
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
    
    func createModule() -> RootViewController? {
        guard let view: RootViewController = initializeController() else { return nil }
        let presenter: RootViewPresenterOutputProtocol & RootInteractorPresenterOutputProtocol & RootRouterPresenterOutputProtocol = RootPresenter()
        let router: RootRouterPresenterInputProtocol = RootRouter()
        let interactor: RootInteractorPresenterInputProtocol = RootInteractor()
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        view.presenter = presenter
        router.presenter = presenter
        
        return view
    }
    
}
