//
//  Concentration.swift
//  Concentration
//
//  Created by Chris William Sehnert on 12/5/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    
    var matchedCards = 0
    
    var gameOver = false
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
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
                indexOfOneAndOnlyFaceUpCard = nil
            } else {
                // either 0 or 2 cards are face up...
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                cards[index].isFaceUp = true
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



















