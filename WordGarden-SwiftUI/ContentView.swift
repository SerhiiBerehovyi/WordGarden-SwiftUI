//
//  ContentView.swift
//  WordGarden-SwiftUI
//
//  Created by Serhii Berehovyi on 29.11.22.
//

import SwiftUI

struct ContentView: View {
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    
    private let wordsInGame = ["SWIFT", "DOG", "CAT"]
    private let maximumGuesses = 8
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = 8
    
    @State private var gameStatusMessage = "How Many Guesses To Uncover the Hidden Word?"
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    
    @State private var playAgainButtonLabel = "Another Word?"
    
    var body: some View {
        VStack {
            HStack{
                VStack (alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Text("Words to Guess: \(wordsInGame.count - (wordsMissed + wordsGuessed))")
                    Text("Words in Game: \(wordsInGame.count)")
                }
            }
            
            Spacer()
            
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(width: .infinity, height: 100)
                .minimumScaleFactor(0.5)
                .padding()
            
            Spacer()
            
            Text(revealedWord)
                .font(.title)
            
            if playAgainHidden {
                HStack {
                    TextField("", text: $guessedLetter)
                        .focused($textFieldIsFocused)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 30)
                        .overlay{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: guessedLetter) { _ in
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last else {
                                return
                            }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .onSubmit {
                            guard guessedLetter != "" else {
                                return
                            }
                            guessALetter()
                            updateGamePlay()
                        }
                    
                    Button("Guess a Letter", action: {
                        guessALetter()
                        updateGamePlay()
                    })
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled((guessedLetter == ""))
                }
            } else {
                Button(playAgainButtonLabel){
                    if currentWordIndex == wordsInGame.count {
                        currentWordIndex = 0
                        wordsMissed = 0
                        wordsGuessed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    gameStatusMessage = "How Many Guesses To Uncover the Hidden Word?"
                    wordToGuess = wordsInGame[currentWordIndex]
                    revealedWord = revealWord(wordToGuess)
                    lettersGuessed = ""
                    guessesRemaining = maximumGuesses
                    imageName = "flower\(guessesRemaining)"
                    playAgainHidden = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .animation(.easeInOut(duration: 0.5), value: 1)
                
        }
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
        .onAppear(){
            wordToGuess = wordsInGame[currentWordIndex]
            revealedWord = revealWord(wordToGuess)
            guessesRemaining = maximumGuesses
        }
    }
    
    func revealWord(_ word: String ) -> String {
        return "_" + String(repeating: " _", count: word.count-1)
    }
    
    func guessALetter(){
        lettersGuessed.append(guessedLetter)
        
        revealedWord = ""
        for letter in wordToGuess {
            if lettersGuessed.contains(letter){
                revealedWord += String(letter) + " "
            } else {
                revealedWord += "_ "
            }
        }
        revealedWord.removeLast()
        
        textFieldIsFocused = false
    }
    
    func updateGamePlay(){
        if !wordToGuess.contains(guessedLetter){
            guessesRemaining -= 1
            imageName = "flower\(guessesRemaining)"
        }
        
        if !revealedWord.contains("_"){
            gameStatusMessage = "You've Guessed It! It took You \(lettersGuessed.count) Guesses to Guess the Word!"
            wordsGuessed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else if guessesRemaining == 0 {
            gameStatusMessage = "So Sorry. You're All Out of Guesses."
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else {
            gameStatusMessage = "You've made \(lettersGuessed.count) Guess\(lettersGuessed.count > 1 ? "es" : "")"
        }
        
        if currentWordIndex == wordsInGame.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage += "\nYou've Tried All of the Words. Restart from the Beginning?"
        }
        
        guessedLetter = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
