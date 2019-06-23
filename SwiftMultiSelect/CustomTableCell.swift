//
//  CustomTableCell.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 27/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation

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
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines             = 1
        label.textColor                 = Config.tableStyle.title_color
        label.font                      = Config.tableStyle.title_font
        
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
        label.textColor                 = Config.tableStyle.description_color
        label.font                      = Config.tableStyle.description_font
        
        return label
        
    }()
    
    /// Lazy var for label subtitle
    open fileprivate(set) lazy var imageAvatar: UIImageView = {
        
        let image = UIImageView()
        image.contentMode           = .scaleAspectFill
        image.image                 = Config.placeholder_image
        image.layer.cornerRadius    = CGFloat( (Config.tableStyle.tableRowHeight-(Config.tableStyle.avatarMargin*2))/2)
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
        label.textColor                 = Config.tableStyle.initials_color
        label.font                      = Config.tableStyle.initials_font
        label.layer.cornerRadius    = CGFloat( (Config.tableStyle.tableRowHeight-(Config.tableStyle.avatarMargin*2))/2)
        label.layer.masksToBounds   = true
        return label
        
    }()
    
    
    /// Constructor
    ///
    /// - Parameters:
    ///   - style: style for cell
    ///   - reuseIdentifier: string for reuse
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!)
    {
        //First Call Super
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Add subviews to current view
        [labelTitle, imageAvatar, labelSubTitle, initials].forEach { addSubview($0) }
        
        //Adjust avatar view frame
        imageAvatar.frame = CGRect(
            x       : Config.tableStyle.avatarMargin,
            y       : Config.tableStyle.avatarMargin,
            width   : Config.tableStyle.tableRowHeight-(Config.tableStyle.avatarMargin*2),
            height  : Config.tableStyle.tableRowHeight-(Config.tableStyle.avatarMargin*2)
        )
        
        //Adjust initial label view frame
        initials.frame = imageAvatar.frame
        
        //Adjust title view frame
        labelTitle.frame = CGRect(
            x       : imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.tableStyle.avatarMargin),
            y       : imageAvatar.frame.origin.y,
            width   : bounds.size.width - imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.tableStyle.avatarMargin),
            height  : imageAvatar.frame.size.height/2
        )
        
        //Adjust subtitile view frame
        labelSubTitle.frame = CGRect(
            x       : imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.tableStyle.avatarMargin),
            y       : labelTitle.frame.origin.y + labelTitle.frame.size.height,
            width   : bounds.size.width - imageAvatar.frame.origin.x + imageAvatar.frame.size.width + CGFloat(Config.tableStyle.avatarMargin),
            height  : imageAvatar.frame.size.height/2
        )
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

