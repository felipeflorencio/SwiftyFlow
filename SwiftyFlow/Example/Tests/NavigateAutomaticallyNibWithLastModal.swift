//
//  NavigateAutomaticallyNibWithLastModal.swift
//  SwiftyFlowTests
//
//  Created by Felipe Florencio Garcia on 03/06/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import XCTest
import SwiftyFlow
@testable import SwiftyFlow_Example

class NavigateAutomaticallyNibWithLastModal: XCTestCase {

    var flowManager: FlowManager!
    
    override func setUp() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationWithModalContainer().setupNavigationStack(using: navigationStack)
        
        // Given
        flowManager = FlowManager(root: AutomaticallyInitialViewController.self,
                                  container: navigationStack,
                                  dismissed: {
                                debugPrint("finished")
        })
        flowManager.start()
    }
    
    func testRootViewControllerLoaded() {
        
        // When
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)

        // Then
        XCTAssertNotNil(instance)
    }
    
    func testGoToFirstViewController() {
        
        // Given
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        
        // When
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        
        // Then
        XCTAssertNotNil(firstView)
    }
    
    func testGoToSecondViewController() {
        
        // Given
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        firstView?.next()
        
        // When
        let secondView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self)
        
        // Then
        XCTAssertNotNil(secondView)
    }
    
    func testGoToThirdViewController() {
        
        // Given
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        firstView?.next()
        let secondView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self)
        secondView?.next()
        
        // When
        let thirdView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self)
        
        // Then
        XCTAssertNotNil(thirdView)
    }
    
    func testGoToModalViewController() {
        
        // Given
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        firstView?.next()
        let secondView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self)
        secondView?.next()
        let thirdView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self)
        thirdView?.nextModal()
        
        // When
        let modalView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFourthModalViewController.self)

        // Then
        XCTAssertNotNil(modalView)
    }
    
    func testBackOneFromThirdViewController() {
        
        // Given
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        firstView?.next()
        let secondView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self)
        secondView?.next()
        let thirdView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self)
        
        // When
        thirdView?.back()
        
        // Then
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self))
        XCTAssertNotNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self))
        XCTAssertNotNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self))
    }
    
    func testBackToRootFromThirdViewController() {
        
        // Given
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        firstView?.next()
        let secondView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self)
        secondView?.next()
        let thirdView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self)

        // When
        thirdView?.backToRoot()
        
        // Then
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self))
    }
    
    func testCloseHoleFlowFromThirdViewController() {
        
        // Given
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        firstView?.next()
        let secondView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self)
        secondView?.next()
        let thirdView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self)
        
        // When
        thirdView?.closeHoleFlow()
        
        // Then
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self))
    }
    
    func testCloseHoleFlowAndCallFinishedCallbackFromThirdViewController() {
        let navigationStack = ContainerFlowStack()
        AutomaticallyNavigationWithModalContainer().setupNavigationStack(using: navigationStack)
        
        var calledDismissCallback: Bool = false
        
        let expectation = XCTestExpectation(description: "Wait for the callback closure `dismissed`")

        // Given
        let flowManager = FlowManager(root: AutomaticallyInitialViewController.self,
                                  container: navigationStack,
                                  dismissed: {
                calledDismissCallback = true
                expectation.fulfill()
        })
        
        // Given
        flowManager.start()
        let instance = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self)
        instance?.startNavigation()
        let firstView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self)
        firstView?.next()
        let secondView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self)
        secondView?.next()
        let thirdView = flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self)
        
        // When
        thirdView?.closeHoleFlow()
        
        // Then
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyInitialViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyFirstViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallySecondViewController.self))
        XCTAssertNil(flowManager.container()?.getModuleIfHasInstance(for: AutomaticallyThirdModalViewController.self))
        
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(calledDismissCallback)
    }
}
