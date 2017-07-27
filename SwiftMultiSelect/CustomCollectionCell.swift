//
//  CustomCollectionCell.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 27/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation


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
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines             = 1
        label.textColor                 = Config.selectorStyle.title_color
        label.font                      = Config.selectorStyle.title_font
        
        return label
        
    }()
    
    /// Lazy var for label subtitle
    open fileprivate(set) lazy var imageAvatar: UIImageView = {
        
        let image = UIImageView()
        image.contentMode           = .scaleAspectFill
        image.image                 = Config.placeholder_image
        image.layer.cornerRadius    = CGFloat(Config.selectorStyle.selectionHeight-((Config.selectorStyle.avatarScale*2.0)*Config.tableStyle.avatarMargin))/2.0
        image.layer.masksToBounds   = true
        return image
        
    }()
    
    /// Lazy var for initials label
    open fileprivate(set) lazy var initials: UILabel = {
        
        let label = UILabel()
        label.isOpaque                  = false
        label.backgroundColor           = UIColor.gray
        label.textAlignment             = NSTextAlignment.center
        label.lineBreakMode             = .byWordWrapping
        label.minimumScaleFactor        = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines             = 1
        label.textColor                 = Config.selectorStyle.initials_color
        label.font                      = Config.selectorStyle.initials_font
        label.layer.cornerRadius        = CGFloat(Config.selectorStyle.selectionHeight-((Config.selectorStyle.avatarScale*2.0)*Config.tableStyle.avatarMargin))/2.0
        label.layer.masksToBounds       = true
        return label
        
    }()
    
    /// Lazy var for remove button
    open fileprivate(set) lazy var removeButton: UIButton = {
        
        let button = UIButton()
        button.setImage(Config.selectorStyle.removeButtonImage, for: .normal)
        return button
        
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        //Add subviews to current view
        [labelTitle, imageAvatar, initials, removeButton].forEach { addSubview($0) }
        
        //Adjust avatar view frame
        imageAvatar.frame = CGRect(
            x       : Config.tableStyle.avatarMargin*Config.selectorStyle.avatarScale,
            y       : Config.tableStyle.avatarMargin/Config.selectorStyle.avatarScale,
            width   : Config.selectorStyle.selectionHeight-((Config.selectorStyle.avatarScale*2.0)*Config.tableStyle.avatarMargin),
            height  : Config.selectorStyle.selectionHeight-((Config.selectorStyle.avatarScale*2.0)*Config.tableStyle.avatarMargin)
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
        
        backgroundColor = Config.selectorStyle.backgroundCellColor
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
