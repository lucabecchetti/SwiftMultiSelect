//
//  MultiSelectionViewController.swift
//  SwiftMultiSelect
//
//  Created by Luca Becchetti on 26/07/17.
//  Copyright © 2017 Luca Becchetti. All rights reserved.
//

import Foundation

/// Class that represent the selection view
class MultiSelecetionViewController: UIViewController,UIGestureRecognizerDelegate,UISearchBarDelegate {
    
    /// Screen total with
    public var totalWidth:CGFloat{
        get{
            return UIScreen.main.bounds.width
        }
    }
    
    /// Screen total height
    public var totalHeight:CGFloat{
        get{
            return UIScreen.main.bounds.height
        }
    }
    
    /// Array of selected items
    open var selectedItems : [SwiftMultiSelectItem] = [SwiftMultiSelectItem](){
        didSet{
            //Reset button navigation bar
            rightButtonBar.title = "\(Config.doneString) (\(self.selectedItems.count))"
            self.navigationItem.rightBarButtonItem?.isEnabled = (self.selectedItems.count > 0)
        }
    }
    
    /// Lazy view that represent a selection scrollview
    open fileprivate(set) lazy var selectionScrollView: UICollectionView = {
        
        //Build layout
        let layout                      = UICollectionViewFlowLayout()
        layout.sectionInset             = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection          = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing  = 0
        layout.minimumLineSpacing       = 0
        layout.itemSize                 = CGSize(width: CGFloat(Config.selectorStyle.selectionHeight),height: CGFloat(Config.selectorStyle.selectionHeight));
        
        //Build collectin view
        let selected                    = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        selected.backgroundColor        = Config.selectorStyle.backgroundColor
        selected.isHidden               = (SwiftMultiSelect.initialSelected.count <= 0)
        return selected
        
    }()
    
    /// Lazy view that represent a selection scrollview
    open fileprivate(set) lazy var separator: UIView = {
        
        //Build layout
        let sep                 = UIView()
        sep.autoresizingMask    = [.flexibleWidth]
        sep.backgroundColor     = Config.selectorStyle.separatorColor
        return sep
        
    }()
    
    /// Lazy var for table view
    open fileprivate(set) lazy var tableView: UITableView = {
        
        let tableView:UITableView = UITableView()
        tableView.backgroundColor = Config.tableStyle.backgroundColor
        return tableView
        
    }()
    
    /// Lazy var for table view
    open fileprivate(set) lazy var searchBar: UISearchBar = {
        
        let searchBar:UISearchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
        
    }()
    
    /// Lazy var for global stackview container
    open fileprivate(set) lazy var stackView: UIStackView = {
        
        let stackView           = UIStackView(arrangedSubviews: [self.searchBar,self.selectionScrollView,self.tableView])
        stackView.axis          = .vertical
        stackView.distribution  = .fill
        stackView.alignment     = .fill
        stackView.spacing       = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    /// Calculate the nav bar height if present
    var navBarHeight:CGFloat{
        get{
            if (self.navigationController != nil) {
                return self.navigationController!.navigationBar.frame.size.height + (UIApplication.shared.isStatusBarHidden ? 0 : 20)
            }else{
                return 0
            }
        }
    }
    
    //Nav bar buttons
    var leftButtonBar   : UIBarButtonItem?
    var rightButtonBar  : UIBarButtonItem = UIBarButtonItem()
    
    //Searched string
    var searchString  = ""
    
    /// Function to build a views and set constraint
    func createViewsAndSetConstraints(){

        //Add stack view to current view
        view.addSubview(stackView)
        
        selectionScrollView.addSubview(separator)
        separator.frame = CGRect(x: 0.0, y: Config.selectorStyle.selectionHeight-Config.selectorStyle.separatorHeight, width: Double(self.view.frame.size.width), height: Config.selectorStyle.separatorHeight)
        separator.layer.zPosition = CGFloat(separator.subviews.count+1)
        
        //Register tableview delegate
        tableView.delegate      =  self
        tableView.dataSource    =  self
        //Register cell class
        tableView.register(CustomTableCell.classForCoder(), forCellReuseIdentifier: "cell")
        
        //Register collectionvie delegate
        selectionScrollView.delegate    =   self
        selectionScrollView.dataSource  =   self
        //Register cell class
        selectionScrollView.register(CustomCollectionCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        
        //register search delegate
        searchBar.delegate = self
        
        //Prevent adding top margin to collectionviewcell
        self.automaticallyAdjustsScrollViewInsets = false
        
        //autolayout the stack view and elements
        let viewsDictionary = [
            "stackView" :   stackView,
            "selected"  :   self.selectionScrollView
            ] as [String : Any]
        
        //constraint for stackview
        let stackView_H = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[stackView]-0-|",
            options: NSLayoutFormatOptions(rawValue: 0),
            metrics: nil,
            views: viewsDictionary
        )
        //constraint for stackview
        let stackView_V = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[stackView]-0-|",
            options: NSLayoutFormatOptions(rawValue:0),
            metrics: nil,
            views: viewsDictionary
        )
        
        searchBar.topAnchor.constraint(equalTo: stackView.topAnchor, constant: 0).isActive        = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive                 = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive               = true
        searchBar.heightAnchor.constraint(equalToConstant: CGFloat(40)).isActive = true

        selectionScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive                 = true
        selectionScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive               = true
        selectionScrollView.heightAnchor.constraint(equalToConstant: CGFloat(Config.selectorStyle.selectionHeight)).isActive = true
        //Add all constraints to view
        view.addConstraints(stackView_H)
        view.addConstraints(stackView_V)
    }
    
    
    /// Toggle de selection view
    ///
    /// - Parameter show: true show scroller, false hide the scroller
    func toggleSelectionScrollView(show:Bool) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.selectionScrollView.isHidden = !show
        })
    }
    
    
    /// Selector for right button
    @objc public func selectionDidEnd(){
        
        SwiftMultiSelect.delegate?.swiftMultiSelect(didSelectItems: self.selectedItems)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /// Selector for left button
    @objc public func dismissSelector(){
        
        self.dismiss(animated: true, completion: nil)
        SwiftMultiSelect.delegate?.didCloseSwiftMultiSelect()
        
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = Config.viewTitle
        
        rightButtonBar.isEnabled                = false
        leftButtonBar                           = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MultiSelecetionViewController.dismissSelector))
        leftButtonBar!.isEnabled                = true
        self.navigationItem.leftBarButtonItem   = leftButtonBar
        self.navigationItem.rightBarButtonItem  = rightButtonBar
        
        rightButtonBar.action = #selector(MultiSelecetionViewController.selectionDidEnd)
        rightButtonBar.target = self
        
        self.view.backgroundColor = Config.mainBackground
        
        createViewsAndSetConstraints()
        
        self.tableView.reloadData()
        
        if(SwiftMultiSelect.initialSelected.count>0){
            self.selectionScrollView.reloadData()
            rightButtonBar.isEnabled    = true
            rightButtonBar.title        = "\(Config.doneString) (\(SwiftMultiSelect.initialSelected.count))"
        }
        
    }
}
