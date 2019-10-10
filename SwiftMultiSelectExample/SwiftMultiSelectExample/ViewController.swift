//
//  ViewController.swift
//  SwiftMultiSelectDemo
//
//  Created by Luca Becchetti on 24/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import UIKit
import SwiftMultiSelect

class ViewController: UIViewController,SwiftMultiSelectDelegate,SwiftMultiSelectDataSource {

    @IBOutlet weak var switchAddress: UISwitch!
    @IBOutlet weak var badge: UILabel!
    @IBOutlet weak var switchInitial: UISwitch!
    var items:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var initialValues:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var selectedItems:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        badge.isHidden              = true
        badge.layer.masksToBounds   = true
        badge.layer.cornerRadius    = 25
        createItems()
       
        Config.doneString = "Ok"
        Config.maxSelectItems = 3
        SwiftMultiSelect.dataSource     = self
        SwiftMultiSelect.delegate       = self
    }
    
    
    /// Create a custom items set
    func createItems(){
        
        self.items.removeAll()
        self.initialValues.removeAll()
        for i in 0..<50{
            items.append(SwiftMultiSelectItem(row: i, title: "test\(i)", description: "description for: \(i)", imageURL : (i == 1 ? "https://randomuser.me/api/portraits/women/68.jpg" : nil)))
        }
        self.initialValues = [self.items.first!,self.items[1],self.items[2]]
        self.selectedItems = items
    }
    
    
    /// selector for switch addressbook
    ///
    /// - Parameter sender
    @IBAction func useAddr(_ sender: Any) {
        
        SwiftMultiSelect.dataSourceType = (switchAddress.isOn) ? .phone : .custom
    }
    
    
    /// Function to launch selector from button
    ///
    /// - Parameter sender
    @IBAction func launch(_ sender: Any) {
        
        //Example to start a selector with initial values
        if (switchInitial.isOn) {
            SwiftMultiSelect.initialSelected = initialValues
        }else{
            SwiftMultiSelect.initialSelected = []
        }
        
        SwiftMultiSelect.Show(to: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SwiftMultiSelectDelegate
    
    func userDidSearch(searchString: String) {
        if searchString == ""{
            selectedItems = items
        }else{
            selectedItems = items.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) })
        }
    }

    func numberOfItemsInSwiftMultiSelect() -> Int {
        return selectedItems.count
    }

    func swiftMultiSelect(didUnselectItem item: SwiftMultiSelectItem) {
        print("row: \(item.title) has been deselected!")
    }

    func swiftMultiSelect(didSelectItem item: SwiftMultiSelectItem) {
        print("item: \(item.title) has been selected!")
    }
    
    func numberMaximumOfItemsReached(items: [SwiftMultiSelectItem]) {
        print("Maximum of \(Config.maxSelectItems.self) reached with items: \n\t\(items)")
    }

    func didCloseSwiftMultiSelect() {
        badge.isHidden = true
        badge.text = ""
    }

    func swiftMultiSelect(itemAtRow row: Int) -> SwiftMultiSelectItem {
        return selectedItems[row]
    }
    
    func swiftMultiSelect(didSelectItems items: [SwiftMultiSelectItem]) {

        initialValues   = items
        badge.isHidden  = (items.count <= 0)
        badge.text      = "\(items.count)"
        
        print("you have been selected: \(items.count) items!")
        
        for item in items{
            print(item.string)
        }
        
    }
    
}

