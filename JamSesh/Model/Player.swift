//
//  Player.swift
//  GuitarGame
//
//  Created by Mac Macoy on 11/21/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation

class Player {
    
    // basic desciptors
    var name: String!
    
    // game related
    var playedSongs = [(title: String, artist: String, score: Double)]()
    
    private static var singleton: Player? = nil
    
    static func getPlayer() -> Player {
        if singleton == nil {
            singleton = Player()
        }
        return singleton!
    }
    
    private init() {
        do {
            let playerDict = try Utils.getDictionary(forResource: "player", withExtension: "json")!
            self.name = playerDict["name"] as? String
            let playedSongsData = playerDict["playedSongs"] as! Array<Dictionary<String, Any>>
            for playedSongData in playedSongsData {
                let title = (playedSongData["song"] as! Dictionary<String, String>)["name"]!
                let artist = (playedSongData["song"] as! Dictionary<String, String>)["artist"]!
                let score = playedSongData["score"] as? Double
                self.playedSongs.append((title: title, artist: artist, score: score!))
            }
        }
        catch {
            print("error reading the player file")
        }
    }
    
    func playedSong(name: String, artist: String, score: Double) {
        // add to played songs and save to player json file
        
        // get player json
        do {
            var playerDict = try Utils.getDictionary(forResource: "player", withExtension: "json")!
            var playedSongsData = playerDict["playedSongs"] as! Array<Dictionary<String, Any>>
            
            // check if player has played the song
            var playedBefore = false
            for i in 0..<playedSongs.count {
                if playedSongs[i].title == name && playedSongs[i].artist == artist {
                    if score > playedSongs[i].score {
                        // replace score if played before
                        playedSongs[i] = (title: name, artist: artist, score: score)
                        // write to player json array
                        for i in 0..<playedSongsData.count {
                            if (playedSongsData[i]["song"] as! Dictionary<String, String>)["name"]! == name &&
                                (playedSongsData[i]["song"] as! Dictionary<String, String>)["artist"]! == artist {
                                let songDict = [
                                    "song": [
                                        "name": name,
                                        "artist": artist
                                    ],
                                    "score": score
                                ] as [String : Any]
                                playedSongsData[i] = songDict
                            }
                        }
                    }
                    playedBefore = true
                }
            }
            // append to list if haven't played before
            if !playedBefore {
                playedSongs.append((title: name, artist: artist, score: score))
                // append to player json arry
                let songDict = [
                    "song": [
                        "name": name,
                        "artist": artist
                    ],
                    "score": score
                ] as [String : Any]
                playedSongsData.append(songDict)
            }
            
            // write to the player json file
            playerDict["playedSongs"] = playedSongsData
            Utils.writeDictionaryToJson(dict: playerDict, forResource: "player", withExtension: "json")
        }
        catch {
            print("error loading player file")
        }
    }
    
    static func createPlayer(firstName: String, email: String) {
        // create player file locally
        let playerDict = ["name": firstName, "playedSongs": []] as [String : Any]
        Utils.writeDictionaryToJson(dict: playerDict, forResource: "player", withExtension: "json")
        
        // send player info to cloud
    }
    
    static var registered: Bool {
        get {
            do {
                let fileManager = FileManager.default
                let playerFileURL = FileSystemConstants.dataDirectoryURL.appendingPathComponent("player.json")
                return fileManager.fileExists(atPath: playerFileURL.path)
            }
            catch {
                return false
            }
        }
    }
}
