//
//  PlayerStatsViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 12/21/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class PlayerStatsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var playerNameLabel: UILabel!
    
    private var masteredSongs = [(song: String, artist: String, score: Int)]()
    private var gettingBetterSongs = [(song: String, artist: String, score: Int)]()
    private var learningSongs = [(song: String, artist: String, score: Int)]()
    
    @IBOutlet weak var playedSongsTypesTable: UITableView!
    @IBOutlet weak var playerEmoji: EmojiTextField!
    
    private let colors = Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPlayerStats()
        playedSongsTypesTable.isScrollEnabled = false
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        setBackground()
        
        playerNameLabel.text = Player.getPlayer().name
        
        playerEmoji.addTarget(self, action: "textFieldDidChange:", for: UIControl.Event.editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func loadPlayerStats() {
        let player = Player.getPlayer()
        for song in player.playedSongs {
            if song.score >= Scoring.mastered {
                masteredSongs.append((song: song.title, artist: song.artist, score: Int(song.score)))
            }
            else if song.score >= Scoring.gettingBetter {
                gettingBetterSongs.append((song: song.title, artist: song.artist, score: Int(song.score)))
            }
            else {
                learningSongs.append((song: song.title, artist: song.artist, score: Int(song.score)))
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PlayedSongsViewController
        {
            let playedSongsViewController = segue.destination as! PlayedSongsViewController
            if (sender as! PlayedSongsTypeTableViewCell).songMasteryType == SongMasteryType.Mastered {
                playedSongsViewController.guitarEmojis = "🎸🎸🎸\nMastered"
                playedSongsViewController.playedSongs = masteredSongs
            }
            else if (sender as! PlayedSongsTypeTableViewCell).songMasteryType == SongMasteryType.GettingBetter {
                playedSongsViewController.guitarEmojis = "🎸🎸\nGetting Better"
                playedSongsViewController.playedSongs = gettingBetterSongs
            }
            else if (sender as! PlayedSongsTypeTableViewCell).songMasteryType == SongMasteryType.Learning {
                playedSongsViewController.guitarEmojis = "🎸\nLearning"
                playedSongsViewController.playedSongs = learningSongs
            }
        }
    }
    
    // UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playedSongsTypesTable.dequeueReusableCell(withIdentifier: "PlayedSongsTypeTableViewCell")! as! PlayedSongsTypeTableViewCell
        if indexPath.item == 0 {
            // set song mastery type
            cell.songMasteryType = SongMasteryType.Mastered
            
            // set text
            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor : colors.green,
                .foregroundColor : UIColor.white,
                .strokeWidth : -4.0,
            ]
            cell.songCountLabel.attributedText = NSAttributedString(string: String(masteredSongs.count), attributes: strokeTextAttributes)
//            cell.songCountLabel.text = String(masteredSongs.count)
//            cell.songCountLabel.textColor = colors.green
            return cell
        }
        else if indexPath.item == 1 {
            cell.songMasteryType = SongMasteryType.GettingBetter
            cell.titleLabel.text = "🎸🎸"
            
            // set text
            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor : colors.blue,
                .foregroundColor : UIColor.white,
                .strokeWidth : -4.0,
                ]
            cell.songCountLabel.attributedText = NSAttributedString(string: String(gettingBetterSongs.count), attributes: strokeTextAttributes)
//            cell.songCountLabel.text = String(gettingBetterSongs.count)
//            cell.songCountLabel.textColor = colors.blue
            return cell
        }
        else if indexPath.item == 2 {
            cell.songMasteryType = SongMasteryType.Learning
            cell.titleLabel.text = "🎸"
            
            // set text
            let strokeTextAttributes: [NSAttributedString.Key : Any] = [
                .strokeColor : colors.orange,
                .foregroundColor : UIColor.white,
                .strokeWidth : -4.0,
                ]
            cell.songCountLabel.attributedText = NSAttributedString(string: String(learningSongs.count), attributes: strokeTextAttributes)
//            cell.songCountLabel.text = String(learningSongs.count)
//            cell.songCountLabel.textColor = colors.orange
            return cell
        }
        print("error in PlayerStatsViewController")
        return UITableViewCell()
    }
    
    // UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.7529411765, blue: 0.7176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // UITextFieldDelegate functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        print("here")
        if textField.text!.count > 0 {
            textField.resignFirstResponder()
        }
    }
    
}
