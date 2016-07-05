//
//  JSONProcessing.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 2/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation
import UIKit

//MARK: - Aliases
typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]

//MARK: - Decodification
func decode(book json: JSONDictionary) throws -> Book{
    //Validamos el dict
    guard let imageURL = json["image_url"] as? String,
        image = NSURL(string: imageURL) else{
            throw BookError.resourcePointedByURLNotReachable
    }
    guard let pdfURL = json["pdf_url"] as? String,
        pdf = NSURL(string: pdfURL) else{
            throw BookError.resourcePointedByURLNotReachable
    }

    let authorsString = json["authors"] as? String
    let authors : NSArray = (authorsString?.componentsSeparatedByString(", "))!
    
    let title = json["title"] as? String
    
    if let tagsString = json["tags"] as? String{
        let tags : NSArray = tagsString.componentsSeparatedByString(", ")
        return Book(title: title!, authors: authors, tags: tags, image: image, url: pdf)
    } else{
        throw BookError.wrongJSONFormat
    }
}