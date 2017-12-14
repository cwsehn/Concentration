//
//  ViewController.swift
//  Concentration
//
//  Created by Chris William Sehnert on 12/3/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    
    private let emojiArray = ["👻", "🎃", "🦇", "🧙🏼‍♂️", "🍬", "🙀", "👺", "🍭", "😈", "🍎"]
    
    private(set) var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips \(flipCount)"
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var playAgainButton: UIButton!
    
    @IBAction private func playAgain(_ sender: UIButton) {
        playAgainButton.isHidden = true
        flipCount = 0
        emoji = [:]
        emojiChoices = emojiArray
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            if game.gameOver == true {
                endGame()
            }
            updateViewFromModel()
        } else {
            print("Chosen Card not in cardButtons")
        }
        if !game.gameOver {
            flipCount += 1
            playAgainButton.isHidden = true
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
    }
    
    private var emoji = [Int:String]()
    private lazy var emojiChoices = emojiArray
    
    private func emoji(for card: Card) -> String {
        
       
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
                let randomIndex = emojiChoices.count.arc4Random
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    private func endGame() {
        flipCountLabel.text = "Game Over... \n \(flipCount) Flips!"
        playAgainButton.isHidden = false
    }
    
}
























