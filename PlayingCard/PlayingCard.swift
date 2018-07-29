//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Andrea Visini on 28/07/18.
//  Copyright © 2018 Andrea Visini. All rights reserved.
//

import Foundation

struct PlayingCard: CustomStringConvertible {
    
    var description: String {
        return valore.description + seme.description
    }
    
    var seme: Seme
    var valore: Valore
    
    enum Seme: String {
        case Picche = "♠️" //raw value
        case Fiori = "♣️"
        case Quadri = "♦️"
        case Cuori = "♥️"
        
        static var all = [Seme.Picche,.Fiori,.Quadri,.Cuori]
        
        var description: String {
            return self.rawValue
        }
        
        //        func all() -> [seme] {
        //            return [seme.Picche,.Fiori,.Quadri,.Cuori]
        //        }
    }
    
    enum Valore {
        case asso
        case numeric(Int) //associated value
        case figure(String)
        
        var order:Int {
            switch self {
            case .asso: return 1
            case .numeric(let valoreNumerico): return valoreNumerico    //call and set assiciated value
            case .figure(let tipo) where tipo == "J": return 11         //pattern
            case .figure(let tipo) where tipo == "Q": return 12         //pattern
            case .figure(let tipo) where tipo == "K": return 13         //pattern
            default: return 0
                //            case .figure(let tipo): // potevo usare where
                //                if tipo == "J" {
                //                    return 11
                //                } else if tipo == "Q" {
                //                    return 12
                //                } else if tipo == "K" {
                //                    return 13
                //                } else {
                //                    return 0
                //                }
            }
        }
        
        static var all:[Valore] {
            var allValori = [Valore.asso]
            for n in 2...10 {
                allValori.append(Valore.numeric(n))
            }
            allValori += [Valore.figure("J"), .figure("Q"), .figure("K")]
            return allValori
        }
        
        var description: String {
            return String(self.order)
        }
        
    }
    
}
