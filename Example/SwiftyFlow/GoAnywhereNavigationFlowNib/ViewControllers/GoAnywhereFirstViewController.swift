//
//  GoAnywhereFirstViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 10/05/2019.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class GoAnywhereFirstViewController: UIViewController, FlowNavigator, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        
        // You can't go to your self ¬¬
        if viewSelected.type() == type(of: self) {
            debugPrint("You can't go to yourself")
            return
        }
        
        navigationFlow?.goNext(screen: viewSelected.type())
    }
    
    // MARK: - UIPickerView Delegate / DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return navigationFlow?.container()?.getModulesList().filter({ $0.type() != GoAnywhereInitialViewController.self }).count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewName = navigationFlow?.container()?.getModulesList().filter({ $0.type() != GoAnywhereInitialViewController.self })[safe: row]?.type() else {
            return nil
        }
        
        return String(describing: viewName)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = navigationFlow?.container()?.getModulesList().filter({ $0.type() != GoAnywhereInitialViewController.self })[safe: row]
    }
}
