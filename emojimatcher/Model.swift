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
//    private var cardHistoryArray: [Int: Int]
    private(set) var currentScore: Int = 0
//    private var cardChooseStartTime: Date?
//    private var cardChooseEndTime: Date?
//    private var chooseTime: TimeInterval = 0
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
        for pairIndex in 0..<noOfPairsOfCards{
            let content = cardContentGenerator(pairIndex)
            cardsArray.append(Card(content: content, id: pairIndex*2))
            cardsArray.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cardsArray.shuffle()
    }
        
    mutating func choose(card: Card){
        if let chosenIndex = cardsArray.firstIndex(of: card), !cardsArray[chosenIndex].isFaceUp, !cardsArray[chosenIndex].isMatched{
            //SECOND CARD
            if let potentialMatchCardIndex = indexOfOneAndOnlyFaceUpCard{
                if cardsArray[potentialMatchCardIndex].content == cardsArray[chosenIndex].content{
                    cardsArray[potentialMatchCardIndex].isMatched = true
                    cardsArray[chosenIndex].isMatched = true
                    currentScore+=10
                    }else{
                    currentScore-=5
                }
                self.cardsArray[chosenIndex].isFaceUp = true
            }
            //FIRST CARD
            else{
                indexOfOneAndOnlyFaceUpCard = chosenIndex
                print(chosenIndex)
            }
        }
    }
            
    //struct definition inside parent struct, we do this to tell that this card is not just any card, it is this particular game's card
    struct Card: Identifiable{
        var isFaceUp: Bool = false{
            didSet{
                if isFaceUp{
                    startUsingBonusTime()
                }else{
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false{
            didSet{
                if isMatched{
                    stopUsingBonusTime()
                }
            }
        }
        // generic type cardContent
        var content: cardContent
        var id: Int
        
        //MARK: - bonus time functionality
        var bonusTimeLimit: TimeInterval = 6
        
        private var faceUpTime: TimeInterval{
            if let lastFaceUpDate = self.lastFaceUpDate{
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            }else{
                return pastFaceUpTime
            }
        }
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
        var bonusTimeRemaining: TimeInterval{
            max(0, bonusTimeLimit - faceUpTime)
        }
        
        var bonusRemainingPercentage: Double{
            ((bonusTimeLimit > 0) && (bonusTimeRemaining > 0)) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        //true when card gets matched and bonus time is available
        var hasEarnedBonus: Bool{
            isMatched && (bonusTimeRemaining > 0)
        }
        var isCanConsumingBonusTime: Bool{
            isFaceUp && !isMatched && (bonusTimeRemaining > 0)
        }
    
        //called when card is transiting to face up
        private mutating func startUsingBonusTime(){
            if isCanConsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }
        //called when card is transiting to face down or gets matched
        private mutating func stopUsingBonusTime(){
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
