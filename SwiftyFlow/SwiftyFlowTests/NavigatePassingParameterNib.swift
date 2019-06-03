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
    
    func testInitialViewControllerCloseFlow() {
        
        // Given
        flowManager.start()
        let instance = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)

        // When
        instance?.navigationFlow?.dismissFlowController()
        
        // Then
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self))
    }
    
    func testFirstViewControllerReceivedParameters() {
        
        flowManager.start()
        
        // Given
        let instanceInitial = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)
        instanceInitial?.startNavigation()
        
        // When
        let instanceFirstView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self)

        // Then
        XCTAssertTrue(instanceFirstView?.firstParameter == "Felipe Garcia")
        XCTAssertTrue(instanceFirstView?.secondParameter == 232)
    }
    
    func testNavigationToSecondViewStack() {
        
        flowManager.start()
        let mockedPickerView = UIPickerView()
        
        // Given
        let instanceInitial = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)
        instanceInitial?.startNavigation()
        
        let instanceFirstView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self)
        instanceFirstView?.pickerView(mockedPickerView, didSelectRow: 1, inComponent: 0)
        instanceFirstView?.goAnywhere() // go to the second screen
        
        // When
        let instanceSecondView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self)
        
        // Then
        XCTAssertNotNil(instanceSecondView)
    }
    
    func testNavigationBackOneFromSecondStack() {
        
        flowManager.start()
        let mockedPickerView = UIPickerView()
        
        // Given
        let instanceInitial = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)
        instanceInitial?.startNavigation()
        
        let instanceFirstView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self)
        instanceFirstView?.pickerView(mockedPickerView, didSelectRow: 1, inComponent: 0)
        instanceFirstView?.goAnywhere() // go to the second screen
        let instanceSecondView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self)
        instanceSecondView?.back()
        
        // When
        let instanceSecondAfterBackView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self)

        // Then
        XCTAssertNil(instanceSecondAfterBackView)
    }
    
    func testNavigationToThirdViewStack() {
        
        flowManager.start()
        let mockedPickerView = UIPickerView()
        
        // Given
        let instanceInitial = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)
        instanceInitial?.startNavigation()
        
        let instanceFirstView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self)
        instanceFirstView?.pickerView(mockedPickerView, didSelectRow: 1, inComponent: 0)
        instanceFirstView?.goAnywhere() // go to the second screen
        let instanceSecondView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self)
        instanceSecondView?.next()
        
        // When
        let instanceThirdView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterThirdViewController.self)

        // Then
        XCTAssertNotNil(instanceThirdView)
    }
    
    func testNavigationToThirdViewAndGetBackToRoot() {
        
        flowManager.start()
        let mockedPickerView = UIPickerView()
        
        // Given
        let instanceInitial = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)
        instanceInitial?.startNavigation()
        
        let instanceFirstView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self)
        instanceFirstView?.pickerView(mockedPickerView, didSelectRow: 1, inComponent: 0)
        instanceFirstView?.goAnywhere() // go to the second screen
        
        let instanceSecondView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self)
        instanceSecondView?.next()
        
        let instanceThirdView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterThirdViewController.self)
        
        // When
        instanceThirdView?.backToRoot()
        
        // Then
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self))
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self))
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterThirdViewController.self))
    }
    
    func testNavigationToThirdViewAndCloseTheHoleFlow() {
        
        // Given
        flowManager.start()
        let mockedPickerView = UIPickerView()
        
        let instanceInitial = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self)
        instanceInitial?.startNavigation()
        
        let instanceFirstView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self)
        instanceFirstView?.pickerView(mockedPickerView, didSelectRow: 1, inComponent: 0)
        instanceFirstView?.goAnywhere() // go to the second screen
        
        let instanceSecondView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self)
        instanceSecondView?.next()
        
        let instanceThirdView = flowManager.containerStack?.getModuleIfHasInstance(for: ParameterThirdViewController.self)
        
        // When
        instanceThirdView?.closeHoleFlow()
        
        // Then
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterInitialViewController.self))
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterFirstViewController.self))
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterSecondViewController.self))
        XCTAssertNil(flowManager.containerStack?.getModuleIfHasInstance(for: ParameterThirdViewController.self))
    }
}
