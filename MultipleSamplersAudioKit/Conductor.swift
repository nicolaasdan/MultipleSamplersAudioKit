//
//  Conductor.swift
//  urbanPan
//
//  Created by Nicolaas Danneels on 01/08/2020.
//  Copyright © 2020 Play it on Pan. All rights reserved.
//

import AudioKit
import AVFoundation
import UIKit

class Conductor {
    
    // Properties
    static let shared = Conductor()
    var sampler1: Sampler
    var sampler2: Sampler
    var audioEngine: AudioEngine
    var mixer : Mixer
    var audioFile = nil as AVAudioFile?
    
    // Constructor
    init(){
        audioEngine = AudioEngine()
                
        Settings.bufferLength = .medium
        Settings.enableLogging = true

        // Setting up 2 samplers
        sampler1 = Sampler(sfzPath: Bundle.main.path(forResource: "MultipleSamplers.sfz", ofType: "")!, sfzFileName: "")
        sampler2 = Sampler(sfzPath: Bundle.main.path(forResource: "MultipleSamplers.sfz", ofType: "")!, sfzFileName: "")
        
        // Adding vibrato to both samplers
        sampler1.vibratoDepth = 2
        sampler2.vibratoDepth = 2
        
        mixer = Mixer(sampler1, sampler2)
                
        audioEngine.output = mixer
        
        do {
            try audioEngine.start()
        } catch {
            Log("AudioKit did not start")
        }
        
        // Letting both samplers play the same note subsequently
        playNote(note: MIDINoteNumber(60))
        
        print(sampler1.vibratoDepth)
        print(sampler2.vibratoDepth)
    }
    
    func playNote(note: MIDINoteNumber){
        sampler1.play(noteNumber: note, velocity: MIDIVelocity(127))
        do {
            sleep(3)
        }
        sampler1.stop(noteNumber: note)
        sampler2.play(noteNumber: note, velocity: MIDIVelocity(127))
        do {
            sleep(3)
        }
        sampler2.stop(noteNumber: note)
    }
        
}
