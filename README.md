# SwiftMultiSelect - A tableview with graphical multi selection (contacts from PhoneBook or items from custom lists)
<p align="center" >
  <img src="https://user-images.githubusercontent.com/16253548/28709765-d82d454a-7381-11e7-8cd6-8d34f5c4cfd3.png" width=400px alt="SwiftMultiSelect" title="SwiftMultiSelect">
</p>

[![Version](https://img.shields.io/badge/pod-0.2.4-blue.svg)](https://cocoapods.org/pods/SwiftMultiSelect) [![License](https://img.shields.io/github/license/mashape/apistatus.svg)](https://cocoapods.org/pods/SwiftMultiSelect) [![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://cocoapods.org/pods/SwiftMultiSelect) [![Swift5](https://img.shields.io/badge/swift5-compatible-brightgreen.svg)](https://cocoapods.org/pods/SwiftMultiSelect)

During develop of my apps, i usually needed to select more than one element from a tableview, but i don't like the native ios integration, i think is not graphically clear, so, i created this library. Choose SwiftMultiSelect for your next project, I'll be happy to give you a little help!

<p align="center" >★★ <b>Star our github repository to help us!, or <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=BZD2RPBADPA6G" target="_blank"> ☕ pay me a coffee</a></b> ★★</p>
<p align="center" >Created by <a href="http://www.lucabecchetti.com">Luca Becchetti</a></p>

## Screenshots

<p align="center" >
<img src="https://user-images.githubusercontent.com/16253548/28709959-9e0389f0-7382-11e7-899c-bdc816c093c0.png" width="48%">
<img src="https://user-images.githubusercontent.com/16253548/28709960-9e2e5554-7382-11e7-9824-c093d5ad84e9.png" width="48%">
</p>


We support **portrait** and **landscape** orientation:


![simulator screen shot 28 lug 2017 11 32 34](https://user-images.githubusercontent.com/16253548/28711623-79df6d68-7388-11e7-9f81-e36c07c326d3.png)

## Demo

Try our demo on [appetize.io](https://appetize.io/embed/4zz7rwje6npp03d8u8d8a75q6g?device=iphone7&scale=100&orientation=portrait&osVersion=10.3)

## Requirements

  - iOS 9+
  - swift 5.0
  - Access for Contacts
  
## Main features
Here's a highlight of the main features you can find in SwiftMultiSelect:

* **Access PhoneBook or custom lists** Select contacts from phone book or from a custom lists
* **Fast and smooth scrolling**.
* **Multiple orientation** We support `portrait` and `landscape` orientation
* **Fully customizable**. You can customize all programmatically
  
## You also may like

Do you like `SwiftMultiSelect`? I'm also working on several other opensource libraries.

Take a look here:

* **[InAppNotify](https://github.com/lucabecchetti/InAppNotify)** - Manage in app notifications
* **[CountriesViewController](https://github.com/lucabecchetti/CountriesViewController)** - Countries selection view
* **[SwiftMulticastProtocol](https://github.com/lucabecchetti/SwiftMulticastProtocol)** - send message to multiple classes

## Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like SwiftMultiSelect in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

#### Podfile

To integrate SwiftMultiSelect into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
  use_frameworks!
  pod 'SwiftMultiSelect'
end
```

Then, run the following command:

```bash
$ pod install
```

## How to use

First of all import library in your project

```swift
import SwiftMultiSelect
```

The library can show elements from PhoneBook or from a custom list, this is defined by config variable "dataSourceType", it can assume a value from SwiftMultiSelectSourceType "enum", by default is "phone".  

```swift

/// (default) use a contact from PhoneBook, (need a string in info.plist)
SwiftMultiSelect.dataSourceType = .phone

/// (default) use items from custom list, (need to implement a datasource protocol)
SwiftMultiSelect.dataSourceType = .custom

```

### Use PhoneBook contacts

Note: If you want to use a default value "phone", insert this string in yout info.plist file:

```xml
<dict>
	
  .....
  
	<key>NSContactsUsageDescription</key>
	<string>This app needs access to contacts.</string>
  
  ....
  
</dict>
```

The basic code to show a simple multi selection is: 

```swift
//Implement delegate in your UIViewController
class ViewController: UIViewController,SwiftMultiSelectDelegate {
  
  override func viewDidLoad() {
        
        super.viewDidLoad()
      
        //Register delegate
        SwiftMultiSelect.delegate       = self
    
  }

  //MARK: - SwiftMultiSelectDelegate
    
    //User write something in searchbar
    func userDidSearch(searchString: String) {
        
        print("User is looking for: \(searchString)")
        
    }

    //User did unselect an item
    func swiftMultiSelect(didUnselectItem item: SwiftMultiSelectItem) {
        print("row: \(item.title) has been deselected!")
    }

    //User did select an item
    func swiftMultiSelect(didSelectItem item: SwiftMultiSelectItem) {
        print("item: \(item.title) has been selected!")
    }

    //User did close controller with no selection
    func didCloseSwiftMultiSelect() {
        print("no items selected")
    }

    //User completed selection
    func swiftMultiSelect(didSelectItems items: [SwiftMultiSelectItem]) {

        print("you have been selected: \(items.count) items!")
        
        for item in items{
            print(item.string)
        }
        
    }
  
}
```

### Show controller

Now, somewhere in the code, use:

```swift
   SwiftMultiSelect.Show(to: self)
```

### Use a custom list of SwiftMultiSelectItem

#### Create SwiftMultiSelectItem object

This library can show only an array of "SwiftMultiSelectItem" object, you can pass many parameters to his initializer:

```swift
let item = SwiftMultiSelectItem(
        //An incremental unique identifier
        row         : 0,
        //Title for first line
        title       : "Item 0",
        //Description line
        description : "i am description 0",
        //Image asset, shown if no imageURL has been set
        image       : UIImage(),
        //Url of remote image
        imageURL    : "",
        //Custom color, if not present a random color will be assigned
        color       : UIColor.gray
        //Your custom data, Any object
        userInfo    : ["id" : 10]
)
```

#### Implement dataSource protocol
To pass you list of SwiftMultiSelectItem, from the previuos example, you have to implement SwiftMultiSelectDataSource

```swift
//Implement delegate in your UIViewController
class ViewController: UIViewController,SwiftMultiSelectDelegate,SwiftMultiSelectDataSource {

  //Declare list to use
  var items:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
  
  override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        //Generate items
        createItems()
       
        //Se the correct data source type
        SwiftMultiSelect.dataSourceType = .custom
        
        //Register delegate
        SwiftMultiSelect.dataSource     = self
        SwiftMultiSelect.delegate       = self
        
    }
    
    //MARK: - SwiftMultiSelectDataSource
    
    func numberOfItemsInSwiftMultiSelect() -> Int {
        return items.count
    }
    
    func swiftMultiSelect(itemAtRow row: Int) -> SwiftMultiSelectItem {
        return items[row]
    }
    

}
```

### Interact with controller

To interact with controller you have a Delegate class and DataSource Class:

```swift
/// A data source
public protocol SwiftMultiSelectDataSource{
    
    /// Ask datasource for current item in row
    func swiftMultiSelect(itemAtRow row:Int) -> SwiftMultiSelectItem
    
    /// Asks datasource for the number of items
    func numberOfItemsInSwiftMultiSelect() -> Int
    
}

/// A delegate
public protocol SwiftMultiSelectDelegate{
    
    /// Called when user did end selection
    func swiftMultiSelect(didSelectItems items:[SwiftMultiSelectItem])
    
    /// Called when user has been selected an item
    func swiftMultiSelect(didSelectItem item:SwiftMultiSelectItem)
    
    /// Called when user has been unselected an item
    func swiftMultiSelect(didUnselectItem item:SwiftMultiSelectItem)
    
    /// Called when user has been closed with no selection
    func didCloseSwiftMultiSelect()
    
    /// Called when user did write in searchbar
    func userDidSearch(searchString:String)   
}
```

### Customization

SwiftMultiSelect is fully customizable, to configure it you have to modify that Config struct:

```swift
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
```

You can set variables before show a controller, for example in ViewDidLoad:

```swift
override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup
        Config.doneString = "Ok"
        
        SwiftMultiSelect.dataSource     = self
        SwiftMultiSelect.delegate       = self
        
}
```

## Projects using SwiftMultiSelect

- Frind - [www.frind.it](https://www.frind.it) 
- OnItsWay - [OnItsWay](https://itunes.apple.com/us/app/onitsway-deliveries-made-easy/id1190157855?ls=1&mt=8)

### Your App and SwiftMultiSelect
I'm interested in making a list of all projects which use this library. Feel free to open an Issue on GitHub with the name and links of your project; we'll add it to this site.

## Credits & License
SwiftMultiSelect is owned and maintained by [Luca Becchetti](http://www.lucabecchetti.com) 

As open source creation any help is welcome!

The code of this library is licensed under MIT License; you can use it in commercial products without any limitation.

The only requirement is to add a line in your Credits/About section with the text below:

```
In app notification by SwiftMultiSelect - http://www.lucabecchetti.com
Created by Becchetti Luca and licensed under MIT License.
```
## About me

I am a professional programmer with a background in software design and development, currently developing my qualitative skills on a startup company named "[Frind](https://www.frind.it) " as Project Manager and ios senior software engineer.

I'm high skilled in Software Design (10+ years of experience), i have been worked since i was young as webmaster, and i'm a senior Php developer. In the last years i have been worked hard with mobile application programming, Swift for ios world, and Java for Android world.

I'm an expert mobile developer and architect with several years of experience of team managing, design and development on all the major mobile platforms: iOS, Android (3+ years of experience).

I'm also has broad experience on Web design and development both on client and server side and API /Networking design. 

All my last works are hosted on AWS Amazon cloud, i'm able to configure a netowrk, with Unix servers. For my last works i configured apache2, ssl, ejabberd in cluster mode, Api servers with load balancer, and more.

I live in Assisi (Perugia), a small town in Italy, for any question, [contact me](mailto:luca.becchetti@brokenice.it)
