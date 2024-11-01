



import Foundation

class HangmanGame {
    let wordToGuess: String // Store the original word
    var guessedLetters: Set<Character> = []
    var remainingAttempts: Int
    var maxAttempts: Int
    
    init(wordToGuess: String, maxAttempts: Int = 7) {
        self.wordToGuess = wordToGuess.lowercased() // Keep special characters
        self.maxAttempts = maxAttempts
        self.remainingAttempts = maxAttempts
    }

    var currentWordState: String {
        return wordToGuess.map { character in
            // Display spaces and special characters as they are
            if character.isWhitespace || !character.isLetter {
                return String(character) // Return the character as is
            } else {
                return guessedLetters.contains(character) ? "\(character)" : "_"
            }
        }.joined(separator: " ")
    }

    func guess(letter: Character) -> Bool {
        let lowercasedLetter = Character(letter.lowercased())
        if guessedLetters.contains(lowercasedLetter) {
            return false // Letter already guessed
        }
        
        guessedLetters.insert(lowercasedLetter)
        
        if wordToGuess.contains(lowercasedLetter) {
            return true // Correct guess
        } else {
            remainingAttempts -= 1 // Incorrect guess
            return false
        }
    }
}
