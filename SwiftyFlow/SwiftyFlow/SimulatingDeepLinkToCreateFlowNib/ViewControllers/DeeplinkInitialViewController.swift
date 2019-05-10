//
//  DeeplinkInitialViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit

// This flow follows the MVC pattern, trying to use the most common and simples
// setup, that is the reason that our navigation stack will start from here
class DeeplinkInitialViewController: UIViewController, NavigationFlow, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var navigationFlow: FlowManager?
    
    @IBOutlet weak var picker: UIPickerView!
    
    private var selectedItem: FlowElementContainer<UIViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        addCloseNavigationButton()
    }
    
    // MARK: UI Adjust
    private func addCloseNavigationButton() {
      self.navigationFlow?.navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Close Navigation", style: .plain, target: self, action: #selector(closeTapped))
    }
    
    @objc private func closeTapped() {
        navigationFlow?.dismissFlowController()
    }
    
    @IBAction func goAnywhere() {
        guard let viewSelected = selectedItem else {
            debugPrint("You did not selected any view")
            return
        }
        
        createYourNewFlow(for: viewSelected.forType)
    }
    
    // MARK: - Create your flow dinamicaly
    private func createYourNewFlow(for view: UIViewController.Type) {

        guard let navigationStack = self.navigationFlow?.containerStack else { return }
        
        FlowManager(root: view,
                    container: navigationStack)
            .dismissedFlowWith { [weak self] closeAll in
            
            // Using this parameter for the situation that we want to dismiss both navigation from the top one
            if (closeAll as? Bool) == true {
                self?.navigationFlow?.dismissFlowController()
            }
        }
    }
    
    // MARK: - UIPickerView Delegate / DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return navigationFlow?.containerStack?.getModulesList().filter({ $0.forType != DeeplinkInitialViewController.self }).count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewName = navigationFlow?.containerStack?.getModulesList().filter({ $0.forType != DeeplinkInitialViewController.self })[safe: row]?.forType else {
            return nil
        }
        
        return String(describing: viewName)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = navigationFlow?.containerStack?.getModulesList().filter({ $0.forType != DeeplinkInitialViewController.self })[safe: row]
    }
}
