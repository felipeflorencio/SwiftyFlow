//
//  ContainerFlowStack.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import UIKit

public class ContainerFlowStack {
    
    internal var modules: [FlowElementContainer<UIViewController>]
    
    @discardableResult
    public init() {
        modules = [FlowElementContainer]()
    }
    
    @discardableResult
    public convenience init(for instances: (ContainerFlowStack) -> ()) {
        self.init()
        instances(self)
    }
    
    deinit {
        debugPrint("Deallocating ContainerFlowStack")
    }
    
    @discardableResult
    public func registerModule<T: UIViewController>(for type: T.Type, resolve: @escaping () -> T?) -> FlowElementContainer<UIViewController> {
        let elementContainer = FlowElementContainer<UIViewController>(for: type, resolving: resolve)
        modules.append(elementContainer)
        
        return elementContainer
    }
    
    // MARK: - Get list of items registered and the reference of an item
    
    // Get the module list that you registered, can have itens that are not being instantiate yet
    // or by you getting back they are nullified the reference, just need to be instantiate again
    public func getModulesList() -> [FlowElementContainer<UIViewController>] {
        return modules
    }
    
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
    
    public func resolve<T: UIViewController>(for item: T.Type) -> T? {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(element.forType)")
            
            return element.forType == item
        }
        
        return module?.resolve()
    }
    
    // MARK: - Update reference item inside list
    func replaceInstanceReference<T: UIViewController>(for type: T.Type, instance reference: () -> UIViewController) {
        let module = modules.first { element -> Bool in
            debugPrint("Type requesting replace: \(type)")
            debugPrint("Container type replace: \(element.forType)")
            
            return element.forType == type
        }
        
        module?.inScope(scope: .weak)
        module?.updateInstance(reference: reference())
    }
    
    func adjustModuleReference<T: UIViewController>(for view: T.Type) {
        
        let viewToAdjust = modules.first(where: { $0.forType == view })
        
        if viewToAdjust?.scope == .weak {
           viewToAdjust?.resetWeakInstanceReference()
        }
    }
    
    // Helper that need to be called everytime we call methods to get back to root when
    // is using stobyboard or when we "dismiss" completely our navigation so we nullify
    // the reference to those objects in order to guarante that will be not there
    func destroyInstanceReferenceWhenToRoot() {
        self.modules.forEach { element in
            element.resetInstanceReference()
        }
    }
}
