//
//  FileSystemConstants.swift
//  JamSesh
//
//  Created by Mac Macoy on 1/5/19.
//  Copyright © 2019 Mac Macoy. All rights reserved.
//

import Foundation

class FileSystemConstants {
    
//    static let bundleIdentifier = Bundle.main.bundleIdentifier!
    
    static var dataDirectoryURL: URL {
        get {
            return FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        }
    }
    
    static var songsDirectoryURL: URL {
        get {
            return dataDirectoryURL.appendingPathComponent("songs")
        }
    }
    
}
