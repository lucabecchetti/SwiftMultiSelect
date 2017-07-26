//
//  SwiftMultiSelect.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 24/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation

/// Define the type of datasource
public enum SwiftMultiSelectSourceType : Int{
    
    case phone  =   0
    case custom =   1
    
}

/// Main static class
public class SwiftMultiSelect{

    public static var items             :   [SwiftMultiSelectItem]?
    
    public static var dataSourceType    :   SwiftMultiSelectSourceType? = .phone{
        didSet{
            
            if self.dataSourceType == .phone{
                self.getContacts()
            }else{
                self.items = nil
            }
            
        }
    }
    
    /// Delegate reference
    public static var delegate          :   SwiftMultiSelectDelegate?{
        
        didSet{
            if self.dataSourceType == .phone{
                self.getContacts()
            }else{
                self.items = nil
            }
        }
        
    }
    
    public static var dataSource        :   SwiftMultiSelectDataSource?
    
    /// Array of initial items selected
    public static var initialSelected   :   [SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    
    
    /// Function to present a selector in a UIViewContoller claass
    ///
    /// - Parameter to: UIViewController current visibile
    public class func Show(to: UIViewController) {

        // Create instance of selector
        let selector            = MultiSelecetionViewController()
        
        // Set initial items
        selector.selectedItems  = initialSelected
        
        //Create navigation controller
        let navController       = UINavigationController(rootViewController: selector)
        
        // Present selectora
        to.present(navController, animated: true, completion: nil)
        
    }
    
    private class func getContacts(){
        //ATTENTION: You have to provide a info.plist string for access contacts
        //<key>NSContactsUsageDescription</key>
        //<string>This app needs access to contacts</string>
        //
        //Retrieve contacts from phone
        ContactsLibrary.getContacts { (success, data) in
            
            self.items = data!
            
        }
    }
    
}

// Public struct for configuration
public struct Config {
    
    public static var tableRowHeight    :   Double     = 70.0
    public static var selectionHeight   :   Double     = 90.0
    public static var avatarMargin      :   Double     = 7.0
    public static var avatarScale       :   Double     = 1.7
    
    public static var separatorColor    :   UIColor    = UIColor.lightGray
    public static var separatorHeight   :   Double     = 0.7
    
    public static var removeButtonImage :   UIImage    = #imageLiteral(resourceName: "remove")
    
    public static var viewTitle         :   String     = "Swift Multiple Select"
    public static var doneString        :   String     = "Done"
    
    public static var colorArray        :   [UIColor]  = [
        ThemeColors.amethystColor,
        ThemeColors.asbestosColor,
        ThemeColors.emeraldColor,
        ThemeColors.peterRiverColor,
        ThemeColors.pomegranateColor,
        ThemeColors.pumpkinColor,
        ThemeColors.sunflowerColor
    ]

}


//I colori degli avatar utente
public struct ThemeColors{
    static let emeraldColor         = UIColor(red: (46/255), green: (204/255), blue: (113/255), alpha: 1.0)
    static let sunflowerColor       = UIColor(red: (241/255), green: (196/255), blue: (15/255), alpha: 1.0)
    static let pumpkinColor         = UIColor(red: (211/255), green: (84/255), blue: (0/255), alpha: 1.0)
    static let asbestosColor        = UIColor(red: (127/255), green: (140/255), blue: (141/255), alpha: 1.0)
    static let amethystColor        = UIColor(red: (155/255), green: (89/255), blue: (182/255), alpha: 1.0)
    static let peterRiverColor      = UIColor(red: (52/255), green: (152/255), blue: (219/255), alpha: 1.0)
    static let pomegranateColor     = UIColor(red: (192/255), green: (57/255), blue: (43/255), alpha: 1.0)
    static let lightGrayColor       = UIColor(red:0.79, green:0.78, blue:0.78, alpha:1)
}

// Struct that represent single items of the tableView, and CollectionView
public struct SwiftMultiSelectItem{
    
    public var title        :   String
    public var description  :   String?
    public var image        :   UIImage?
    public var imageURL     :   String?
    public var userInfo     :   Any?
    public var color        :   UIColor?
    public var row          :   Int?
    
    
    /// String representation for struct
    public var string  :   String{
        var describe = "\n+--------------------+"
        describe += "\n| title: \(title)"
        describe += "\n| description: \(String(describing: self.description))"
        describe += "\n| userInfo: \(String(describing: userInfo))"
        describe += "\n| title: \(title)"
        describe += "\n+--------------------+"
        return describe
    }
    
    /// Constructor for item struct
    ///
    /// - Parameters:
    ///   - title: title, first line
    ///   - description: description, second line
    ///   - image: image asset
    ///   - imageURL: image url
    ///   - userInfo: optional information data
    public init(row:Int,title:String,description:String? = nil,image:UIImage? = nil,imageURL:String? = nil,color:UIColor? = nil, userInfo:Any? = nil) {
        
        self.title = title
        self.row   = row
        
        if let desc = description{
            self.description = desc
        }
        if let img = image{
            self.image = img
        }
        if let url = imageURL{
            self.imageURL = url
        }
        if let info = userInfo{
            self.userInfo = info
        }
        if let col = color{
            self.color = col
        }
        
        
    }
    
    /// Custom equal function to compare objects
    ///
    /// - Parameters:
    ///   - lhs: left object
    ///   - rhs: right object
    /// - Returns: True if two objects referer to the same row
    public static func ==(lhs: SwiftMultiSelectItem, rhs: SwiftMultiSelectItem) -> Bool{
        return lhs.row == rhs.row
    }
    
    /// Custom disequal function to compare objects
    ///
    /// - Parameters:
    ///   - lhs: left object
    ///   - rhs: right object
    /// - Returns: True if two objects does not referer to the same row
    public static func != (lhs: SwiftMultiSelectItem, rhs: SwiftMultiSelectItem) -> Bool{
        return lhs.row != rhs.row
    }
    
    /// Get initial letters
    ///
    /// - Returns: String 2 intials
    func getInitials() -> String {
        
        let tit = (title as NSString)
        var initials = String()
        if title != "" && tit.length >= 2
        {
            initials.append(tit.substring(to: 2))
        }
        
        return initials.uppercased()
    }
    
}


/// A data source
public protocol SwiftMultiSelectDataSource{
    
    /// Ask delegate for current item in row
    func swiftMultiSelect(itemAtRow row:Int) -> SwiftMultiSelectItem
    
    /// Asks for the number of items
    func numberOfItemsInSwiftMultiSelect() -> Int
    
}

/// A delegate to handle
public protocol SwiftMultiSelectDelegate{
    
    /// Tell to delegate that user did end selection
    func swiftMultiSelect(didSelectItems items:[SwiftMultiSelectItem])
    
    /// Tell to delegate that item has been selected
    func swiftMultiSelect(didSelectItem item:SwiftMultiSelectItem)
    
    /// Tell to delegate that item has been unselected
    func swiftMultiSelect(didUnselectItem item:SwiftMultiSelectItem)
    
    /// Tell to delegate user has closed without select
    func didCloseSwiftMultiSelect()
    
    
}


