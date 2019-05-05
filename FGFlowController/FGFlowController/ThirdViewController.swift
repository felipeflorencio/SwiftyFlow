//
//  ThirdViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController, ViewModule, NavigationStack {
    
    var type: Any.Type { return ThirdViewController.self }
    
    var screenOwner: (() -> NavigationStack)?
    var containerStack: NavigationContainerStack?
    
    @IBAction func goNextView() {
        self.screenOwner?().goNext(screen: { showView in
            showView(self)
        })
    }
    
    @IBAction func goBackView() {
        let viewToGetBack = containerStack?.resolve(for: FirstViewController.self)
        
        self.screenOwner?().getBack(screen: { showView in
            showView(self.screenOwner?())
        })
    }
}
