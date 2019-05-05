//
//  NavigationContainerStack.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import Foundation
import UIKit

protocol ViewModule where Self: UIViewController {
    var type: Any.Type { get }
}

class NavigationContainerStack {
    
    private(set) var modules: [WeakContainer<UIViewController>]
    
    @discardableResult init() {
        modules = [WeakContainer]()
    }
    
    func registerModule<T: ViewModule>(for type: Any.Type, resolve: @escaping () -> T) {
        let weakContainer = WeakContainer(for: type) { () -> UIViewController? in
            return resolve()
        }
        modules.append(weakContainer)
    }
    
    func getModulesList() -> [WeakContainer<UIViewController>] {
        return modules
    }
    
    func resolve<T: UIViewController>(for item: T.Type) -> T? {
        let module = modules.first { weakContainer -> Bool in
            debugPrint("Type requesting: \(item)")
            debugPrint("Container type: \(weakContainer.type())")
            
            return weakContainer.type() == item
        }
        
        return module?.resolve()
    }
}

class WeakContainer<T> where T: UIViewController {
    
    typealias Container = () -> T?
    private var factory: (Container)?
    private(set) var forType: Any.Type
    
    init(for type: Any.Type, resolving: @escaping Container) {
        factory = resolving
        forType = type
    }
    
    deinit {
        factory = nil
    }
    
    func resolve<T>() -> T? {
        return factory?() as? T
    }

    func type() -> Any.Type {
        return forType
    }
}
