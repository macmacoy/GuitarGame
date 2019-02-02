//
//  SongLibrary.swift
//  GuitarGame
//
//  Created by Mac Macoy on 11/21/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation

class SongLibrary {
    
    private init() {}
    
    static func getSong(name: String, artist: String) -> Song? {
        var song = getSongLocally(name: name, artist: artist)
        if song != nil {
            return song
        }
        else {
            downloadNewSong(song: name, artist: artist)
            song = getSongLocally(name: name, artist: artist)
            if song != nil {
                return song
            }
            else {
                print("error getting song locally and via API")
                return nil
            }
        }
    }
    
    static func downloadNewSong(song: String, artist: String) -> Bool {
        let downloaded = false
        
        // call api to get song
        let response = callSongApi(name: song, artist: artist)
        if response != nil {
            Utils.writeDictionaryToJson(dict: response!, forResource: "songs/" + nameAndArtistToKey(name: song, artist: artist), withExtension: "json")
        }
        else {
            print("error calling song API")
        }
        
        return downloaded
    }
    
    static func keyToNameAndArtist(key: String) -> (song: String, artist: String) {
        let split = key.components(separatedBy: "%")
        let nameSplit = split[0].components(separatedBy: "_")
        var name = ""
        for i in 0..<nameSplit.count {
            name += String.capitalizeFirstLetter(s: nameSplit[i])
            if i != nameSplit.count - 1 {
                name += " "
            }
        }
        let artistSplit = split[1].components(separatedBy: "_")
        var artist = ""
        for i in 0..<artistSplit.count {
            artist += String.capitalizeFirstLetter(s: artistSplit[i])
            if i != artistSplit.count - 1 {
                artist += " "
            }
        }
        return (song: name, artist: artist)
    }
    
    static func nameAndArtistToKey(name: String, artist: String) -> String {
        let key = name.replacingOccurrences(of: " ", with: "_").lowercased() + "%" + artist.replacingOccurrences(of: " ", with: "_").lowercased()
        return key
    }
    
    static func getSongLocally(name: String, artist: String) -> Song? {
        let resource = nameAndArtistToKey(name: name, artist: artist)
        do {
            let songDict = try Utils.getDictionary(forResource: "songs/"+resource, withExtension: "json")
            if songDict != nil {
                return Song(songDict: songDict!)
            }
            else {
                return nil
            }
        }
        catch {
            return nil
        }
    }
    
    static private func callSongApi(name: String, artist: String) -> [String:Any]? {
        let scheme = "https"
        let host = "qx31b8ilpf.execute-api.us-east-1.amazonaws.com"
        let path = "/beta/song"
        let queryItemName = URLQueryItem(name: "name", value: name)
        let queryItemArtist = URLQueryItem(name: "artist", value: artist)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItemName, queryItemArtist]
        
        let url = urlComponents.url
        
        let results = WebApi.get(url: url!, host: host)
        if results != nil {
            return results
        }
        else {
            return nil
        }
    }
    
}
