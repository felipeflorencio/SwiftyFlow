//
//  AutomaticallyFirstViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class AutomaticallyFirstViewController: UIViewController, FlowNavigator {
    
    var navigationFlow: FlowManager?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    // MARK: - IBAction
    @IBAction func next() {
        navigationFlow?.goNext()
    }
    
    @IBAction func back() {
        navigationFlow?.getBack()
    }
    
    func requestData() {
        navigationFlow?.dataFromPreviousController(data: { (arguments: (String, Double, String, Int)) in
            let (first, second, third, fourth) = arguments
            debugPrint("First parameter: \(first) - Storyboard Automatically Navigation")
            debugPrint("Second parameter: \(second) - Storyboard Automatically Navigation")
            debugPrint("Third parameter: \(third) - Storyboard Automatically Navigation")
            debugPrint("Fourth parameter: \(fourth) - Storyboard Automatically Navigation")
        })
    }
}
