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
    @ObservedObject var GameViewModel:viewModel
    // the body property is a computed property, but special type of computed property, as we do not explicitly put a return
    //when we put some, we tell the compiler decide the type of return
    var body: some View {
        VStack{
            HStack{
                Text("Score: \(self.GameViewModel.currentScore)")
                Text(GameViewModel.currTheme.themeName)
                    .font(Font.title)
                Button(action: {
                    withAnimation(.easeInOut){
                        self.GameViewModel.newGame()
                    }
                }){
                    Text("New Game")
                }
            }
            Grid(GameViewModel.cardsArr){card in
                CardView(card: card, cardColor: self.GameViewModel.currTheme.cardColor).onTapGesture{
                    withAnimation(.linear){ // animates all cards when you choose with default opacity
                        self.GameViewModel.chooseCard(card: card)
                    }
                }
                .padding(15)
            }
        }
    }
}


//cardview represents a card, and what card to represent will be told by the viewmodel
struct CardView: View{
    var card: Model<String>.Card
    var cardColor: Color
    var body: some View{
        //the geometry reader is going to capture the size of the content and store it inside geometry, which we will use to dynamically adjust the font of the emoji inside the card
        //we still need to call self before the body because geometryreader is a closure
        GeometryReader{ geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemainingPercentage: Double = 0
    func startBonusTimeAnimation(){
        animatedBonusRemainingPercentage = card.bonusRemainingPercentage
        withAnimation(.linear(duration: card.bonusTimeRemaining)){
            animatedBonusRemainingPercentage = 0
        }
    }
    
    //the body is embedded inside a function, because a function can access struct properties but not a closure like geometryreader and foreach. So that we don't have to put self before every function and property call
    //the @viewbuilder lets us interpret the function body as a list of views with if else, and if there is not else, it will return a blank view.
    @ViewBuilder
    func body(for size: CGSize) -> some View{
        //note that the matched cards will update next time when the app refreshes
        if ((card.isFaceUp) || (!card.isMatched)){
            ZStack{
                Group{
                    if card.isCanConsumingBonusTime{
                        Pie(startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-360*animatedBonusRemainingPercentage-90),
                            clockwise: true
                        ).onAppear{
                            self.startBonusTimeAnimation()
                        }
                    }else{
                        Pie(startAngle: Angle.degrees(0-90),
                            endAngle: Angle.degrees(-360*card.bonusRemainingPercentage-90),
                            clockwise: true
                        )
                    }
                }
                .foregroundColor(cardColor)
                .padding(5)
                .opacity(0.4)
                Text(card.content)
                    .font(Font.system(size: min(size.width, size.height)*self.fontSizeModifier))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0)) //viewModifier
                    .animation(card.isMatched ? Animation.linear(duration: 0.4).repeatForever(autoreverses: false) : .default) //explicit animation
            }
            .cardify(isFaceUp: card.isFaceUp, cardColor: cardColor)
            .transition(.scale)
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
        //        game.chooseCard(card: game.cardsArr[0])
        return GameView(GameViewModel: game)
    }
}
