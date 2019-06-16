//
//  NavigationFlowProtocol.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

/**
 Protocol that you will need to conform in your class in order to be able when resolve your class and navigate we automatically pass the reference of the `flow manager` so you can use the navigation methods without need to manually pass the reference of the navigation manager to your class's
 
 - Remark: It's possible to not conform, and you handle by yourself but it's not recommend.
 */
public protocol FlowNavigator: class {
    
    /**
     Variable that expect FlowManager instance
     */
    var navigationFlow: FlowManager? { get set }
}
