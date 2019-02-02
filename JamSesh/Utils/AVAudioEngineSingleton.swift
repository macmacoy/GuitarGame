//
//  AVAudioEngineSingleton.swift
//  JamSesh
//
//  Created by Mac Macoy on 1/21/19.
//  Copyright © 2019 Mac Macoy. All rights reserved.
//

import Foundation
import AVKit

class AVAudioEngineSingleton: AVAudioEngine {
    
    private static var engine: AVAudioEngineSingleton? = nil
    
    private override init() {}
    
    public static func get() -> AVAudioEngineSingleton {
        if engine == nil {
            engine = AVAudioEngineSingleton()
        }
        return engine!
    }
    
}
