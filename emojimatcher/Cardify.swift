//
//  Cardify.swift
//  emojimatcher
//
//  Created by shreyas gupta on 05/06/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import SwiftUI

struct Cardify: ViewModifier{
    var isFaceUp: Bool
    private let cardRadius: CGFloat = 10.0
    private let cardLineWidth: CGFloat = 2.0
    
    //the content is the view content which will be modified
    func body(content: Content) -> some View {
        ZStack{
            if(isFaceUp){
                RoundedRectangle(cornerRadius: cardRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cardRadius)
                    .stroke(lineWidth: cardLineWidth)
                    .foregroundColor(.orange)
                content
            }else{
                RoundedRectangle(cornerRadius: cardRadius)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color(red: 255/255, green: 140/255, blue: 0/255), Color(red: 255/255, green: 204/255, blue: 84/255)]),
                        startPoint: .top,
                        endPoint: .bottom))
            }
        }
    }
}

//this extension lets us use the view modifier without calling .modifier explicitely everytime
extension View{
    func cardify(isFaceUp: Bool) -> some View{
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
