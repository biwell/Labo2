//
//  ViewController.swift
//  Labo2
//
//  Created by Gabriel Poirier (Étudiant) on 2024-10-31.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imagePendu: UIImageView!
    @IBOutlet weak var labelPointage: UILabel!
    @IBOutlet weak var labelLettreEssaie: UILabel!
    @IBOutlet weak var lettreTextFIeld: UITextField!
    @IBOutlet weak var bouttonValider: UIButton!
    @IBOutlet weak var labelUnderscore: UILabel!
    
    var game: HangmanGame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch a random movie title and set up the game
        fetchRandomMovieTitle { [weak self] title in
            DispatchQueue.main.async {
                // Initialize the game with the fetched title
                self?.game = HangmanGame(wordToGuess: title)
               
                self?.updateView()
               
                               
                print(self?.game.wordToGuess)  // Print the fetched title for debugging
            }
        }
        
    }
    @IBAction func validateGuess(_ sender: UIButton) {
           
        // Get the letter from the text field
           guard let letter = lettreTextFIeld.text?.lowercased(), !letter.isEmpty else {
               print("Please enter a valid letter.")
               updateView()
               return
           }
           
           // Check if the letter is a single character
           guard letter.count == 1, let character = letter.first else {
               print("Please enter only one letter.")
               updateView()
               return
           }
           
           // Check if the character is a valid letter (A-Z)
           guard character.isLetter else {
               print("Invalid character! Please enter a letter.")
               updateView()
               return
           }
        
           // Make the guess in the game
           let isCorrectGuess = game.guess(letter: character)
        
        if isCorrectGuess{
            print("Correct guess!")
        }else{
            print("Incorrect guess! Remaining attempts: \(game.remainingAttempts)")
        }
        // Check for win or loss
           if game.remainingAttempts == 0 {
               showAlert(title: "Game Over", message: "You've lost! The word was '\(game.wordToGuess)'.")
           } else if game.currentWordState.replacingOccurrences(of: " ", with: "") == game.wordToGuess.replacingOccurrences(of: " ", with: "")
{
               showAlert(title: "Congratulations!", message: "You've guessed the word: '\(game.wordToGuess)'.")
           }
        
        // Update the view after the guess
        updateView()  // Update the view to reflect the current word state
        
        
       
        }
    func updateView() {
            labelUnderscore.text = game.currentWordState
        // Clear the text field
        lettreTextFIeld.text = ""
        let guessedLetters = game.guessedLetters.map { String($0) }.joined(separator: ", ")
           labelLettreEssaie.text = " \(guessedLetters)"
        labelPointage.text = "Pointage: \(game.remainingAttempts) / \(game.maxAttempts)"
        print(self.game.currentWordState)
        imagePendu.image = UIImage(named: imageNameSequence[game.maxAttempts-game.remainingAttempts])
        

        }
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Optionally, you can reset the game here or do something else
            self.resetGame()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func resetGame() {
        // Reset game logic
        fetchRandomMovieTitle { [weak self] title in
            DispatchQueue.main.async {
                self?.game = HangmanGame(wordToGuess: title)
                self?.updateView() // Reset the view to the initial state
                
            }
        }
    }
    
}

