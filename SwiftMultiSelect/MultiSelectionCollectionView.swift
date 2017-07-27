//
//  MultiSelectionCollectionView.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 26/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation
import Contacts

extension MultiSelecetionViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.selectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CustomCollectionCell
 
        //Try to get item from delegate
        var item = self.selectedItems[indexPath.row]
        
        //Add target for the button
        cell.removeButton.addTarget(self, action: #selector(MultiSelecetionViewController.handleTap(sender:)), for: .touchUpInside)
        cell.removeButton.tag       = item.row!
        cell.labelTitle.text        = item.title
        cell.initials.isHidden      = true
        cell.imageAvatar.isHidden   = true
        
        //Test if items it's CNContact
        if let contact = item.userInfo as? CNContact{
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
                
                //Build contact image in background
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
           
        //Item is custom type
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
        
        //Set item color
        if item.color != nil{
            cell.initials.backgroundColor = item.color!
        }
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: CGFloat(Config.selectorStyle.selectionHeight),height: CGFloat(Config.selectorStyle.selectionHeight))
    }
    
    @objc func handleTap(sender:UIButton){

        //Find current item
        let item = selectedItems.filter { (itm) -> Bool in
            itm.row == sender.tag
        }.first
        
        //remove item
        reloadAndPositionScroll(idp: item!.row!, remove: true)

        if self.selectedItems.count <= 0 {
            //Comunicate deselection to delegate
            toggleSelectionScrollView(show: false)
        }
        
    }
    
    
    /// Remove item from collectionview and reset tag for button
    ///
    /// - Parameter index: id to remove
    func removeItemAndReload(index:Int){

        //if no selection reload all
        if selectedItems.count == 0{
            self.selectionScrollView.reloadData()
        }else{
            //reload current
            self.selectionScrollView.deleteItems(at: [IndexPath(item: index, section: 0)])
        }
    }
    
    /// Reaload collectionview data and scroll to last position
    ///
    /// - Parameters:
    ///   - idp: is the tableview position index
    ///   - remove: true if you have to remove item
    func reloadAndPositionScroll(idp:Int, remove:Bool){
        
        //Identify the item inside selected array
        let item = selectedItems.filter { (itm) -> Bool in
            itm.row == idp
        }.first

        //Remove
        if remove {

            //For remove from collection view and create IndexPath, i need the index posistion in the array
            let id = selectedItems.index { (itm) -> Bool in
                itm.row == idp
            }
            
            //Filter array removing the item
            selectedItems = selectedItems.filter({ (itm) -> Bool in
                itm.row != idp
            })

            //Reload collectionview
            if id != nil{
                removeItemAndReload(index: id!)
            }

            SwiftMultiSelect.delegate?.swiftMultiSelect(didUnselectItem: item!)
            
            //Reload cell state
            reloadCellState(row: idp, selected: false)
            
            
            if selectedItems.count <= 0{
                //Toggle scrollview
                toggleSelectionScrollView(show: false)
            }
            
            
            
        //Add
        }else{
            
            toggleSelectionScrollView(show: true)
            
            //Reload data
            self.selectionScrollView.insertItems(at: [IndexPath(item: selectedItems.count-1, section: 0)])
            let lastItemIndex = IndexPath(item: self.selectedItems.count-1, section: 0)
        
            //Scroll to selected item
            self.selectionScrollView.scrollToItem(at: lastItemIndex, at: .right, animated: true)
            
            reloadCellState(row: idp, selected: true)
            
        
        }
        
        
        
    }
    
    
}

