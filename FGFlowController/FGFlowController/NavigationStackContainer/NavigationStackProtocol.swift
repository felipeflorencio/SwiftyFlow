//
//  NavigationStackProtocol.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

protocol NavigationStack where Self: UIViewController {
    
    // Temporarily while we don't have DI tool / library
    var containerStack: NavigationContainerStack? { get set }
    
    var screenOwner: (() -> NavigationStack)? { get set }
    
    func goNext(screen view: @escaping ((UIViewController?) -> ()) -> ())
    func getBack(screen view: @escaping ((UIViewController?) -> ()) -> ())
}

extension NavigationStack {
    var screenOwner: (() -> NavigationStack)? {
        get {
            return nil
        }
        
        set {
            
        }
    }

    func goNext(screen view: @escaping ((UIViewController?) -> ()) -> ()) { }
    func getBack(screen view: @escaping ((UIViewController?) -> ()) -> ()) { }
}
