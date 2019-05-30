//
//  SecondViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    var nameForTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = nameForTitle
    }
    
    // Storyboard Navigation
    @IBAction func goNextView() {

        self.navigationFlow?.goNext(screen: ThirdViewController.self, resolve: .storyboard("Main"), resolved: { instance in
            
        })
        
//        self.navigationFlow?.goNext(screen: { showView in
//            showView(ThirdViewController.self)
//        }, resolve: .storyboard("Main"), resolved: { instance in
//
//        })
    }
    
    @IBAction func goBackView() {
        navigationFlow?.getBack()
    }
    
    // NIB Navigation
    @IBAction func goNextNibView() {
        
        self.navigationFlow?.goNext(screen: ThirdViewController.self, resolve: .nib, resolved: { instance in
            
        })
    }
    
    @IBAction func goBackNibView() {
        navigationFlow?.getBack()
    }
}
