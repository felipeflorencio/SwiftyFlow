//
//  ViewController.swift
//  FGFlowController
//
//  Created by Felipe Florencio Garcia on 05/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var screenOwner: (() -> NavigationStack)?
    var containerStack: NavigationContainerStack? = NavigationContainerStack()
    
    @IBOutlet weak var pushButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup stack navigation
        ContainerView().setupStackNavigation(using: containerStack!)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let transitionNavigationType = segue.destination as? NavigationStack else { return }
        transitionNavigationType.screenOwner = { return self }
        transitionNavigationType.containerStack = self.containerStack
    }
}

extension ViewController: NavigationStack {

    func goNext(screen view: @escaping ((UIViewController?) -> ()) -> ()) {
        view({ viewToGo in
            guard let view = viewToGo else { return }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "someViewController")

            self.navigationController?.pushViewController(view, animated: true)
        })
    }
    
    func getBack(screen view: @escaping ((UIViewController?) -> ()) -> ()) {
        view({ viewToGetBack in
            guard let view = viewToGetBack else { return }
            self.navigationController?.popToViewController(view, animated: true)
        })
    }
}
