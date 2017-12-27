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
    
    var flipCounter: Int = 0
    var pointCounter: Int = 0
    var time = 0.0 {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name("TimeChanged"), object: nil)
        }
    }
    
    var timer = Timer()
    
    private(set) var gameOver = false
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func startTimer () {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [unowned self] (timer) in
            self.time += 0.01
            print(self.time)
        })
        
    }
    

    
    private func countScore(firstCard: Int, secondCard: Int) {
        if cards[firstCard].previouslySeen { pointCounter -= 1 }
        cards[firstCard].previouslySeen = true
        if cards[secondCard].previouslySeen { pointCounter -= 1 }
        cards[secondCard].previouslySeen = true
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): Chosen index not in the cards")
        flipCounter += 1
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                cards[index].isFaceUp = true
                
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    matchedCards += 2
                    pointCounter += 2
        
                    if matchedCards == cards.count {
                        gameOver = true
                    }
                } else { countScore(firstCard: matchIndex, secondCard: index) }
                
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): Must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        shuffle()
    }
    
    private func shuffle() {
        var tempDeck = [Card]()
        while cards.count > 0 {
            let randomIndex = cards.count.arc4Random
            tempDeck.append(cards[randomIndex])
            cards.remove(at: randomIndex)
        }
        cards = tempDeck
    }

}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

extension Int {
    var arc4Random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

