//
//  Chord.swift
//  Universal_Tuner
//
//  Created by Denis França Candido on 09/05/17.
//  Copyright © 2017 Denis França Candido. All rights reserved.
//

import Foundation

class Chord: NSObject {
    
    let name:String
    let chordNumber:Int
    static var chordCount:Int = 0
    
    
    init(name:String){
        self.name = name
        self.chordNumber = Chord.chordCount
        Chord.chordCount += 1
    }
}
