//
//  ViewController.swift
//  SwiftMultiSelectDemo
//
//  Created by Luca Becchetti on 24/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import UIKit
import SwiftMultiSelect

class ViewController: UIViewController,SwiftMultiSelectDelegate {
    

    var items:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    
    
    }
    
    @IBAction func launch(_ sender: Any) {
        
        //SwiftMultiSelect.initialSelected = [items.first!,items[1],items[2]]
        SwiftMultiSelect.delegate = self
        SwiftMultiSelect.Show(to: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        for i in 0..<50{
            items.append(SwiftMultiSelectItem(row: i, title: "test\(i)", description: "description for: \(i)"))
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - SwiftMultiSelectDelegate
    
    func numberOfItemsInSwiftMultiSelect() -> Int {
        return items.count
    }

    /// Tell to delegate that item has been selected
    func swiftMultiSelect(didSelectItemAt row: Int) {
        print(row)
    }


    func swiftMultiSelect(itemAtRow row: Int) -> SwiftMultiSelectItem {
        return items[row]
    }
    
}

