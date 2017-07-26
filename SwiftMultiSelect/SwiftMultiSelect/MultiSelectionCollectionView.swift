//
//  MultiSelectionCollectionView.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 26/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation

extension MultiSelecetionViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.selectedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CustomCollectionCell
 
        //Try to get item from delegate
        let item = self.selectedItems[indexPath.row]
        
        //Add target for the button
        cell.removeButton.addTarget(self, action: #selector(MultiSelecetionViewController.handleTap(sender:)), for: .touchUpInside)
        cell.removeButton.tag = indexPath.row
        
        cell.labelTitle.text    = item.title
        
        if item.image == nil && item.imageURL == nil{
            cell.initials.text      = item.getInitials()
            cell.initials.isHidden  = false
        }else{
            cell.initials.isHidden  = true
        }
        if item.color != nil{
            cell.initials.backgroundColor = item.color!
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize
    {
        
        return CGSize(width: CGFloat(Config.selectionHeight),height: CGFloat(Config.selectionHeight))
    }
    
    @objc func handleTap(sender:UIButton){
        
        selectedItems.remove(at: sender.tag)
        self.selectionScrollView.reloadData()
        self.tableView.reloadData()
        toggleSelectionScrollView(show: self.selectedItems.count > 0)
        
    }
    
    /// Reaload collectionview data and scroll to last position
    func reloadAndPositionScroll(){
        
        //Reload data
        self.selectionScrollView.reloadData()
        
        //Scroll to last position
        if selectedItems.count > 0{

            let lastItemIndex = IndexPath(item: self.selectedItems.count-1, section: 0)
            self.selectionScrollView.scrollToItem(at: lastItemIndex, at: .right, animated: true)

        }
        
        
    }
    
    
}

/// Class to represent custom cell for tableview
class CustomCollectionCell: UICollectionViewCell
{
    
    /// Lazy var for label title
    open fileprivate(set) lazy var labelTitle: UILabel = {
        
        let label = UILabel()
        label.autoresizingMask          = [.flexibleWidth]
        label.isOpaque                  = false
        label.backgroundColor           = UIColor.clear
        label.textAlignment             = NSTextAlignment.center
        label.lineBreakMode             = .byWordWrapping
        label.minimumScaleFactor        = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines             = 1
        label.textColor                 = UIColor.black
        label.font                      = UIFont.systemFont(ofSize: 11.0)
        
        return label
        
    }()

    /// Lazy var for label subtitle
    open fileprivate(set) lazy var imageAvatar: UIImageView = {
        
        let image = UIImageView()
        image.contentMode           = .scaleAspectFit
        image.image                 = #imageLiteral(resourceName: "user_blank")
        image.layer.cornerRadius    = CGFloat(Config.selectionHeight-((Config.avatarScale*2.0)*Config.avatarMargin))/2.0
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
        label.layer.cornerRadius        = CGFloat(Config.selectionHeight-((Config.avatarScale*2.0)*Config.avatarMargin))/2.0
        label.layer.masksToBounds       = true
        return label
        
    }()
    
    /// Lazy var for remove button
    open fileprivate(set) lazy var removeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Config.removeButtonImage, for: .normal)
        return button
        
    }()
    
    override init(frame: CGRect) {

        super.init(frame: frame)

        //Add subviews to current view
        [labelTitle, imageAvatar, initials, removeButton].forEach { addSubview($0) }
        
        //Adjust avatar view frame
        imageAvatar.frame = CGRect(
            x       : Config.avatarMargin*Config.avatarScale,
            y       : Config.avatarMargin/Config.avatarScale,
            width   : Config.selectionHeight-((Config.avatarScale*2.0)*Config.avatarMargin),
            height  : Config.selectionHeight-((Config.avatarScale*2.0)*Config.avatarMargin)
        )
        
        //Adjust initial label view frame
        initials.frame = imageAvatar.frame
        
        //Adjust button frame
        let btnSize = imageAvatar.frame.size.width/3
        removeButton.frame = CGRect(
            x: imageAvatar.frame.origin.x + imageAvatar.frame.size.width - (btnSize/1.5),
            y: imageAvatar.frame.origin.y,
            width: btnSize,
            height: btnSize
        )
        
        //Adjust title view frame
        labelTitle.frame = CGRect(
            x       : Double(self.imageAvatar.frame.origin.x),
            y       : Double(self.imageAvatar.frame.origin.y+self.imageAvatar.frame.size.height),
            width   : Double(bounds.width-(2*self.imageAvatar.frame.origin.x)),
            height  : 20
        )

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
