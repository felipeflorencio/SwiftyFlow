//
//  NavigationFlowProtocol.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

public protocol FlowNavigator: class {
    
    var navigationFlow: FlowManager? { get set }
}
