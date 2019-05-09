//
//  NavigationFlowProtocol.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

protocol NavigationFlow: class {

    var navigationFlow: FlowManager? { get set }
    
    func goNext<T: UIViewController>(screen view: @escaping ((T.Type) -> ()) -> (),
                                     resolve asType: ViewIntanceFrom,
                                     resolved instance: ((T) -> ())?)
    
    func getBack<T: UIViewController>(pop withStyle: NavigationPopStyle,
                                      screen view: (((T.Type) -> ()) -> ())?)
}

extension NavigationFlow {
    var navigationFlow: FlowManager? {
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
