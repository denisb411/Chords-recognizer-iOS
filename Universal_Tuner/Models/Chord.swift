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
    var image = [String]()
    var numOfImages:Int
    
    static var chordCount:Int = 0
    static let chords = [
            Chord(name: "C", image: ["C-1.PNG", "C-2.PNG", "C-3.PNG", "C-4.PNG"]),
            Chord(name: "Cm", image: ["Cm-1.PNG"]),
            Chord(name: "C7", image: ["C7-1.PNG", "C7-2.PNG"]),
            Chord(name: "Cm7", image: ["Cm7-1.PNG"]),
            Chord(name: "C#", image: ["C#-1.PNG"]),
            Chord(name: "C#m", image: ["C#m-1.PNG"]),
            Chord(name: "C#7", image: ["C#7-1.PNG"]),
            Chord(name: "C#m7", image: ["C#m7-1.PNG"]),
            Chord(name: "D", image: ["D-1.PNG", "D-2.PNG", "D-3.PNG"]),
            Chord(name: "Dm", image: ["Dm-1.PNG", "Dm-2.PNG"]),
            Chord(name: "D7", image: ["D7-1.PNG", "D7-2.PNG"]),
            Chord(name: "Dm7", image: ["Dm7-1.PNG", "Dm7-2.PNG"]),
            Chord(name: "D#", image: ["D#-1.PNG"]),
            Chord(name: "D#m", image: ["D#m-1.PNG"]),
            Chord(name: "D#7", image: ["D#7-1.PNG"]),
            Chord(name: "D#m7", image: ["D#m7-1.PNG"]),
            Chord(name: "E", image: ["E-1.PNG", "E-2.PNG"]),
            Chord(name: "Em", image: ["Em-1.PNG", "Em-2.PNG"]),
            Chord(name: "E7", image: ["E7-1.PNG", "E7-2.PNG", "E7-3.PNG"]),
            Chord(name: "Em7", image: ["Em7-1.PNG", "Em7-2.PNG", "Em7-3.PNG"]),
            Chord(name: "F", image: ["F-1.PNG", "F-2.PNG"]),
            Chord(name: "Fm", image: ["Fm-1.PNG"]),
            Chord(name: "F7", image: ["F7-1.PNG"]),
            Chord(name: "Fm7", image: ["Fm7-1.PNG"]),
            Chord(name: "F#", image: ["F#-1.PNG"]),
            Chord(name: "F#m", image: ["F#m-1.PNG"]),
            Chord(name: "F#7", image: ["F#7-1.PNG"]),
            Chord(name: "F#m7", image: ["F#m7-1.PNG"]),
            Chord(name: "G", image: ["G-1.PNG", "G-2.PNG", "G-3.PNG", "G-4.PNG"]),
            Chord(name: "Gm", image: ["Gm-1.PNG"]),
            Chord(name: "G7", image: ["G7-1.PNG", "G7-2.PNG"]),
            Chord(name: "Gm7", image: ["Gm7-1.PNG"]),
            Chord(name: "G#", image: ["G#-1.PNG"]),
            Chord(name: "G#m", image: ["G#m-1.PNG"]),
            Chord(name: "G#7", image: ["G#7-1.PNG"]),
            Chord(name: "G#m7", image: ["G#m7-1.PNG"]),
            Chord(name: "A", image: ["A-1.PNG", "A-2.PNG"]),
            Chord(name: "Am", image: ["Am-1.PNG", "Am-2.PNG"]),
            Chord(name: "A7", image: ["A7-1.PNG"]),
            Chord(name: "Am7", image: ["Am7-1.PNG"]),
            Chord(name: "A#", image: ["A#-1.PNG"]),
            Chord(name: "A#m", image: ["A#m-1.PNG"]),
            Chord(name: "A#7", image: ["A#7-1.PNG"]),
            Chord(name: "A#m7", image: ["A#m7-1.PNG"]),
            Chord(name: "B", image: ["B-1.PNG"]),
            Chord(name: "Bm", image: ["Bm-1.PNG"]),
            Chord(name: "B7", image: ["B7-1.PNG", "B7-2.PNG"]),
            Chord(name: "Bm7", image: ["Bm7-1.PNG"]),
    ]
    
    init(name:String, image:[String]){
        self.name = name
        self.chordNumber = Chord.chordCount
        self.image = image
        self.numOfImages = self.image.count
        Chord.chordCount += 1
    }
}
