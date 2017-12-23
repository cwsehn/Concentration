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
    
    private var numberOfPairsOfCards: Int {
            return (cardButtons.count + 1) / 2
    }
    
    private let emojis = "👻🎃🦇🧙🏼‍♂️🍬🙀👺🍭😈🍎"
    
    private func updateFlipCountLabel() {
        let flipCount = game.flipCounter
        var attributedString: NSAttributedString
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        if game.gameOver {
            attributedString = NSAttributedString(string: "Game Over... \n \(flipCount) Flips!", attributes: attributes)
        } else {
            attributedString = NSAttributedString(string: "Flips \(flipCount)", attributes: attributes)
        }
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var playAgainButton: UIButton!
    
    @IBAction private func playAgain(_ sender: UIButton) {
        playAgainButton.isHidden = true
        emoji = [:]
        emojiChoices = emojis
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        game.flipCounter = 0
        updateFlipCountLabel()
        updateViewFromModel()
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateFlipCountLabel()
            if game.gameOver == true {
                endGame()
            }
            updateViewFromModel()
        } else {
            print("Chosen Card not in cardButtons")
        }
        if !game.gameOver {
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
    
    private var emoji = [Card:String]()
    private lazy var emojiChoices = emojis
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
                let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4Random)
                emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    private func endGame() {
        playAgainButton.setTitle("Play Again?", for: .normal)
        playAgainButton.isHidden = false
        updateFlipCountLabel()
    }
    
}

























