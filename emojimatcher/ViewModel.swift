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
    //we put string in <> to tell the model that the generic type is string
    //@published will call objectswillchange whenever it is changed
    static let themeType: String = "Romantic"
    
    static let emojiThemeDict = [
        "Romantic": ["❤️", "💕", "💛", "🥰", "😘", "😍", "😻", "💋"],
        "Horror": ["👻", "💀", "☠️", "👹", "😈", "🧟‍♂️", "🧛🏿", "👺" ],
        "Nature": ["🌪", "☀️", "🌈", "⛈", "🌲", "🌊", "⛰", "🌑"],
        "Classic": ["😂", "😇", "😝", "🤪", "😎", "🥳", "🤓", "🤮"]
    ]
    
    @Published private(set) var game: Model<String> = viewModel.createMemoryGame(emojiDict: emojiThemeDict,  theme: themeType)
    
    
    static func createMemoryGame(emojiDict:Dictionary<String, [String]>, theme: String) -> (Model<String>){
        //this returns the cardGenerator function
        return Model<String>(noOfPairsOfCards: 6){ pairIndex in emojiThemeDict[theme]![pairIndex]}
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
        self.game = viewModel.createMemoryGame(emojiDict: viewModel.emojiThemeDict, theme: viewModel.themeType)
    }
}
