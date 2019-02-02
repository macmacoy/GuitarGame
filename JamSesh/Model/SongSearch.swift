//
//  SongSearch.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/26/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class SongSearch {
    
    static var allSongs = [(song: String, artist: String)]()
    static var allSongsLastCalled: Date? = nil
    
    private init() {}
    
    static func search(text: String) -> [(song: String, artist: String)]? {
        
        // for beta
        if text == "" {
            return allSongs
        }
        
        // search for songs in aws
        var results = [(song: String, artist: String)]()
        
        // search with search api
        // results = searchSearchAPI(text: String)
        
        // search with all songs api
        results = searchAllSongsAPI(text: text)!
        
        return results
    }
    
    static func searchAllSongsAPI(text: String) -> [(song: String, artist: String)]? {
        // results
        var results = [(song: String, artist: String)]()
        
        // if all songs haven't been gotten today, get them
        if allSongsLastCalled == nil || !Calendar.current.isDateInToday(allSongsLastCalled!) {
            // call all songs api
            let apiResults = callAllSongsAPI()
            
            // fill all songs
            allSongs = []
            for result in apiResults {
                allSongs.append(SongLibrary.keyToNameAndArtist(key: result))
            }
            
            // set last called
            allSongsLastCalled = Date()
        }
        
        for song in allSongs {
            if song.song.lowercased().contains(text.lowercased()) || song.artist.lowercased().contains(text.lowercased()) {
                results.append(song)
            }
        }
        
        return results
    }
    
    static private func searchSearchAPI(text: String) -> [(song: String, artist: String)]? {
        // results
        var results = [(song: String, artist: String)]()
        
        // call search api
        let apiResults = callSearchAPI(text: text)
        
        // fill results
        for result in apiResults {
            results.append(SongLibrary.keyToNameAndArtist(key: result))
        }
        
        return results
    }
    
    static private func callSearchAPI(text: String) -> [String] {
        let scheme = "https"
        let host = "qx31b8ilpf.execute-api.us-east-1.amazonaws.com"
        let path = "/beta/search"
        let queryItem = URLQueryItem(name: "query", value: text)
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = [queryItem]
        
        let url = urlComponents.url
        
        let results = WebApi.get(url: url!, host: host)
        if results != nil {
            return results?["results"] as! [String]
        }
        else {
            return []
        }
    }
    
    static private func callAllSongsAPI() -> [String] {
        let scheme = "https"
        let host = "qx31b8ilpf.execute-api.us-east-1.amazonaws.com"
        let path = "/beta/all-songs"
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        let url = urlComponents.url
        
        let results = WebApi.get(url: url!, host: host)
        if results != nil {
            return results?["all_songs"] as! [String]
        }
        else {
            return []
        }
    }
    
}
