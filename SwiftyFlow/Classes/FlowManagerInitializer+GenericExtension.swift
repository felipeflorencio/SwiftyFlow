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
    
    /**
     Flow Manager convenience initialiser for when you want to resolve the root view controller from your navigation controller receiving parameters.
     
     1 - When we are already in one storyboard, and we want to load another viewcontroller
         that is inside this storyboard you can resolve using `rootInstance` to resolve and
         will be set to as your root view controller inside your navigation controller.
     
     Example:
        We have setup our Storyboard, and we embed in on our view controllers our UINavigationController
        Them as we want to use the Flow Manager to handle our navigation, we need to get the reference to our
        view controller and set as our `custom navigation`, but we need to know who is the root of this
        navigation, so for this we pass the `root` type of the view.
     
     2 - When you are loading a completely new storyboard, as you will need to resolve your
         first / root view controller using the reference from the storyboar as it's not loaded
         yet, so for this scenario you only pass the type of the first one `root` that will be resolved
         so we hande this resolution for you, otherwise will load with a black screen your navigation.
     
     - Parameters:
        - root: The view controller type that you will have as `root` view controller for you navigation controller.
        - container: It's the `ContainerFlowStack` instance, it's where we will look for the registered View Controller types in order to resolve and show on the screen.
        - parameters: Closure that expect the parameter that you want to be passed to when we resolve, need to follow the same order and type of the register that is expecting this parameter(s).
        - withCustom: `optional` - Custom UINavigationController it's optional, if not we will use the default one from UIKit.
        - setupInstance: `optional` - It's how will be our navigation, it's a enum, if you don't set we will assume that is nib view that you will be using.
        - dismissed: `optional` - Closure optional that can tell you when this navigation controller was completely closed.
     
     */
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
    
    /**
     This is the method that we will use in order to send parameter when resolve our instance
     Remember that when declare the parameter data that you want to be resolved need to be inside
     Tuple, as for swift when resolve everything need to have a type, with this we make sure that
     always have type and the values are inside
     
     - Parameters:
        - screen: The type of the view controller that you want to next.
        - paramer: Closure that expect a `type` that will be used when resolve this screen that you are calling.
        - resolve: `optional` - How the view for this screen will be loaded, the default one is `.nib`.
        - resolved: `optional` - Convenience closure that will return the loaded instance reference for this loaded view, it's good when you want to set some values or pass any parameter not using the custom resolve, you will have the right reference to pass value.
     
     ### Usage Example: ###
     ````
        // Basic implementation
         navigationFlow?.goNextWith(screen: ParameterFirstViewController.self, parameters: { () -> ((String, Int)) in
            return ("Felipe Garcia", 232)
         })
     
        // Using the parameters available
         navigationFlow?.goNextWith(screen: ParameterFirstViewController.self, parameters: { () -> ((String, Int)) in
            return ("Felipe Garcia", 232)
         }, resolve: .nib, resolved: { resolveView in
            // resolve view
         })
     ````
     */
    public func goNextWith<T: UIViewController, Resolver>(screen view: T.Type,
                                                          parameters data: @escaping () -> ((Resolver)),
                                                          resolve asType: ViewIntanceFrom = .nib,
                                                          resolved instance: ((T) -> ())? = nil) {
        
        self.navigateUsingParameter(parameters: data, next: view.self, resolve: asType, resolved: instance)
    }
    
    /**
     This is intend to when you are sending parameter but you are using Storyboard as navigation
     as when it's the Storyboard the one responsible for resolve your instance, the best that we
     can provide is if you implement this method in our class so as soon was instantiated we will
     send and you will be able to receive parameter from the caller.
     
     - Parameter data: Closure that will receive the parameter, you need to declare the types the same order that you are expecting.
     
     ### Usage Example: ###
     ````
         // Send the data to the next view controller when using Storyboard
         navigationFlow?.goNextWith(screen: AutomaticallyFirstViewController.self, parameters: { ("Felipe", 3123.232, "Florencio", 31) })
     
        // Implemented in the View Controller that you intend to receive the data that will be sent.
         navigationFlow?.dataFromPreviousController(data: { (arguments: (String, Double, String, Int)) in
            let (first, second, third, fourth) = arguments
            debugPrint("First parameter: \(first) - Storyboard Automatically Navigation")
            debugPrint("Second parameter: \(second) - Storyboard Automatically Navigation")
            debugPrint("Third parameter: \(third) - Storyboard Automatically Navigation")
            debugPrint("Fourth parameter: \(fourth) - Storyboard Automatically Navigation")
         })
     ````
     */
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
    
    
    // MARK: - Internal Methods
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
}
