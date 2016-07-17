//
//  Book.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 28/6/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import UIKit

let BookMarkedFavorite = "Book selected as Favorite"
let BkKey = "key"

class Book: Comparable{
    //MARK: - Computed - Stored properties
    let title : String
    let authors : NSArray
    let tags : NSArray
    let imagen : UIImage
    let url : NSURL
    var isFavorite : Bool
    
    //MARK: - Initialization
    init(title: String, authors: NSArray, tags: NSArray, image: NSURL, url: NSURL){
        self.title = title
        self.authors = authors
        self.tags = tags
        self.url = url
        self.isFavorite = false
        
        var img: UIImage
        let fileManager = NSFileManager.defaultManager()
        let diskPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,
                                                            NSSearchPathDomainMask.UserDomainMask,
                                                            true)
        let cacheDirectory = NSURL(string: diskPaths[0] as String)
        let fileName = image.lastPathComponent
        let diskPath = cacheDirectory?.URLByAppendingPathComponent(fileName!)
        
        if fileManager.fileExistsAtPath("\(diskPath!)"){
            img = UIImage(data: NSData(contentsOfFile: "\(diskPath!)")!)!
        } else {
            let imageData = NSData(contentsOfURL: image)!
            img = UIImage(data: imageData)!
            imageData.writeToFile("\(diskPath!)", atomically: true)
            img = UIImage(data: imageData)!
        }
        
        imagen = img
        
    }


    //MARK: - Proxies
    var proxyForComparison : String {
        
        get{
            return "\(title)\(authors)\(url)"
        }
    }
    
    var proxyForSorting : String {
        get{
            return proxyForComparison
        }
    }
    
    func isFavoriteBook(){
        self.isFavorite = !self.isFavorite
        let nc = NSNotificationCenter.defaultCenter()
        let notif = NSNotification(name: BookMarkedFavorite, object: self, userInfo: [BkKey: self])
        nc.postNotification(notif)
    }

}

//MARK: - Equatable & Comparable
func == (lhs: Book, rhs: Book) -> Bool{
    
    guard (lhs !== rhs) else {
        return true
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: Book, rhs: Book) -> Bool{
    return lhs.proxyForComparison < rhs.proxyForComparison
}

extension Book : CustomStringConvertible{
    var description : String{
        get{
            
            if let title: String? = title, authors : NSArray? = authors{
                return "<\(self.dynamicType)\(title) -- \(authors)>"
            }
            return "<\(self.dynamicType)>"
        }
    }
}
