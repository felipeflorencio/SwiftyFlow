//
//  FlowManager+HelperExtension.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 06/12/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

extension FlowManager {

    // MARK: Public variable accessor
    /**
     Helper method that you can get the instance reference to the
     `UINavigationController` in case you do not provided a custom one
     */
    public func managerNavigation() -> UINavigationController? {
        return self.navigationController
    }
    
    /**
     Helper method that give you back the container flow stack reference
     */
    public func container() -> ContainerFlowStack? {
        return self.containerStack
    }
    
    /**
        Helper method that will print your stack, so you can
        have a visual understand how your stack is right now
    */
    @discardableResult public func stackState() -> String {
        guard let stack = self.containerStack else {
            return ""
        }
        
        var printableStackState = "Root -> "
        var hasMoreThanOneItem = false
        // This is just for cosmetic reasons, I can do any 'loop'
        // because I know that there's more than one item
        if stack.modules.count > 1 {
            hasMoreThanOneItem = true
        }
        if let root = stack.modules.first {
            printableStackState.append("\(root.forType)")
            if hasMoreThanOneItem {
                printableStackState.append(" -> ")
            }
        }
        
        if hasMoreThanOneItem {
            for (position, item) in stack.modules.enumerated() {
                if position != 0, item.hasInstance() {
                    printableStackState.append("\(position): \(item.forType)")
                    if position < stack.modules.count, let hasNextItem = stack.modules[safe: position + 1], hasNextItem.hasInstance() {
                        printableStackState.append(" -> ")
                    }
                }
            }
        }
        
        debugPrint("This is your stack now")
        debugPrint(printableStackState)
        return printableStackState
    }
}
