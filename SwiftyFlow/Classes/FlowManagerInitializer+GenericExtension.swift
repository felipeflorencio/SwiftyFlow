//
//  FlowManagerInitializer+GenericExtension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 25/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

internal class ParameterFactory<T> {
 
    public typealias In = T
    
    public let closureData: () -> (In)
    
    public init(with parameter: In) {
        closureData = { parameter }
    }
}

extension FlowManager {
    
    public convenience init<T: UIViewController, Resolver>(root instanceType: T.Type,
                                                           container stack: ContainerFlowStack,
                                                           parameters data: @escaping () -> ((Resolver)),
                                                           withCustom navigation: UINavigationController? = nil,
                                                           setupInstance type: ViewIntanceFrom = .nib,
                                                           dismissed navigationFlow: (() -> ())? = nil) {
        self.init(navigation: nil, container: stack, setupInstance: type)
        
        let rootViewController = self._resolveInstance(viewController: type, for: instanceType, parameters: data)
        
        self.initializerFunctionality(root: rootViewController, withCustom: navigation, dismissed: navigationFlow)
    }
    
    // This is the method that we will use in order to send parameter when resolve our instance
    // Remember that when declare the parameter data that you want to be resolved need to be inside
    // Tuple, as for swift when resolve everything need to have a type, with this we make sure that
    // always have type and the values are inside
    // For Example: (String, Double, Int)
    public func goNextWith<T: UIViewController, Resolver>(screen view: T.Type,
                                                          parameters data: @escaping () -> ((Resolver)),
                                                          resolve asType: ViewIntanceFrom = .nib,
                                                          resolved instance: ((T) -> ())? = nil) {
        
        self.navigateUsingParameter(parameters: data, next: view.self, resolve: asType, resolved: instance)
    }
    
    internal func navigateUsingParameter<T: UIViewController, Resolver>(parameters data: @escaping () -> ((Resolver)),
                                                                        next viewTo: T.Type,
                                                                        resolve asType: ViewIntanceFrom = .nib,
                                                                        resolved instance: ((T) -> ())? = nil) {
        guard let navigation = self.navigationController else {
            fatalError("You need to have a root navigation controller instance")
        }
        
        let navigationType = self.defaultNavigationType ?? asType
        
        guard let controller = self._resolveInstance(viewController: navigationType, for: viewTo, parameters: data) else {
            debugPrint("Could not retrieve the view controller to push")
            return
        }
        
        (controller as? FlowNavigator)?.navigationFlow = self
        instance?(controller as! T)
        
        // It's mandatory to have this in order to have track about where we are
        self.adjustViewReferenceState(for: type(of: controller.self))
        
        // Here is used to pass (create reference) of the data tha we will request / resolve
        // when load the next screen, the main purpouse is to be used with storyboards as we
        // can't use the injection during the creation, so we need to request later,
        sendParameters(parameters: data)
        
        navigation.pushViewController(controller, animated: true)
    }
    
    // Helper that we will set the our internal variable the referene to be able latter
    // to resolve and get the parameter that we intend to get in the next screen
    internal func sendParameters<Resolver>(parameters data: @escaping () -> ((Resolver))) {
        
        // Here we will set the reference to the closure that we will request
        // the data later, this is important as we need to have a reference to
        // the object, and have a `common interpreter` / `reference` to be able
        // to cast later.
        // We need to check if the type is `not empty` as when we call `navigateUsingParameter`
        // method if we do not have any parameter we set a empty closure, as in order to make
        // reusable this is how we are handling, so if the type is empty we should not set
        // otherwise if you call the method `dataFromPreviousController` you will have `value`
        // and when try to force cast will crash.
        if type(of: data()) != type(of: ()) {
            self.parameterFactory = ParameterFactory<(Resolver)>(with: data())
        }
    }
    
    // MARK: - Public Methods
    // MARK: To be able to get the parameters that are being passed from the previous screen
    public func dataFromPreviousController<Parameter>(data parameter: (Parameter) -> ()) {
        
        defer {
            self.parameterFactory = nil
        }
        
        // This is important in order to  make sure that we do not try to force
        // cast some nil value, prevent some other problems, important to know
        // that we still are forcing cast as we do not know in upfront which data
        // we will try to parse or handle
        guard let factory = self.parameterFactory else { return }
        
        let parameterContainer = factory as! ParameterFactory<Parameter>
        let resolvedData = parameterContainer.closureData
        parameter( resolvedData() )
    }
}
