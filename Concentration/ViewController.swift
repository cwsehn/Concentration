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
    
    let themeList: [(emojis: String, cardColor: UIColor, secondaryColor: UIColor, cardBkg: UIColor)] = [
        ("👻🎃🦇🧙🏼‍♂️🍬🙀👺🍭😈🍎", #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)),
        ("🚗🚕🚌🚎🏎🚓🚑🚒🚜🛵🏍🚂🚁🚀🛸🛩🛶⛵️🚢", #colorLiteral(red: 0.9764705882, green: 0.05098039216, blue: 0.4862745098, alpha: 1), #colorLiteral(red: 0.3411764706, green: 0.1529411765, blue: 0.9529411765, alpha: 1), #colorLiteral(red: 0.04705882353, green: 0.9450980392, blue: 0.7960784314, alpha: 1)),
        ("⚽️🏀🏈⚾️🎾🏐🏉🎱🏓🏸🏒⛳️🎳🥊", #colorLiteral(red: 0.3490196078, green: 0.1333333333, blue: 0.5647058824, alpha: 1), #colorLiteral(red: 0.8392156863, green: 0.5411764706, blue: 0.1450980392, alpha: 1), #colorLiteral(red: 0.4705882353, green: 0.7607843137, blue: 0.1333333333, alpha: 1)),
        ("🍏🍓🍊🍉🍌🍋🍒🍇🍐🍑🍍🥥🥝🍈",#colorLiteral(red: 0.6117647059, green: 0.05490196078, blue: 0.2078431373, alpha: 1), #colorLiteral(red: 0.6117647059, green: 0.5764705882, blue: 0.1058823529, alpha: 1), #colorLiteral(red: 0.9098039216, green: 0.862745098, blue: 0.2156862745, alpha: 1)),
        ("🐶🐱🐭🐹🐰🦊🐻🐼🐨🐯🦁🐮🐷🐸🐵",#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),
        ("🎄🎅🏼✨🎁☃️❄️⛪️🐪👑🥂🥁🐑👼🏻🎺", #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
    ]
   
    private lazy var currentTheme = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentTheme = chooseTheme()
        updateViewFromModel()
        updateFlipCountLabel()
    }
    
    private func chooseTheme() -> Int {
        return themeList.count.arc4Random
    }
    
    private func updateFlipCountLabel() {
        let flipCount = game.flipCounter
        var attributedString: NSAttributedString
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : themeList[currentTheme].cardColor
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
        currentTheme = chooseTheme()
        view.backgroundColor = themeList[currentTheme].secondaryColor
        emoji = [:]
        emojiChoices = themeList[currentTheme].emojis
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
                button.backgroundColor = themeList[currentTheme].cardBkg

            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : themeList[currentTheme].cardColor
            }
        }
    }
    
    private var emoji = [Card:String]()
    private lazy var emojiChoices = themeList[currentTheme].emojis
    
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

























