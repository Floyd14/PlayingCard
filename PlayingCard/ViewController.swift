//
//  ViewController.swift
//  PlayingCard
//
//  Created by Andrea Visini on 28/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck = PlayingCardDeck()
    
    @IBOutlet weak var playingCard: PlayingCardView! {
        didSet{
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(doSwipe))
            swipe.direction = [.left,.right]
            playingCard.addGestureRecognizer(swipe)
            
            let pinch = UIPinchGestureRecognizer(target: playingCard, action: #selector(playingCard.zoomCard(byHandlerGestureRecognizer:)))
            playingCard.addGestureRecognizer(pinch)
        }
    }

    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            playingCard.isFacedUp = !playingCard.isFacedUp
        default:
            break
        }
    }
    
    
    @objc func doSwipe() {
        if let card = deck.draw() {
            playingCard.seme = card.seme.rawValue
            playingCard.valore = card.valore.order
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(deck)
        
    }
}

