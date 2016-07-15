//
//  Tag.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 5/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation

class Tag: Comparable, Hashable{
    //MARK: - Computed - Stored properties
    let name : String!

    
    //MARK: - Initialization
    init(name: String!){
        self.name = name
    }
    
    //MARK: - Proxies
    var proxyForComparison : String {
        
        get{
            return "\(name)"
        }
    }
    
    var proxyForSorting : String {
        get{
            return proxyForComparison
        }
    }

    internal var hashValue: Int { get {return name.hashValue}}
}

//MARK: - Equatable & Comparable
func == (lhs: Tag, rhs: Tag) -> Bool{
    
    guard (lhs !== rhs) else {
        return true
    }
    
    return lhs.proxyForComparison == rhs.proxyForComparison
}

func <(lhs: Tag, rhs: Tag) -> Bool{
    return lhs.proxyForComparison < rhs.proxyForComparison
}

