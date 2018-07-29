//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Andrea Visini on 29/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import Foundation

struct PlayingCardDeck: CustomStringConvertible {
    
    var description: String {
        return "Deck with \(cards.count) cards: " + String(describing: cards)
    }
    
    
    private(set) var cards = [PlayingCard]()
    
    init() {
        for seme in PlayingCard.Seme.all {
            for val in PlayingCard.Valore.all {
                cards.append(PlayingCard(seme: seme, valore: val))
            }
        }
    }
      
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.randomInt)
        } else {
            return nil
        }
    }
    
}


extension Int {
    var randomInt: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
