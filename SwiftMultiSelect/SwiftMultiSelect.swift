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
    
    class func image(named name: String) -> UIImage? {
        let image = UIImage(named: name) ?? UIImage(named: name, in: Bundle(for: self), compatibleWith: nil)
        return image
    }
    
}

/// Public struct for configuration and customizations
public struct Config {

    /// Background of main view
    public static var mainBackground        :   UIColor    = UIColor.white
    /// View's title
    public static var viewTitle             :   String     = "Swift Multiple Select"
    /// Title for done button
    public static var doneString            :   String     = "Done"
    //Placeholder image during lazy load
    public static var placeholder_image     :   UIImage     = SwiftMultiSelect.image(named: "user_blank")!
    /// Array of colors to use in initials
    public static var colorArray        :   [UIColor]  = [
        ThemeColors.amethystColor,
        ThemeColors.asbestosColor,
        ThemeColors.emeraldColor,
        ThemeColors.peterRiverColor,
        ThemeColors.pomegranateColor,
        ThemeColors.pumpkinColor,
        ThemeColors.sunflowerColor
    ]
    
    /// Define the style of tableview
    public struct tableStyle{
        
        //Background color of tableview
        public static var backgroundColor       :   UIColor = .white
        //Height of single row
        public static var tableRowHeight        :   Double  = 70.0
        //Margin between imageavatar and cell borders
        public static var avatarMargin          :   Double  = 7.0
        //Color for title label, first line
        public static var title_color           :   UIColor = .black
        //Font for title label
        public static var title_font            :   UIFont  = UIFont.boldSystemFont(ofSize: 16.0)
        //Color for description label, first line
        public static var description_color     :   UIColor = .gray
        //Font for description label
        public static var description_font      :   UIFont  = UIFont.systemFont(ofSize: 13.0)
        //Color for initials label
        public static var initials_color        :   UIColor = .white
        //Font for initials label
        public static var initials_font         :   UIFont  = UIFont.systemFont(ofSize: 18.0)

    }
    
    /// Define the style of scrollview
    public struct selectorStyle{
        
        //Image asset for remove button
        public static var removeButtonImage     :   UIImage = SwiftMultiSelect.image(named: "remove")!
        //The height of selectorview, all subviews will be resized
        public static var selectionHeight       :   Double  = 90.0
        //Scale factor for size of imageavatar based on cell size
        public static var avatarScale           :   Double  = 1.7
        //Color for separator line between scrollview and tableview
        public static var separatorColor        :   UIColor = UIColor.lightGray
        //Height for separator line between scrollview and tableview
        public static var separatorHeight       :   Double  = 0.7
        //Background color of uiscrollview
        public static var backgroundColor       :   UIColor = .white
        //Color for title label
        public static var title_color           :   UIColor = .black
         //Font for title label
        public static var title_font            :   UIFont  = UIFont.systemFont(ofSize: 11.0)
        //Color for initials label
        public static var initials_color        :   UIColor = .white
        //Font for initials label
        public static var initials_font         :   UIFont  = UIFont.systemFont(ofSize: 18.0)
        //Background color of collectionviewcell
        public static var backgroundCellColor   :   UIColor = .clear
        
    }

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
    
    ///Unique identifier
    fileprivate(set) var id :   Int?
    
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
    
    /// Tell to delegate user has closed without select
    func userDidSearch(searchString:String)
    
    
}

// MARK: - UIImageView
extension UIImageView{
    
    
    /// Set an image in UIImageView from remote URL
    ///
    /// - Parameter url: url of the image
    func setImageFromURL(stringImageUrl url: String){
        
        //Placeholder image
        image = Config.placeholder_image
        
        //Download async image
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if let url = URL(string: url) {
                do{
                    
                    let data = try Data.init(contentsOf: url)
                    
                    //Set image in the main thread
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                    
                }catch{
                    
                }
            }
        }
        
    }
}



