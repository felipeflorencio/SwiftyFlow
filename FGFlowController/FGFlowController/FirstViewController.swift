//
//  FirstViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ViewModule, NavigationStack {
    
    var type: Any.Type { return FirstViewController.self }
    
    var screenOwner: (() -> NavigationStack)?
    var containerStack: NavigationContainerStack?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let transitionNavigationType = segue.destination as? NavigationStack else { return }
        guard let rootView = screenOwner?() else { return }
        transitionNavigationType.screenOwner = { return rootView }
        transitionNavigationType.containerStack = self.containerStack
    }
    
    @IBAction func goNextView() {
        let viewToGoNextBack = containerStack?.resolve(for: SecondViewController.self)
        
        self.screenOwner?().goNext(screen: { showView in
//            showView(viewToGoNextBack?.getInstance())
        })
    }
    
    @IBAction func goBackView() {
        self.screenOwner?().getBack(screen: { showView in
            showView(self.screenOwner?())
        })
    }
}
