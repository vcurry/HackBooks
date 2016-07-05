//
//  Library.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 2/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation

class Library {
    
    typealias BookArray = [Book]
    typealias LibraryDictionary = [String: BookArray]
    
 //   var books: BooksArray
    
    var tags = []
    
    var dict: LibraryDictionary = LibraryDictionary()
    
    init(allBooks bs: BookArray){
        
        var tagSet = Set<String>()

        for each in bs{
            for tag in each.tags{
                tagSet.insert(tag as! String)
            }
        }
        
        tags = Array(tagSet)
        
        dict = makeEmptyTags(tags as! [String])
        
        for tag in tags{
            for each in bs {
                if(each.tags.containsObject(tag)){
                    dict[tag as! String]?.append(each)
                }
            }
        }
    }
    
/*    var booksCount: Int{
        get{
            let count: Int = self.books.count
            return count
        }
    }
    */
    
    func bookCountForTag (tag: String?) -> Int{
        let tagBooks = booksForTag(tag)
        let count: Int = tagBooks!.count
        return count
    }
    
    func booksForTag (tag: String?) -> [Book]?{
        return dict[tag!]
        
    }
    
    func bookAtIndex(index: Int, tag: String?) -> Book? {
        let bks = booksForTag(tag)
        let book = bks![index]
        return book
    }
    
    func bookAtIndex(index: Int) -> Book? {
        let t = tags.objectAtIndex(0)
        let book = bookAtIndex(0, tag: t as? String)
        return book
    }
    
    func makeEmptyTags(tags:[String]) -> LibraryDictionary{
        var d = LibraryDictionary()
        
        for tag in tags {
            d[tag] = BookArray()
        }
        
        return d
    }
    
}