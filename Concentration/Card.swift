//
//  Card.swift
//  Concentration
//
//  Created by Chris William Sehnert on 12/5/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import Foundation


struct Card: Hashable {
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
        
    var isFaceUp = false
    var isMatched = false
    var previouslySeen = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}

