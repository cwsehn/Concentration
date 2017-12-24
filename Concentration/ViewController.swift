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
    
    let themeList: [(emojis: String, cardColor: UIColor, secondaryColor: UIColor)] = [
        ("👻🎃🦇🧙🏼‍♂️🍬🙀👺🍭😈🍎", #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)),
        ("🎄🎅🏼✨🎁☃️❄️⛪️🐪👑🥂🥁🐑👼🏻🎺", #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1))
    ]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        updateFlipCountLabel()
        view.backgroundColor = themeList[1].secondaryColor
        
    }
    
    private func updateFlipCountLabel() {
        let flipCount = game.flipCounter
        var attributedString: NSAttributedString
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : themeList[1].cardColor
        ]
        if game.gameOver {
            attributedString = NSAttributedString(string: "Game Over... \n \(flipCount) Flips!", attributes: attributes)
        } else if (flipCount == 0) {
            attributedString = NSAttributedString(string: "Let's Play!", attributes: attributes)
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
        emojiChoices = themeList[1].emojis
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
                button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)

            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : themeList[1].cardColor
            }
        }
    }
    
    private var emoji = [Card:String]()
    private lazy var emojiChoices = themeList[1].emojis
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
                let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4Random)
                emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    private func endGame() {
        playAgainButton.setTitle("Play Again?", for: .normal)
        updateFlipCountLabel()
        playAgainButton.isHidden = false
    }
    
}

























