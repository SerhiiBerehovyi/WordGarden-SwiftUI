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
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var lettersGuessed = ""
    
    @State private var gameStatusMessage = "How Many Guesses To Uncover the Hidden Word?"
    @State private var guessedLetter = ""
    @State private var imageName = "flower8"
    
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    
    
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
                        }
                    
                    Button("Guess a Letter", action: {
                        guessALetter()
                    })
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled((guessedLetter == ""))
                }
            } else {
                Button("Another Word?"){
                    //TODO: Another Word Button action here
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            
            Spacer()
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                
        }
        .padding(.horizontal)
        .ignoresSafeArea(edges: .bottom)
        .onAppear(){
            wordToGuess = wordsInGame[currentWordIndex]
            revealedWord = revealWord(wordToGuess)
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
        guessedLetter = ""
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
