//
//  SecondViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, ViewModule, NavigationStack {
    var type: Any.Type { return SecondViewController.self }
    
    var screenOwner: (() -> NavigationStack)?
    var containerStack: NavigationContainerStack?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let transitionNavigationType = segue.destination as? NavigationStack else { return }
        guard let rootView = screenOwner?() else { return }
        transitionNavigationType.screenOwner = { return rootView }
        transitionNavigationType.containerStack = self.containerStack
    }
    
    @IBAction func goNextView() {
        self.screenOwner?().goNext(screen: { showView in
            showView(self)
        })
    }
    
    @IBAction func goBackView() {
        self.screenOwner?().getBack(screen: { showView in
            showView(self.screenOwner?())
        })
    }
}
