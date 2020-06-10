//
//  Cardify.swift
//  emojimatcher
//
//  Created by shreyas gupta on 05/06/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct Cardify: AnimatableModifier{
    var rotation: Double
    var cardColor: Color
    //essentially links rotation and faceup
    var isFaceUp: Bool{
        rotation < 90
    }
    private let cardRadius: CGFloat = 10.0
    private let cardLineWidth: CGFloat = 2.0
    
    //this tells swift what variable to animate
    var animatableData:Double{
        get{ return rotation }
        set{ rotation = newValue }
    }
    
    init(isFaceUp: Bool, cardColor: Color){
        rotation = isFaceUp ? 0 : 180
        self.cardColor = cardColor
    }
    //the content is the view content which will be modified
    func body(content: Content) -> some View {
        ZStack{
            Group{
                RoundedRectangle(cornerRadius: cardRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cardRadius)
                    .stroke(lineWidth: cardLineWidth)
                    .foregroundColor(.orange)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
                RoundedRectangle(cornerRadius: cardRadius)
                    .fill(cardColor)
                    .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0,1,0))
    }
}

//this extension lets us use the view modifier without calling .modifier explicitely everytime
extension View{
    func cardify(isFaceUp: Bool, cardColor: Color) -> some View{
        self.modifier(Cardify(isFaceUp: isFaceUp, cardColor: cardColor))
    }
}

//
//LinearGradient(
//    gradient: Gradient(colors: [Color(red: 255/255, green: 140/255, blue: 0/255), Color(red: 255/255, green: 204/255, blue: 84/255)]),
//    startPoint: .top,
//    endPoint: .bottom)
