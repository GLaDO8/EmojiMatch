//
//  Model.swift
//  flippyCards
//
//  Created by shreyas gupta on 21/05/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import Foundation

//the super struct needs to mention the type of generic in <>, so when the Model struct is initialised, we need to tell the type of cardContent
struct Model<cardContent> where cardContent: Equatable{
    private(set) var cardsArray: Array<Card>
    private var cardHistoryArray: [Int: Int]
    private(set) var currentScore: Int = 0
    private var cardChooseStartTime: Date?
    private var cardChooseEndTime: Date?
    private var chooseTime: TimeInterval = 0
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{ cardsArray.indices.filter { cardsArray[$0].isFaceUp }.only }
        set{
            for index in cardsArray.indices{
                cardsArray[index].isFaceUp = (newValue == index) //returns a bool
            }
        }
    }
    
    
    // cardcontentgenerator will give all cards some content, it is a function which will be passed in
    init(noOfPairsOfCards: Int, cardContentGenerator: (Int) -> cardContent){
        cardsArray = Array<Card>()
        cardHistoryArray = [Int: Int]()
        for pairIndex in 0..<noOfPairsOfCards{
            let content = cardContentGenerator(pairIndex)
            cardsArray.append(Card(content: content, id: pairIndex*2))
            cardsArray.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cardsArray.shuffle()
        for i in 0..<noOfPairsOfCards*2{
            cardHistoryArray[i] = 0
        }
    }
        
    mutating func choose(card: Card){
        if let chosenIndex = cardsArray.firstIndex(of: card), !cardsArray[chosenIndex].isFaceUp, !cardsArray[chosenIndex].isMatched{
            cardHistoryArray[chosenIndex]!+=1
            //SECOND CARD
            if let potentialMatchCardIndex = indexOfOneAndOnlyFaceUpCard{
                if (cardHistoryArray[chosenIndex]! > 1){
                    cardChooseEndTime = Date()
                }
                if let startTime = cardChooseStartTime, let endTime = cardChooseEndTime{
                    chooseTime = endTime.timeIntervalSince(startTime)
                }
                if cardsArray[potentialMatchCardIndex].content == cardsArray[chosenIndex].content{
                    cardsArray[potentialMatchCardIndex].isMatched = true
                    cardsArray[chosenIndex].isMatched = true
                    if(chooseTime == 0){
                        currentScore+=10 // if the user get's the card right in the first attempt
                    }else{
                        currentScore+=Int(10/chooseTime)
                    }
                }else{
                    if(cardHistoryArray[chosenIndex]! > 1){
                        currentScore-=Int(5*chooseTime)
                    }
                }
                self.cardsArray[chosenIndex].isFaceUp = true
            }
            //FIRST CARD
            else{
                indexOfOneAndOnlyFaceUpCard = chosenIndex
                if (cardHistoryArray[chosenIndex]! > 1){
                    cardChooseStartTime = Date()
                }
            }
        }
    }
    
    //struct definition inside parent struct, we do this to tell that this card is not just any card, it is this particular game's card
    struct Card: Identifiable{
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        // generic type cardContent
        var content: cardContent
        var id: Int
    }
}
