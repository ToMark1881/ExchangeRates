//  VIPER Template created by Vladyslav Vdovychenko
//  
//  RootTestCase.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import XCTest
@testable import ExchangeRates

// MARK: Don't forget to set the correct target for Test Case

class RootTestCase: XCTestCase {

    var moduleWireframe: RootWireframe!
    
    override func setUp() {
        self.moduleWireframe = RootWireframe()
        super.setUp()
    }
    
    func testModuleGeneration() {
        let module = self.moduleWireframe.createModule()
        XCTAssertNotNil(module)
        if let presenter = module?.presenter as? (RootViewPresenterOutputProtocol & RootInteractorPresenterOutputProtocol & RootRouterPresenterOutputProtocol) {
            XCTAssertNotNil(presenter.router)
            XCTAssertNotNil(presenter.interactor)
            XCTAssertNotNil(presenter.view)
        } else {
            XCTFail()
        }
    }

}
