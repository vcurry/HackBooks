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
    
    var tags = [Tag]()
    var books = [Book]()
    
    var favBooksArray : Array<Int> = []
    
    var dict: LibraryDictionary = LibraryDictionary()
    
    init(allBooks bs: BookArray){
        
        books = bs
        books.sortInPlace()
        
        var tagSet = Set<Tag>()

        for each in bs{
            for tag in each.tags{
                tagSet.insert(Tag(name: tag as! String))
                
            }
        }
        
        tags = Array(tagSet)
        tags.sortInPlace()
        
        dict = makeEmptyTags(tags)
        
        for tag in tags{
            for each in bs {
                if(each.tags.containsObject(tag.name)){
                    dict[tag.name]?.append(each)
                }
            }
        }

        let defaults = NSUserDefaults.standardUserDefaults()
        if let favBooks = defaults.objectForKey("diccionario"){
            favBooksArray = favBooks as! Array<Int>
            print(favBooksArray)
            let favTag = Tag(name: "favorites")
            tags.insert(favTag, atIndex: 0)
            dict[favTag.name] = BookArray()
            for each in favBooksArray {
                let book : Book = books[each]
                book.isFavorite = true
                dict[favTag.name]?.append(book)
            }
        }
    }

    
    func bookCountForTag (tag: Tag) -> Int{
        guard let tagBooks = booksForTag(tag) else {
            return 0
        }
        guard let count :Int = tagBooks.count else{
            return 0
        }
        return count
 
    }
    
    func booksForTag (tag: Tag) -> [Book]?{
        return dict[tag.name!]
        
    }
    
    func bookAtIndex(index: Int, tag: Tag) -> Book? {
        let bks = booksForTag(tag)
        let book = bks![index]
        return book
    }
    
    func bookAtIndex(index: Int) -> Book? {
        let t = tags[0]
        let book = bookAtIndex(0, tag: t)
        return book
    }
    
    func makeEmptyTags(tags:[Tag]) -> LibraryDictionary{
        var d = LibraryDictionary()
        
        for tag in tags {
            d[tag.name] = BookArray()
        }
        
        return d
    }
    
    func indexOfBook(tag: Tag, book: Book) -> Int {
        return (booksForTag(tag)?.indexOf(book))!
    }
    
    func addFavorite(book: Book){
        let favTag = Tag(name: "favorites")
        
        if(book.isFavorite) {
            if !tags.contains(favTag){
                tags.insert(favTag, atIndex: 0)
                dict[favTag.name] = BookArray()
            }
            if !((dict[favTag.name]?.contains(book))!){
                dict[favTag.name]?.append(book)
                if !favBooksArray.contains(books.indexOf(book)!){
                    favBooksArray.append(books.indexOf(book)!)
                }

            }
        } else {
            if(dict[favTag.name]?.count > 1){
                dict[favTag.name]?.removeAtIndex(indexOfBook(favTag, book: book))
                
                if favBooksArray.contains(books.indexOf(book)!){
                    favBooksArray.removeAtIndex(favBooksArray.indexOf(books.indexOf(book)!)!)
                }
            } else {
                dict.removeValueForKey(favTag.name)
                favBooksArray.removeAll()
                tags.removeAtIndex(0)
                print("borra")
            }
        }
        persistFavorite(favBooksArray)
    }
    
    func persistFavorite(bookArray : NSArray){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if favBooksArray.count>0{
            defaults.setObject(favBooksArray, forKey: "diccionario")
        }
        
       
    }
    
    
}