//
//  Concentration.swift
//  Concentration
//
//  Created by Chris William Sehnert on 12/5/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import Foundation

class Concentration {
    
    private(set) var cards = [Card]()
    
    private var matchedCards = 0
    
    private(set) var gameOver = false
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    } else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    
    
    
    func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matchedCards += 2
        
                    if matchedCards == cards.count {
                        gameOver = true
                    }
                }
                cards[index].isFaceUp = true
            } else {
                // either 0 or 2 cards are face up...
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffle()
    }
    
    private func shuffle() {
        var tempDeck = [Card]()
        while cards.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            tempDeck.append(cards[randomIndex])
            cards.remove(at: randomIndex)
        }
        cards = tempDeck
    }
    
}



















