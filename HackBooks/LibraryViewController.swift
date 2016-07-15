//
//  LibraryViewController.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 3/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import UIKit

let BookDidChangeNotification = "Selected Book did change"
let BookKey = "key"

class LibraryViewController: UITableViewController {

 
    let model : Library
    var delegate : LibraryViewControllerDelegate?
    
    let segment : UISegmentedControl = UISegmentedControl(items: ["Tags", "Books"])
    
    var segmentModel = []
    
    init(model: Library){
        self.model = model
        self.segmentModel = model.tags
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bk = book(forIndexPath: indexPath)
        if(UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            print(bk)
            let bookVC = BookViewController(model: bk)
            self.navigationController?.pushViewController(bookVC, animated: true)
        }else{
        // Avisar al delegado
        delegate?.libraryViewController(self, didSelectBook: bk)
        
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey: bk])
        nc.postNotification(notif)
        }
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return segmentModel.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentModel == model.tags){
            return model.bookCountForTag(getTag(forSection: section))
        } else {
            return segmentModel.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       // let cellId = "BookCell"
        
        let bk : Book?
        
        if(segmentModel == model.tags){
            bk = model.bookAtIndex(indexPath.row, tag: getTag(forSection: indexPath.section))
        } else {
            bk = segmentModel[indexPath.row] as? Book
        }
        let cell : CellTableViewCell = tableView.dequeueReusableCellWithIdentifier(CellTableViewCell() .cellId as String) as! CellTableViewCell
        
     /*   if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }*/
        
        cell.title.text = bk?.title
        cell.authors.text = bk?.authors.componentsJoinedByString(", ")
        cell.bookImage.image = downloadImage((bk?.image)!)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell = CellTableViewCell()
        return cell.cellHeight
    }
    
    func getTag(forSection section: Int) -> Tag{
        let tag = model.tags[section]
        return tag
    }
    
    func book(forIndexPath indexPath: NSIndexPath) -> Book {
        if (segmentModel == model.tags){
            return model.bookAtIndex(indexPath.row, tag: getTag(forSection: indexPath.section))!
        } else {
            return segmentModel[indexPath.row] as! Book
        }

    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(segmentModel == model.tags){
            let t = getTag(forSection: section)
            return t.name
        }
        return ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(bookMarkedFavorite), name: BookMarkedFavorite, object: nil)
        
    }
    
    func downloadImage(imageURL: NSURL) -> UIImage{
        var imagen: UIImage
        let fileManager = NSFileManager.defaultManager()
        let diskPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,
                                                            NSSearchPathDomainMask.UserDomainMask,
                                                            true)
        let cacheDirectory = NSURL(string: diskPaths[0] as String)
        let fileName = imageURL.lastPathComponent
        let diskPath = cacheDirectory?.URLByAppendingPathComponent(fileName!)
        
        if fileManager.fileExistsAtPath("\(diskPath!)"){
            imagen = UIImage(data: NSData(contentsOfFile: "\(diskPath!)")!)!
        } else {
            let imageData = NSData(contentsOfURL: imageURL)!
            imagen = UIImage(data: imageData)!
            imageData.writeToFile("\(diskPath!)", atomically: true)
            print(diskPath)
            imagen = UIImage(data: imageData)!
        }
        
        return imagen

    }
    
    func bookMarkedFavorite(notification: NSNotification){
        let info = notification.userInfo!
        let book = info[BkKey] as? Book
        print(book)
        model.addFavorite(book!)
        segmentModel = model.tags
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segment.addTarget(self, action:#selector(LibraryViewController.valueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.tableHeaderView = segment
        
        let nib = UINib(nibName: "CellTableViewCell", bundle: nil)
        let cell = CellTableViewCell()
        tableView.registerNib(nib, forCellReuseIdentifier: cell.cellId as String)
    }
    
    func valueChanged(sender : UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            segmentModel = model.tags
        } else if sender.selectedSegmentIndex == 1 {
            segmentModel = model.books
        }
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(self)
    }

}

protocol LibraryViewControllerDelegate {
    func libraryViewController(vc: LibraryViewController, didSelectBook bk: Book)
}
