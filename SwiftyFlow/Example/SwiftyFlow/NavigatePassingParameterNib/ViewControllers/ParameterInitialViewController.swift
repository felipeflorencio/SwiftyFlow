//
//  ParameterInitialViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 30/05/19.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

// This flow follows the MVC pattern, trying to use the most common and simples
// setup, that is the reason that our navigation stack will start from here
class ParameterInitialViewController: UIViewController, FlowNavigator {
    
    @IBOutlet weak var firstParameterLabel: UILabel!
    @IBOutlet weak var secondParameterLabel: UILabel!
    @IBOutlet weak var thirdParameterLabel: UILabel!
    @IBOutlet weak var fourthParameterLabel: UILabel!
    
    var navigationFlow: FlowManager?
    
    var firstParameter: String?
    var secondParameter: Double?
    var thirdParameter: String?
    var fourthParameter: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCloseNavigationButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstParameterLabel.text = firstParameter
        secondParameterLabel.text = String(describing: secondParameter!) // for test purpouse we are forcing
        thirdParameterLabel.text = thirdParameter
        fourthParameterLabel.text = String(describing: fourthParameter!) // for test purpouse we are forcing
    }
    
    // MARK: UI Adjust
    private func addCloseNavigationButton() {
      self.navigationFlow?.managerNavigation()?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Close Navigation", style: .plain, target: self, action: #selector(closeTapped))
    }
    
    @objc private func closeTapped() {
        navigationFlow?.dismissFlowController()
    }
    
    // MARK: - IBAction
    @IBAction func startNavigation() {
        navigationFlow?.goNextWith(screen: ParameterFirstViewController.self, parameters: { () -> ((String, Int)) in
            return ("Felipe Garcia", 232)
        })
    }
    
    func setParameters(first data: String, _ second: Double, _ third: String, _ fourth: Int) {
        firstParameter = data
        secondParameter = second
        thirdParameter = third
        fourthParameter = fourth
    }
}
