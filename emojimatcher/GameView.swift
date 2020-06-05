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


//Views in swift UI are mostly stateless and only reflect what the model actually says. In other words, views are read-only. When we do need statefullness, for example when we take user input to temporarily store data, we use @State. 
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
    //the @viewbuilder lets us interpret the function body as a list of views with if else, and if there is not else, it will return a blank view.
    @ViewBuilder
    func body(for size: CGSize) -> some View{
        if ((card.isFaceUp) || (!card.isMatched)){
            ZStack{
                Pie(startAngle: Angle.degrees(0-90),
                    endAngle: Angle.degrees(110-90),
                    clockwise: true
                )
                    .fill(Color.orange)
                    .padding(5)
                    .opacity(0.4)
                Text(card.content)
                    .cardify(isFaceUp: card.isFaceUp)
            }
            .font(Font.system(size: min(size.width, size.height)*self.fontSizeModifier))
        }
    }
    
    // MARK: - Drawing constants
    let cardRadius: CGFloat = 10.0
    let cardLineWidth: CGFloat = 2.0
    let fontSizeModifier: CGFloat = 0.6
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = viewModel()
        game.chooseCard(card: game.cardsArr[0])
        return GameView(GameViewModel: game)
    }
}
