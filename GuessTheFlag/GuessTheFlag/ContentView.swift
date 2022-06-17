//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Delwys Glokpor on 6/14/22.
//

import SwiftUI

struct FlagImage: View {
    let source: String
    
    var body: some View {
        Image(source)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

// UI
struct ContentView: View {
    // game data
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingDialog = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var rounds = 1
    @State private var guessed = 0
    private let MAX_ROUNDS = 10
    private var gameIsOver: Bool {
        rounds > MAX_ROUNDS
    }
    private var buttonText: String {
        return (!gameIsOver ? "Continue" : "Play Again")
    }
    private var buttonRole: ButtonRole? {
        return !gameIsOver ? .none : .cancel
    }
    private var alertAction: () -> Void {
        return (!gameIsOver ? askQuestion : resetGame)
    }
    private var alertMessage: String {
        let hint = guessed == correctAnswer ? "" : "That is the flag of \(countries[guessed])\n"
        return (!gameIsOver ? (hint + "Your score is \(score)") : (hint + "Final Score: \(score)"))
    }
    
    // UI
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                    .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            VStack {
                VStack {
                    Spacer()
                    Text("Guess the Flag")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    VStack(spacing: 15) {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundColor(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            // flag was tapped
                            flagTapped(number)
                        } label: {
                            FlagImage(source: countries[number])
                        }
                    }
                    Spacer()
                    Spacer()
                    Text("Score: \(score)")
                        .foregroundColor(.white)
                        .font(.title.bold())
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
        }
        // handling alert popup
        .alert(scoreTitle, isPresented: $showingDialog) {
            Button(buttonText, role: buttonRole, action: alertAction)
        } message: {
            Text(alertMessage)
        }
    }
    
    // internal gears
    /**
     * handle action on flags.
     * @param number the id of the flag tapped
     */
    func flagTapped(_ number: Int) {
        showingDialog = true // always show the alert
        guessed = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 10
        } else {
            scoreTitle = "Wrong"
        }
        rounds += 1
    }
    /**
     * set the game variables to make it playable.
     */
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    /**
     * reset game variables for the game to be able to restart
     */
    func resetGame() {
        rounds = 1
        score = 0
        askQuestion()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
