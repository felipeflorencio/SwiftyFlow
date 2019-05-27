//
//  FlowManagerInitializer+GenericExtension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 25/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

extension FlowManager {
    
    @discardableResult convenience init<T: UIViewController, Resolver>(root instanceType: T.Type,
                                                                       container stack: ContainerFlowStack,
                                                                       parameters data: @escaping () -> ((Resolver)),
                                                                       withCustom navigation: UINavigationController? = nil,
                                                                       setupInstance type: ViewIntanceFrom = .nib,
                                                                       finishedLoad presenting: (() -> ())? = nil,
                                                                       dismissed navigationFlow: (() -> ())? = nil) {
        self.init(navigation: nil, container: stack, setupInstance: type)
        
        let rootViewController = self._resolveInstance(viewController: type, for: instanceType, parameters: data)
        
        self.initializerFunctionality(root: rootViewController, withCustom: navigation, finishedLoad: presenting, dismissed: navigationFlow)
    }
}
