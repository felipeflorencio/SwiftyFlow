//
//  NavigatePassingParameterNib.swift
//  SwiftyFlowTests
//
//  Created by Felipe Florencio Garcia on 30/05/19.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import XCTest
@testable import SwiftyFlow

class NavigatePassingParameterNib: XCTestCase {

    var container: ParameterNavigationContainer!
    var flowManager: FlowManager!
    
    override func setUp() {
        container = ParameterNavigationContainer(stack: ContainerFlowStack())
        
        // Given
        flowManager = FlowManager(root: ParameterInitialViewController.self,
                                  container: container.setup(), parameters: {
                return (("Felipe", 3123.232, "Florencio", 31))
        })
    }

    func testInitialViewControllerReceivedParameters() {
        
        // When
        let instance = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)

        // Then
        XCTAssertTrue(instance?.firstParameter == "Felipe")
        XCTAssertTrue(instance?.secondParameter == 3123.232)
        XCTAssertTrue(instance?.thirdParameter == "Florencio")
        XCTAssertTrue(instance?.fourthParameter == 31)
    }
    
    func testFirstViewControllerReceivedParameters() {
        
        // Given
        let instanceInitial = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)
        instanceInitial?.startNavigation()
        
        // When
        let instanceFirstView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self)

        // Then
        XCTAssertTrue(instanceFirstView?.firstParameter == "Felipe Garcia")
        XCTAssertTrue(instanceFirstView?.secondParameter == 232)
    }
}
