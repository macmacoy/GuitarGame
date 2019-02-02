//
//  PlayedSongsViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 12/21/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class PlayedSongsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var playedSongs = [(song: String, artist: String, score: Int)]()
    var guitarEmojis = String()
    var scoreTypeText = String()
    
    @IBOutlet weak var playedSongsTableView: UITableView!
    @IBOutlet weak var guitarEmojisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guitarEmojisLabel.numberOfLines = 0
        guitarEmojisLabel.text = guitarEmojis
        
        playedSongsTableView.rowHeight = ViewConstants.tableViewCellHeight
        
        self.navigationController?.isNavigationBarHidden = false
        
        view.backgroundColor = UIColor.gray
        
        // set tableview background
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        setTableViewBackground()
        
        // set background color
        self.view.backgroundColor = #colorLiteral(red: 0.1450980392, green: 0.3490196078, blue: 0.4588235294, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playedSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playedSongsTableView.dequeueReusableCell(withIdentifier: "PlayedSongTableViewCell")! as! PlayedSongTableViewCell
        cell.songTitle.text = playedSongs[indexPath.item].song
        cell.songArtist.text = playedSongs[indexPath.item].artist
        cell.bestScore.text = String(playedSongs[indexPath.item].score)
        return cell
    }
    
    // UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PrePlaySongViewController
        {
            let prePlaySongViewController = segue.destination as! PrePlaySongViewController
            let songCell = sender as! PlayedSongTableViewCell
            let song = SongLibrary.getSong(name: songCell.songTitle.text!, artist: songCell.songArtist.text!)
            if song != nil {
                prePlaySongViewController.setSong(song: song!)
            }
            else {
                print("Song file cannot be found")
            }
            // error screen?
        }
    }
    
    private func setTableViewBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.7529411765, blue: 0.7176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = playedSongsTableView.bounds
        let backgroundView = UIView(frame: playedSongsTableView.bounds)
        backgroundView.layer.insertSublayer(gradientLayer, at: 0)
        playedSongsTableView.backgroundView = backgroundView
    }
    
}
