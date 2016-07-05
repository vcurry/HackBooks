//
//  Errors.swift
//  HackBooks
//
//  Created by Verónica Cordobés on 2/7/16.
//  Copyright © 2016 Verónica Cordobés. All rights reserved.
//

import Foundation

// MARK: JSON Errors
enum BookError: ErrorType{
    case wrongURLFormatForJSONResource
    case resourcePointedByURLNotReachable
    case jsonParsingError
    case wrongJSONFormat
    case nilJSONObject
}