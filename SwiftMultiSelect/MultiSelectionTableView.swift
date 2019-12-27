//
//  MultiSelectionTableView.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 26/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation
import Contacts

// MARK: - UITableViewDelegate,UITableViewDataSource
extension MultiSelecetionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SwiftMultiSelect.dataSourceType == .phone{
            if searchString == "" {
                return SwiftMultiSelect.items!.count
            }else{
                return SwiftMultiSelect.items!.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) }).count
            }
        }else{
            
            //Try to get rows from delegate
            guard let rows = SwiftMultiSelect.dataSource?.numberOfItemsInSwiftMultiSelect() else {
                return 0
            }
        
            return rows
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get Reference to Cell
        let cell : CustomTableCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableCell
        cell.selectionStyle = .none

        var item:SwiftMultiSelectItem!
        
        if SwiftMultiSelect.dataSourceType == .phone{
            item = (searchString == "") ?  SwiftMultiSelect.items![indexPath.row] : SwiftMultiSelect.items!.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) })[indexPath.row]
        }else{
            //Try to get item from delegate
            item = SwiftMultiSelect.dataSource?.swiftMultiSelect(itemAtRow: indexPath.row)
        }

        //Configure cell properties
        cell.labelTitle.text        = item.title
        cell.labelSubTitle.text     = item.description
        cell.initials.isHidden      = true
        cell.imageAvatar.isHidden   = true
        
        if let contact = item.userInfo as? CNContact{

            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                
                if(contact.imageDataAvailable && contact.imageData!.count > 0){
                    let img = UIImage(data: contact.imageData!)
                    DispatchQueue.main.async {
                        item.image = img
                        cell.imageAvatar.image      = img
                        cell.initials.isHidden      = true
                        cell.imageAvatar.isHidden   = false
                    }
                }else{
                    DispatchQueue.main.async {
                        cell.initials.text          = item.getInitials()
                        cell.initials.isHidden      = false
                        cell.imageAvatar.isHidden   = true
                    }
                }
                
            }
  
        }else{
            if item.image == nil && item.imageURL == nil{
                cell.initials.text          = item.getInitials()
                cell.initials.isHidden      = false
                cell.imageAvatar.isHidden   = true
            }else{
                if item.imageURL != ""{
                    cell.initials.isHidden      = true
                    cell.imageAvatar.isHidden   = false
                    cell.imageAvatar.setImageFromURL(stringImageUrl: item.imageURL!)
                }else{
                    cell.imageAvatar.image      = item.image
                    cell.initials.isHidden      = true
                    cell.imageAvatar.isHidden   = false
                }
            }
        }
        
        if item.color != nil{
            cell.initials.backgroundColor = item.color!
        }else{
            cell.initials.backgroundColor   = updateInitialsColorForIndexPath(indexPath)
        }
        
        
        //Set initial state
        if let itm_pre = self.selectedItems.firstIndex(where: { (itm) -> Bool in
            itm == item
        }){
            self.selectedItems[itm_pre].color = cell.initials.backgroundColor!
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        
        return cell
        
    }
    
    
    /// Function that select a random color for passed indexpath
    ///
    /// - Parameter indexpath:
    /// - Returns: UIColor random, from Config.colorArray
    func updateInitialsColorForIndexPath(_ indexpath: IndexPath) -> UIColor{
        
        //Applies color to Initial Label
        let randomValue = (indexpath.row + indexpath.section) % Config.colorArray.count
        
        return Config.colorArray[randomValue]
        
    }
    
    
    /// Function to change accessoryType for passed index
    ///
    /// - Parameters:
    ///   - row: index of row
    ///   - selected: true = chechmark, false = none
    func reloadCellState(row:Int, selected:Bool){
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? CustomTableCell{
            cell.accessoryType = (selected) ? .checkmark : .none
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Get selected cell
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableCell

        var item:SwiftMultiSelectItem!

        if SwiftMultiSelect.dataSourceType == .phone{
            item = (searchString == "") ?  SwiftMultiSelect.items![indexPath.row] : SwiftMultiSelect.items!.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) })[indexPath.row]
        } else {
            //Try to get item from delegate
            item = SwiftMultiSelect.dataSource?.swiftMultiSelect(itemAtRow: indexPath.row)
        }
        
        //Save item data 
        item.color = cell.initials.backgroundColor!

        //Check if cell is already selected or not
        if cell.accessoryType == UITableViewCell.AccessoryType.checkmark {
            
            //Set accessory type
            cell.accessoryType = UITableViewCell.AccessoryType.none

            //Comunicate deselection to delegate
            SwiftMultiSelect.delegate?.swiftMultiSelect(didUnselectItem: item)
            
            //Reload collectionview
            self.reloadAndPositionScroll(idp: item.row!, remove:true)
            
        } else {
            
            if Config.maxSelectItems != -1 && selectedItems.count >= Config.maxSelectItems - 1 {
                
                //Max number reached
                SwiftMultiSelect.delegate?.numberMaximumOfItemsReached(items: selectedItems)
                
            }
            
            if Config.maxSelectItems == -1 || selectedItems.count < Config.maxSelectItems { //Default value = -1
                
                //Set accessory type
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
                
                //Add current item to selected
                selectedItems.append(item)
                
                //Comunicate selection to delegate
                SwiftMultiSelect.delegate?.swiftMultiSelect(didSelectItem: item)
                
                //Reload collectionview
                self.reloadAndPositionScroll(idp: item.row!, remove:false)
                
            }
            
        }

        //Reset search
        if searchString != ""{
            searchBar.text = ""
            searchString = ""
            SwiftMultiSelect.delegate?.userDidSearch(searchString: "")
            self.tableView.reloadData()
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return CGFloat(Config.tableStyle.tableRowHeight)
        
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchString = searchText

        if searchText.isEmpty {
            self.perform(#selector(self.hideKeyboardWithSearchBar(_:)), with: searchBar, afterDelay: 0)
            self.searchString = ""
        }
        
        SwiftMultiSelect.delegate?.userDidSearch(searchString: searchText)
        
        self.tableView.reloadData()
    }
    
    @objc func hideKeyboardWithSearchBar(_ searchBar:UISearchBar){
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool{
        return true
    }
    
}
