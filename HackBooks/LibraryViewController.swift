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
    
    init(model: Library){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bk = book(forIndexPath: indexPath)
        
        // Avisar al delegado
        delegate?.libraryViewController(self, didSelectBook: bk)
        
        //Enviamos la misma info via personaje
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookDidChangeNotification, object: self, userInfo: [BookKey: bk])
        nc.postNotification(notif)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return model.tags.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.bookCountForTag(getTag(forSection: section))
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "BookCell"
        
        let bk = model.bookAtIndex(indexPath.row, tag: getTag(forSection: indexPath.section))
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil{
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = bk?.title
        
        return cell!
    }
    
    func getTag(forSection section: Int) -> String{
        return model.tags.objectAtIndex(section) as! String
    }
    
    func book(forIndexPath indexPath: NSIndexPath) -> Book{
        return model.bookAtIndex(indexPath.row, tag: getTag(forSection: indexPath.section))!
    }

    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return getTag(forSection: section)
    }

}

protocol LibraryViewControllerDelegate {
    func libraryViewController(vc: LibraryViewController, didSelectBook bk: Book)
}
