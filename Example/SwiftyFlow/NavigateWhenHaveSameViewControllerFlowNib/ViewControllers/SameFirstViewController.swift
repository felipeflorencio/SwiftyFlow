//
//  SameFirstViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 18/12/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class SameFirstViewController: UIViewController, FlowNavigator, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var navigationFlow: FlowManager?
    
    @IBOutlet weak var picker: UIPickerView!
    
    private var selectedItem: FlowElementContainer<UIViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    // MARK: - IBAction
    @IBAction func next() {
        navigationFlow?.goNext()
    }
    
    @IBAction func back() {
        navigationFlow?.getBack()
    }
    
    @IBAction func goAnywhere() {
        guard let viewSelected = selectedItem else {
            debugPrint("You did not selected any view")
            return
        }
        
        // You can't go to yourself ¬¬
        if viewSelected.type() == SameFirstViewController.self && viewSelected.identifier() == nil {
            debugPrint("You can't go to yourself")
            return
        }
        
        if let hasCustomIdentifier = selectedItem?.identifier() {
            navigationFlow?.goNext(screen: viewSelected.type(),
                                   customIdentifier: hasCustomIdentifier)
        } else {
            navigationFlow?.goNext(screen: viewSelected.type())
        }
    }
    
    // MARK: - UIPickerView Delegate / DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return navigationFlow?.container()?.getModulesList().filter({ $0.type() != SameInitialViewController.self }).count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let view = navigationFlow?.container()?.getModulesList().filter({ $0.type() != SameInitialViewController.self })[safe: row] else {
            return nil
        }
        
        if let hasIdentifier = view.identifier() {
            return hasIdentifier
        } else {
            return String(describing: view.type())
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = navigationFlow?.container()?.getModulesList().filter({ $0.type() != SameInitialViewController.self })[safe: row]
    }
}
