//
//  ParameterFirstViewController.swift
//  SwiftyFlow
//
//  Created by Felipe Florencio Garcia on 30/05/19.
//  Copyright © 2019 Felipe Florencio Garcia. All rights reserved.
//

import UIKit 
import SwiftyFlow

class ParameterFirstViewController: UIViewController, FlowNavigator, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var firstParameterLabel: UILabel!
    @IBOutlet weak var secondParameterLabel: UILabel!
    
    var navigationFlow: FlowManager?
    
    var firstParameter: String?
    var secondParameter: Int?

    @IBOutlet weak var picker: UIPickerView!
    
    private var selectedItem: FlowElementContainer<UIViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstParameterLabel.text = "1 - \(String(describing: firstParameter!))"
        secondParameterLabel.text = "2 - \(String(describing: secondParameter!))"
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
        return navigationFlow?.container()?.getModulesList().filter({ $0.type() != ParameterInitialViewController.self }).count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let viewName = navigationFlow?.container()?.getModulesList().filter({ $0.type() != ParameterInitialViewController.self })[safe: row]?.type() else {
            return nil
        }
        
        return String(describing: viewName)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = navigationFlow?.container()?.getModulesList().filter({ $0.type() != ParameterInitialViewController.self })[safe: row]
    }
    
    // MARK: Receive parameters
    func setParameters(first data: String, _ second: Int) {
        firstParameter = data
        secondParameter = second
    }
}
