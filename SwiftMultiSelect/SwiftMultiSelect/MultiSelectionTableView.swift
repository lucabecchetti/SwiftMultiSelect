//
//  MultiSelectionTableView.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 26/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation

// MARK: - UITableViewDelegate,UITableViewDataSource
extension MultiSelecetionViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Try to get rows from delegate
        guard let rows = SwiftMultiSelect.delegate?.numberOfItemsInSwiftMultiSelect() else {
            return 0
        }
        
        return rows
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Get Reference to Cell
        let cell : CustomTableCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableCell
        cell.selectionStyle = .none

        //Try to get item from delegate
        guard let item = SwiftMultiSelect.delegate?.swiftMultiSelect(itemAtRow: indexPath.row) else {
            return cell
        }

        //Configure cell properties
        cell.labelTitle.text    = item.title
        cell.labelSubTitle.text = item.description
        
        if item.image == nil && item.imageURL == nil{
            cell.initials.text      = item.getInitials()
            cell.initials.isHidden  = false
        }else{
            cell.initials.isHidden  = true
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
        
        //Try to get item from delegate
        guard var item = SwiftMultiSelect.delegate?.swiftMultiSelect(itemAtRow: indexPath.row) else {
            return
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
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
            //Add current item to selected
            selectedItems.append(item)
        }
        
        //Toggle scrollview
        toggleSelectionScrollView(show: selectedItems.count > 0)
        
        //Reload collectionview
        self.reloadAndPositionScroll()
        
        //Comunicate selection to delegate
        SwiftMultiSelect.delegate?.swiftMultiSelect(didSelectItemAt: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return CGFloat(Config.tableRowHeight)
        
    }
    
}


/// A delegate to handle
public protocol SwiftMultiSelectDelegate{
    
    /// Asks for the number of items
    func numberOfItemsInSwiftMultiSelect() -> Int
    
    /// Ask delegate for current item in row
    func swiftMultiSelect(itemAtRow row:Int) -> SwiftMultiSelectItem
    
    /// Tell to delegate that item has been selected
    func swiftMultiSelect(didSelectItemAt row:Int)
    
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
        label.textColor                 = UIColor.black
        label.font                      = UIFont.systemFont(ofSize: 13.0)
        
        return label
        
    }()
    
    /// Lazy var for label subtitle
    open fileprivate(set) lazy var imageAvatar: UIImageView = {
        
        let image = UIImageView()
        image.contentMode           = .scaleAspectFit
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
        label.font                      = UIFont.systemFont(ofSize: 13.0)
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






