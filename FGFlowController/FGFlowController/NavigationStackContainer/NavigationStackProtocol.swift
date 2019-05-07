//
//  NavigationStackProtocol.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

protocol NavigationStack: class {

    var navigationCoordinator: NavigationCoordinator? { get set }
    
    func goNext<T: UIViewController>(screen view: @escaping ((T.Type) -> ()) -> (),
                                     resolve asType: ViewIntanceFrom,
                                     resolved instance: ((T) -> ())?)
    
    func getBack<T: UIViewController>(pop withStyle: NavigationPopStyle,
                                      screen view: (((T.Type) -> ()) -> ())?)
}

extension NavigationStack {
    var navigationCoordinator: NavigationCoordinator? {
        get {
            return nil
        }
        
        set {
            
        }
    }

    func goNext<T: UIViewController>(screen view: @escaping ((T.Type) -> ()) -> (),
                                     resolve asType: ViewIntanceFrom,
                                     resolved instance: ((T) -> ())?) { }
    func getBack<T: UIViewController>(pop withStyle: NavigationPopStyle,
                                      screen view: (((T.Type) -> ()) -> ())?) { }
}
