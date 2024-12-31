//
//  ViewController.swift
//  hangman
//
//  Created by Hadia Thaniana on 9/9/22.
//
// create arrays to hold the words and the hints (need wordToGuess and wordAsUnderscores variables)
// need some way to randomize which is being selected): Done
// need some way to randomize which word is being selected, then select the word and the hint and display them : Done
// need a way to keep track of the number of guesses being used : Done
// need a way to guess a letter and to process whether or not it is in the wordToGuess, if correct, display updated wordAsUnderscored, if incorrect, decrement number of guesses, add letter to letter bank and display letters guessed : Done
// lose game if we run out of guesses : Done
// win game if we guess every letter before running out of guesses (if wordAsUnderscores contains no more underscores, then we win) : Done

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var wordToGuessLabel: UILabel!
    @IBOutlet weak var remainingGuessesLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var letterBankLabel: UILabel!
    
    let LIST_OF_WORDS : [String] = ["panda", "pomegranite", "pineapple", "giraffe","purple"]
    let LIST_OF_HINTS : [String] = ["animal", "fruit", "Fruit", "animal","color"]
    var wordToGuess : String!
    var wordAsUnderscores : String = ""
    let MAX_NUMBER_OF_GUESSES : Int = 5
    var guessesRemaining : Int!
    var oldRandomNumber : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        inputTextField.isEnabled = false
        inputTextField.delegate = self
    }
    
    @IBAction func chooseNewWordAction(_ sender: UIButton) {
        reset()
        let index = chooseRandomNumber()
        wordToGuess = LIST_OF_WORDS[index]
        let hint = LIST_OF_HINTS[index]
        hintLabel.text = "Hint: \(hint), \(wordToGuess.count) letters"

        for _ in 1...wordToGuess.count {
            wordAsUnderscores.append("_")
        }
        wordToGuessLabel.text = wordAsUnderscores
    }
    
    func chooseRandomNumber() -> Int{
        var newRandomNumber : Int = Int(arc4random_uniform(UInt32(LIST_OF_WORDS.count)))
        if (newRandomNumber == oldRandomNumber) {
            newRandomNumber = chooseRandomNumber()
        } else {
            oldRandomNumber = newRandomNumber
        }
        return newRandomNumber
    }
    
    func reset() {
        guessesRemaining = MAX_NUMBER_OF_GUESSES
        remainingGuessesLabel.text = "\(guessesRemaining!) guesses left."
        wordAsUnderscores = ""
        inputTextField.text?.removeAll()
        letterBankLabel.text?.removeAll()
        inputTextField.isEnabled = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let letterGuessed = textField.text else  { return }
        inputTextField.text?.removeAll()
        var currentLetterBank : String = letterBankLabel.text ?? ""
        if currentLetterBank.contains(letterGuessed) {
            return
        } else {
        if wordToGuess.contains(letterGuessed) {
            processCorrectGuess(letterGuessed: letterGuessed)
        } else {
            processIncorrectGuess()
        }
            letterBankLabel.text?.append("\(letterGuessed), ")
    }
}
    
    func processCorrectGuess(letterGuessed : String) {
        let characterGuessed = Character(letterGuessed)
        for index in wordToGuess.indices {
            if wordToGuess[index] == characterGuessed {
                let endIndex = wordToGuess.index(after: index)
                let charRange = index..<endIndex
                wordAsUnderscores = wordAsUnderscores.replacingCharacters(in: charRange, with: letterGuessed)
                wordToGuessLabel.text = wordAsUnderscores
            }
        }
        if !(wordAsUnderscores.contains("_")) {
            remainingGuessesLabel.text = "You Win :)"
            inputTextField.isEnabled = false
        }
    }
 
    func processIncorrectGuess() {
        guessesRemaining! -= 1
        if guessesRemaining == 0 {
            remainingGuessesLabel.text = "You Lose! :("
            inputTextField.isEnabled = false
        } else {
            remainingGuessesLabel.text = "\(guessesRemaining!) guesses left"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = NSCharacterSet.lowercaseLetters
        let startingLength = textField.text?.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace = range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        
        if string.isEmpty {
            return true
        } else if newLength == 1 {
            if let inputTextField = string.rangeOfCharacter(from: allowedCharacters, options: .caseInsensitive) {
                return true
            }
        }
        return false
    }
}

