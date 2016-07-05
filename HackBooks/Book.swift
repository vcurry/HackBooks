//
//  Book.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 28/6/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import UIKit

class Book: Comparable{
    //MARK: - Computed - Stored properties
    let title : String
    let authors : NSArray
    let tags : NSArray
    let image : NSURL
    let url : NSURL
    
    //MARK: - Initialization
    init(title: String, authors: NSArray, tags: NSArray, image: NSURL, url: NSURL){
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image = image
        self.url = url
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
