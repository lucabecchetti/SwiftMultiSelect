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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if SwiftMultiSelect.dataSourceType == .phone{
            return SwiftMultiSelect.items!.count
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
            item = SwiftMultiSelect.items![indexPath.row]
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
                cell.imageAvatar.image      = item.image
                cell.initials.isHidden      = true
                cell.imageAvatar.isHidden   = false
            }
        }
        
        if item.color != nil{
            cell.initials.backgroundColor = item.color!
        }else{
            cell.initials.backgroundColor   = updateInitialsColorForIndexPath(indexPath)
        }
        
        
        //Set initial state
        if let itm_pre = self.selectedItems.index(where: { (itm) -> Bool in
            itm == item
        }){
            self.selectedItems[itm_pre].color = cell.initials.backgroundColor!
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        
        return cell
        
    }
    
    func updateInitialsColorForIndexPath(_ indexpath: IndexPath) -> UIColor{
        
        //Applies color to Initial Label
        let randomValue = (indexpath.row + indexpath.section) % Config.colorArray.count
        
        return Config.colorArray[randomValue]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Get selected cell
        let cell = tableView.cellForRow(at: indexPath) as! CustomTableCell

        var item:SwiftMultiSelectItem!

        if SwiftMultiSelect.dataSourceType == .phone{
            item = SwiftMultiSelect.items![indexPath.row]
        }else{
            //Try to get item from delegate
            item = SwiftMultiSelect.dataSource?.swiftMultiSelect(itemAtRow: indexPath.row)
        }
        
        //Save item data 
        item.color = cell.initials.backgroundColor!

        //Check if cell is already selected or not
        if cell.accessoryType == UITableViewCellAccessoryType.checkmark
        {
            cell.accessoryType = UITableViewCellAccessoryType.none
            //Filter current item from selected
            selectedItems = selectedItems.filter(){
                return item != $0
            }
            
            //Comunicate deselection to delegate
            SwiftMultiSelect.delegate?.swiftMultiSelect(didUnselectItem: item)
            
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            //Add current item to selected
            selectedItems.append(item)
            //Comunicate selection to delegate
            SwiftMultiSelect.delegate?.swiftMultiSelect(didSelectItem: item)
            
        }
        
        //Toggle scrollview
        toggleSelectionScrollView(show: selectedItems.count > 0)
        
        //Reload collectionview
        self.reloadAndPositionScroll()

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return CGFloat(Config.tableRowHeight)
        
    }
    
}

/// Class to represent custom cell for tableview
class CustomTableCell: UITableViewCell
{
    
    /// Lazy var for label title
    open fileprivate(set) lazy var labelTitle: UILabel = {
        
        let label = UILabel()
        label.autoresizingMask          = [.flexibleWidth]
        label.isOpaque                  = false
        label.backgroundColor           = UIColor.clear
        label.textAlignment             = NSTextAlignment.left
        label.lineBreakMode             = .byWordWrapping
        label.minimumScaleFactor        = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines             = 1
        label.textColor                 = UIColor.black
        label.font                      = UIFont.boldSystemFont(ofSize: 16.0)
        
        return label
        
    }()
    
    /// Lazy var for label subtitle
    open fileprivate(set) lazy var labelSubTitle: UILabel = {
        
        let label = UILabel()
        label.autoresizingMask          = [.flexibleWidth]
        label.isOpaque                  = false
        label.backgroundColor           = UIColor.clear
        label.textAlignment             = NSTextAlignment.left
        label.lineBreakMode             = .byWordWrapping
        label.minimumScaleFactor        = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines             = 1
        label.textColor                 = UIColor.gray
        label.font                      = UIFont.systemFont(ofSize: 13.0)
        
        return label
        
    }()
    
    /// Lazy var for label subtitle
    open fileprivate(set) lazy var imageAvatar: UIImageView = {
        
        let image = UIImageView()
        image.contentMode           = .scaleAspectFill
        image.image                 = #imageLiteral(resourceName: "user_blank")
        image.layer.cornerRadius    = CGFloat( (Config.tableRowHeight-(Config.avatarMargin*2))/2)
        image.layer.masksToBounds   = true
        return image
        
    }()
    
    /// Lazy var for initials label
    open fileprivate(set) lazy var initials: UILabel = {
        
        let label = UILabel()
        label.isOpaque                  = false
        label.backgroundColor           = UIColor.red
        label.textAlignment             = NSTextAlignment.center
        label.lineBreakMode             = .byWordWrapping
        label.minimumScaleFactor        = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines             = 1
        label.textColor                 = UIColor.white
        label.font                      = UIFont.systemFont(ofSize: 18.0)
        label.layer.cornerRadius    = CGFloat( (Config.tableRowHeight-(Config.avatarMargin*2))/2)
        label.layer.masksToBounds   = true
        return label
        
    }()
    
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - style: style for cell
    ///   - reuseIdentifier: string for reuse
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        //First Call Super
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Add subviews to current view
        [labelTitle, imageAvatar, labelSubTitle, initials].forEach { addSubview($0) }

        //Adjust avatar view frame
        imageAvatar.frame = CGRect(
            x       : Config.avatarMargin,
            y       : Config.avatarMargin,
            width   : Config.tableRowHeight-(Config.avatarMargin*2),
            height  : Config.tableRowHeight-(Config.avatarMargin*2)
        )
        
        //Adjust initial label view frame
        initials.frame = imageAvatar.frame
        
        //Adjust title view frame
        labelTitle.frame = CGRect(
            x       : imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.avatarMargin),
            y       : imageAvatar.frame.origin.y,
            width   : bounds.size.width - imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.avatarMargin),
            height  : imageAvatar.frame.size.height/2
        )
        
        //Adjust subtitile view frame
        labelSubTitle.frame = CGRect(
            x       : imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.avatarMargin),
            y       : labelTitle.frame.origin.y + labelTitle.frame.size.height,
            width   : bounds.size.width - imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.avatarMargin),
            height  : imageAvatar.frame.size.height/2
        )
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}






