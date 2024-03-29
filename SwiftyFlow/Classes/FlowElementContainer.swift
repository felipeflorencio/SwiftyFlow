//
//  FlowElementContainer.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 09/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

/**
 Type alias that we use in our initializer and other places, convenience to show clearly the reason of why use `Any`
 */
public typealias CallbackFunctionType = Any

/**
 The idea of have FlowElementContainer is a way of have the reference
 encapsulated inside a object that we can manage the reference to our
 real object, as we will be using this inside an array, we need to be
 able to destroy easily our array without have the risk of some view
 controller hold the reference to the object
 */
public class FlowElementContainer<T> {
    
    /**
     Enum that will say which type of the registration you want to your instance
     */
    public enum Scope {
        case none       // fresh instance all the time, default
        case weak       // weak ref to instance, at leas one object
        case strong     // keep alive - you need to know what you are doing
    }
    
    /**
     Typealias
     */
    public typealias Container = () -> T?
    private var factory: (Container)?
    
    private(set) var factoryParameter: CallbackFunctionType?
    
    private(set) var scope: Scope = .weak
    private(set) var forType: T.Type
    private(set) var customIdentifier: String?
    private weak var weakInstance: AnyObject?
    private var strongInstance: T?
    private(set) var arguments: Any?
    private(set) var viewShowing: Bool = false
    
    /**
     Flow element container initialiser
     
     - Parameters:
        - for: The type of the View Controller that you want to register.
        - resolving: Is the closure that will be called when Flow Manager need to get the instance of the type that you declared
     */
    public init(for type: T.Type, resolving: @escaping Container) {
        factory = resolving
        forType = type
    }
    
    /**
     Flow element container initialiser
     
     - Parameters:
        - for: The type of the View Controller that you want to register.
        - customIdentifier: String that is custom identifier to identify particular view
        - resolving: Is the closure that will be called when Flow Manager need to get the instance of the type that you declared
     */
    public init(for type: T.Type, customIdentifier: String, resolving: @escaping Container) {
        factory = resolving
        forType = type
        self.customIdentifier = customIdentifier
    }
    
    /**
     Flow element container initialiser for when you want to resolving receiving the parameters from the caller
     
     - Parameters:
        - for: The type of the View Controller that you want to register.
        - with: The arguments that you will want to have, `Any` as type.
        - resolving: Is the closure that will be called when Flow Manager need to get the instance of the type that you declared.
     */
    public init(for type: T.Type, with arg: Any, resolving: CallbackFunctionType) {
        factoryParameter = resolving
        forType = type
        arguments = arg
    }
    
    /**
     Flow element container initialiser for when you want to resolving receiving the parameters from the caller
     
     - Parameters:
        - for: The type of the View Controller that you want to register.
        - customIdentifier: String that is custom identifier to identify particular view
        - with: The arguments that you will want to have, `Any` as type.
        - resolving: Is the closure that will be called when Flow Manager need to get the instance of the type that you declared.
     */
    public init(for type: T.Type, customIdentifier: String, with arg: Any, resolving: CallbackFunctionType) {
        factoryParameter = resolving
        forType = type
        arguments = arg
        self.customIdentifier = customIdentifier
    }
    
    deinit {
        factory = nil
        weakInstance = nil
        strongInstance = nil
    }
    
    func resolve<T>() -> T? {
        switch scope {
        case .none:
            return factory?() as? T
        case .weak:
            // This is a check for security reason, mainly when you call to resolve from storyboard
            // as storyboard resolve the class everytime so we do need to use weak reference, as when
            // call again we will use the one from storyboard, so will recreate the view and the instance
            // class that is attached to that view, when update we want to make sure strong it's nil
            if strongInstance != nil {
                strongInstance = nil
            }
            
            let resolved = (weakInstance as? T) ?? (factory?() as? T)
            weakInstance = resolved as? UIViewController
            return resolved
        case .strong where strongInstance == nil:
            strongInstance = factory?()
            fallthrough
        case .strong:
            return strongInstance as? T
        }
    }
    
    func resolved(with instance: (Container)) {
        switch scope {
        case .weak:
            weakInstance = instance() as? UIViewController
        case .strong:
            strongInstance = instance()
        default: break
        }
    }
    
    func showingView(_ isShowing: Bool) {
        self.viewShowing = isShowing
    }
    
    func hasInstance() -> Bool {
        return (weakInstance != nil || strongInstance != nil)
    }
    
    // MARK: Helper to update self object reference for now when load from storyboard
    // for this we will nullify factory as we should not get anymore from the closure
    // and not maintain the reference as this were generated by the Navigation Coordinator
    func updateInstance<T: UIViewController>(reference object: T) {
        // TODO: (felipe) Validate if this behaviour is ok or need to be changed
        self.strongInstance = nil
        
        self.weakInstance = object
    }
    
    // This is used to remove any object reference and make sure that if we start the flow again
    // we will always use the fresh instance as is suppose to be
    func resetWeakInstanceReference() {
        debugPrint("Destroying weak reference instance for: \(self.forType)")
        self.weakInstance = nil
    }
    
    func resetInstanceReference() {
        debugPrint("Destroying strong and weak reference instance for: \(self.forType)")
        self.strongInstance = nil
        self.weakInstance = nil
    }
    
    // MARK: Public methods
    
    /**
     Set the scope that we will want for this object
     
     - Parameter scope: The scope that you want to have your instance reference, `.weak`, `.strong`, or default is `.none`
     
     - Note: It has `@discardableResult` because you can use other helper methods just after calling this method as we always return FlowElementContainer instance.
     */
    @discardableResult
    public func inScope(scope: Scope) -> Self {
        self.scope = scope
        return self
    }
    
    /**
     Return the type of this element
     */
    public func type() -> T.Type {
        return self.forType
    }
    
    /**
     Return the identifier of this element
     */
    public func identifier() -> String? {
        return self.customIdentifier
    }
}
