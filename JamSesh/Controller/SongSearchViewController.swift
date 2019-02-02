//
//  SongSearchViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/26/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class SongSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsTable: UITableView!
    
    private(set) var songResults: [(song: String, artist: String)]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup delegates */
        resultsTable.delegate = self
        resultsTable.dataSource = self
        searchBar.delegate = self
        
        // results
        resultsTable.rowHeight = ViewConstants.tableViewCellHeight
        
        // hide navigation bar
        self.navigationController?.isNavigationBarHidden = true
        
        // set tableview background
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        setTableViewBackground()
        
        // set background color
        self.view.backgroundColor = #colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1)
        
        // set results to all songs at first
        songResults = SongSearch.allSongs
        
        // set local songs in search
//        setLocalSongs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // UITableViewDelegate methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if songResults == nil {
            return 0
        }
        else {
            return songResults!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultsTable.dequeueReusableCell(withIdentifier: "SongTableViewCell")! as! SongTableViewCell
        if songResults == nil {
            print("no results")
        }
        else {
            cell.songTitle.text = songResults![indexPath.row].song
            cell.songArtist.text = songResults![indexPath.row].artist
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PrePlaySongViewController
        {
            let prePlaySongViewController = segue.destination as! PrePlaySongViewController
            let songCell = sender as! SongTableViewCell
            let songTitleLabel = songCell.songTitle!
            let songArtistLabel = songCell.songArtist!
            let song = SongLibrary.getSong(name: songTitleLabel.text!, artist: songArtistLabel.text!)
            if song != nil {
                prePlaySongViewController.setSong(song: song!)
            }
            else {
                print("Song file cannot be found")
            }
            // error screen?
        }
    }
    
    // UISearchBarDelegate methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.songResults = SongSearch.search(text: searchText)
        // update the results in the search results
        
        self.resultsTable.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // hides the keyboard
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    private func setTableViewBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.7529411765, blue: 0.7176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = resultsTable.bounds
        let backgroundView = UIView(frame: resultsTable.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        resultsTable.backgroundView = backgroundView
    }
    
//    private func setLocalSongs() {
//        let fileManager = FileManager.default
//        let songsDirURL = FileSystemConstants.songsDirectoryURL
//        do {
//            let fileURLs = try fileManager.contentsOfDirectory(at: songsDirURL, includingPropertiesForKeys: nil)
//            for fileURL in fileURLs {
//                let songDict = Utils.getDictionary(forResource: fileURL)!
//                let songTitle = songDict["title"] as! String
//                let artist = songDict["artist"] as! String
//                SongSearch.localSongs.append((song: songTitle, artist: artist))
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
}
