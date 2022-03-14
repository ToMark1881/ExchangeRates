//  VIPER Template created by Vladyslav Vdovychenko
//  
//  ExchangeRateTestCase.swift
//  ExchangeRates
//
//  Created by Vladyslav Vdovychenko on 14.03.2022.
//

import XCTest
@testable import ExchangeRates

// MARK: Don't forget to set the correct target for Test Case

class ExchangeRateTestCase: XCTestCase {

    var moduleWireframe: ExchangeRateWireframe!
    
    override func setUp() {
        self.moduleWireframe = ExchangeRateWireframe()
        super.setUp()
    }
    
    func testModuleGeneration() {
        let module = self.moduleWireframe.createModule()
        XCTAssertNotNil(module)
        if let presenter = module?.presenter as? (ExchangeRateViewPresenterOutputProtocol & ExchangeRateInteractorPresenterOutputProtocol & ExchangeRateRouterPresenterOutputProtocol) {
            XCTAssertNotNil(presenter.router)
            XCTAssertNotNil(presenter.interactor)
            XCTAssertNotNil(presenter.view)
        } else {
            XCTFail()
        }
    }
    
    func testExchangeRateRequest() {
        let expectation = expectation(description: "Load exchange rates")

        let service = ExchangeRatesService()
        service.loadExchangeRates(for: Date()) { list in
            XCTAssertTrue(list.exchangeRateObjects.count > 0)
            expectation.fulfill()
        } failure: { _ in
            XCTFail()
        }
        
        waitForExpectations(timeout: 100) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }

}
