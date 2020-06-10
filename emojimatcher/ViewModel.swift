//
//  viewModel.swift
//  flippyCards
//
//  Created by shreyas gupta on 21/05/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

class viewModel: ObservableObject{
    //Model initialisation
    //to make sure many views don't change it. private set lets other only see but not modify
    // the currTheme stores the current theme our game is using
    private(set) var currTheme: gameTheme
    
    static let emojiThemeList = [
        gameTheme(themeName: "Romantic", themeEmojis: ["❤️", "💕", "💛", "🥰", "😘", "😍", "😻", "💋"], cardColor: Color.purple),
        gameTheme(themeName: "Horror", themeEmojis: ["👻", "💀", "☠️", "👹", "😈", "🧟‍♂️", "🧛🏿", "👺" ], cardColor: Color.green),
        gameTheme(themeName: "Nature", themeEmojis: ["🌪", "☀️", "🌈", "⛈", "🌲", "🌊", "⛰", "🌑"], cardColor: Color.blue),
        gameTheme(themeName: "Classic", themeEmojis: ["😂", "😇", "😝", "🤪", "😎", "🥳", "🤓", "🤮"], cardColor: Color.orange),
        gameTheme(themeName: "Sci-fi", themeEmojis: ["👽", "🤖", "🦾", "🧑🏾‍🚀", "🛸", "🚀", "🐉", "🧬"], cardColor: Color.yellow),
        gameTheme(themeName: "animals", themeEmojis: ["🐶", "🐹", "🐵", "🐔", "🦆", "🐴", "🦁", "🐮"], cardColor: Color.pink)
    ]
    
    struct gameTheme{
        var id = UUID()
        var themeName: String
        var themeEmojis: [String]
        var cardColor: Color
    }
    
    //we put string in <> to tell the model that the generic type is string
    //@published will call objectswillchange whenever it is changed
    @Published private(set) var game: Model<String>
    
    
    init(){
        currTheme = viewModel.emojiThemeList.randomElement()!
        game = viewModel.createMemoryGame(theme: currTheme)
    }
    
    static func createMemoryGame(theme: gameTheme) -> (Model<String>){
        //this returns the cardGenerator function
        return Model<String>(noOfPairsOfCards: Int.random(in: 4..<theme.themeEmojis.count)){ pairIndex in theme.themeEmojis[pairIndex]}
    }
    
    // MARK: - Access to the model for views
    //view model's job to present the model to the views in a simple manner.
    var cardsArr: Array<Model<String>.Card>{
        return game.cardsArray
    }
    
    var currentScore: Int{
        get{
            return game.currentScore
        }
    }
    
    
    // MARK: - Intent(s)
    func chooseCard(card: Model<String>.Card){
        game.choose(card: card)
    }
    
    func newGame(){
        currTheme = viewModel.emojiThemeList.randomElement()!
        self.game = viewModel.createMemoryGame(theme: currTheme)
    }
}
