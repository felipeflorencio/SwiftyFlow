//
//  ContainerFlowStack.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import UIKit

/**
 This is the class that will be responsible to create and handle the stack of the view controllers
 that we will register to be used during our navigation using our flow manager class.
 */
public class ContainerFlowStack {
    
    internal var modules: [FlowElementContainer<UIViewController>]
    
    /**
     Initializer for generate ContainerFlowStack so you can create an instance
     and register all the dependencies that you will use in your flow manager
    */
    @discardableResult
    public init() {
        modules = [FlowElementContainer]()
    }
    
    /**
     Helper initializer that let you setup, register your depencies direct inside the
     constructor, as it's a closure that after initialize the instance return so you can
     use to register your dependencies
     
     - Parameter instance: Closure that has ContainerFlowStack instance.
     
     ### Usage Example: ###
     ````
     let navigationStack = ContainerFlowStack { flowStack in
         flowStack.registerModule(for: AutomaticallyFirstViewController.self, resolve: { () -> AutomaticallyFirstViewController in
            return AutomaticallyFirstViewController()
         })
     
         flowStack.registerModule(for: AutomaticallySecondViewController.self, resolve: { () -> AutomaticallySecondViewController in
            return AutomaticallySecondViewController()
         })
     }
     ````
     
    */
    @discardableResult
    public convenience init(for instances: (ContainerFlowStack) -> ()) {
        self.init()
        instances(self)
    }
    
    deinit {
        debugPrint("Deallocating ContainerFlowStack")
    }
    
    
    /**
     This is the registration method, it's used for you register the View Controllers that you will use in your flow manager, the order that you declare will be used if you use the automatic navigation method.
     
     - Parameters:
        - type: The Type of your View Controller that you want to register.
        - resolve: Closure that will be called to get the instance that you registered, is the same as your type.
     
     ### Usage Example: ###
     ````
        ContainerFlowStack().registerModule(for: DeeplinkInitialViewController.self) { () -> DeeplinkInitialViewController in
            return DeeplinkInitialViewController()
        }
     ````
     */
    @discardableResult
    public func registerModule<T: UIViewController>(for type: T.Type, resolve: @escaping () -> T?) -> FlowElementContainer<UIViewController> {
        let elementContainer = FlowElementContainer<UIViewController>(for: type, resolving: resolve)
        modules.append(elementContainer)
        
        return elementContainer
    }
    
    /**
    This is the method that is used to register the root view when using your own custom navigation controller.
    
    - Parameter type: View Controller type that you want to register
    - Parameter instance: The instance that will be resolved, will use the one that is first in the navigation controller hierarchy

    */
    func registerRootViewModule<T: UIViewController>(for type: T.Type, root instance: T) {
        
        let emptyResolver: () -> T = { return instance }
        let elementContainer = FlowElementContainer<UIViewController>(for: type, resolving: emptyResolver)
        elementContainer.inScope(scope: .weak)
        modules.insert(elementContainer, at: 0)
    }

    // Get the module list that you registered, can have itens that are not being instantiate yet
    // or by you getting back they are nullified the reference, just need to be instantiate again
    /// Helper method that will return all modules that you have registered inside this container
    ///
    /// - Returns: Array of type `FlowElementContainer`.
    public func getModulesList() -> [FlowElementContainer<UIViewController>] {
        return modules
    }
    
    /**
     Helper that for check if you have this View controller instance, it's intended to use for you check if that instance already was instantiated or not, if you never called this instance will return nil.
     
     - Parameter type: UIViewController type that you want to check.
     - Returns: The object instance reference.
     
     ### Usage Example: ###
     ````
        ContainerFlowStack().registerModule(for: DeeplinkInitialViewController.self) { () -> DeeplinkInitialViewController in
            return DeeplinkInitialViewController()
        }
     ````

     */
    public func getModuleIfHasInstance<T: UIViewController>(for type: T.Type) -> T? {
        
        // First we evaluate if we have the module inside
        guard let item = modules.first(where: { element -> Bool in
            return element.forType == type
        }) else {
            return nil
        }
        
        // Second we evaluate if is a resolved instance, that is `weak` or `strong`
        // As if is `none` will generate a new instance that is not the purpouse of
        // this method, here is to get the reference to a item that already resolved
        guard item.scope != .none else {
            return nil
        }
        
        guard item.hasInstance() else {
            return nil
        }
        
        return item.resolve()
    }
    
    /**
     This is the method that is used to resolve the instances that we declared inside our container.
     
     - Parameter item: View Controller type that you want to resolve

     */
    func resolve<T: UIViewController>(for item: T.Type) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item
        }
        
        return module?.resolve()
    }
    
    // MARK: - Update reference item inside list
    /**
     This method is used exclusive when you instantiate using the storyboard navigation, as it's the storyboard the one responsible to generate the instance and not our registration, we call this method to update the reference that we have inside our container list, this way even we do not instantiating using our registration if we get the instance by the type we will have the updated object instance.
     
     - Parameters:
        - type: View Controller type that we are looking for.
        - reference: The closure that will return the object reference updated with the valid one created from storyboard
     */
    func replaceInstanceReference<T: UIViewController>(for type: T.Type, instance reference: () -> UIViewController) {
        let module = modules.first { element -> Bool in
            debugPrint("Container type replace: \(element.forType)")
            
            return element.forType == type
        }
        
        module?.inScope(scope: .weak)
        module?.updateInstance(reference: reference())
    }
    
    /**
     This is intended to reset the object instance, for when we navigate back or next
     but it's only reset for `.weak` references, as the strong should remaing as we
     assumed the risk of this.
     
     - Parameter: view: The view controller type that we want to reset reference
     */
    func adjustModuleReference<T: UIViewController>(for view: T.Type) {
        
        let viewToAdjust = modules.first(where: { $0.forType == view })
        
        if viewToAdjust?.scope == .weak {
           viewToAdjust?.resetWeakInstanceReference()
        }
    }
    
    /**
     Helper that need to be called everytime we call methods to get back to root when
     is using stobyboard or when we "dismiss" completely our navigation so we nullify
     the reference to those objects in order to guarante that will be not there
    */
    func destroyInstanceReferenceWhenToRoot() {
        self.modules.forEach { element in
            element.resetInstanceReference()
        }
    }
}
