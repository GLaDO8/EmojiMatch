//
//  ContentView.swift
//  flippyCards
//
//  Created by shreyas gupta on 19/05/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

// This automatically imports Foundation package

// NOTE - SwiftUI is a functional programmming way of doing things
// vars inside a struct or class are properties

import SwiftUI

struct GameView: View {
    @ObservedObject var GameViewModel = viewModel()
    // the body property is a computed property, but special type of computed property, as we do not explicitly put a return
    //when we put some, we tell the compiler decide the type of return
    var body: some View {
        VStack{
            HStack{
                Text("Score: \(self.GameViewModel.currentScore)")
                Text(viewModel.themeType)
                    .font(Font.title)
                Button(action: {
                    self.GameViewModel.newGame()
                }){
                    Text("New Game")
                }
            }
            Grid(GameViewModel.cardsArr){card in
                CardView(card: card).onTapGesture {
                    self.GameViewModel.chooseCard(card: card)
                }
                .padding(15)
            }
            
        }
    }
}


//cardview represents a card, and what card to represent will be told by the viewmodel
struct CardView: View{
    var card: Model<String>.Card
    var body: some View{
        //the geometry reader is going to capture the size of the content and store it inside geometry, which we will use to dynamically adjust the font of the emoji inside the card
        //we still need to call self before the body because geometryreader is a closure
        GeometryReader{ geometry in
            self.body(for: geometry.size)
        }
    }
    
    //the body is embedded inside a function, because a function can access struct properties but not a closure like geometryreader and foreach. So that we don't have to put self before every function and property call
    func body(for size: CGSize) -> some View{
        ZStack{
            if self.card.isFaceUp{
                // even text is a type of view
                // stroke is a function
                RoundedRectangle(cornerRadius: cardRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cardRadius)
                    .stroke(lineWidth: cardLineWidth)
                    .foregroundColor(.orange)
                Text(card.content)
            }else{
                if !self.card.isMatched{
                    RoundedRectangle(cornerRadius: cardRadius)
                        .fill(Color.orange)
                }
                
            }
        }
        .font(Font.system(size: min(size.width, size.height)*self.fontSizeModifier))
    }
    
    // MARK: - Drawing constants
    let cardRadius: CGFloat = 10.0
    let cardLineWidth: CGFloat = 2.0
    let fontSizeModifier: CGFloat = 0.75
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(GameViewModel: viewModel())
    }
}
