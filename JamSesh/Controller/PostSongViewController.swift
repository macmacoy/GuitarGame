//
//  PostSongViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 12/15/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import UIKit

class PostSongViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var gameplaySongPlayer: GameplaySongPlayer? = nil
    private var distinctChords = [String]()
    private var scores = [Int]()
    
    private let labelFactory = LyricUILabelFactory()
    
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var chordScoresCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set background
        setBackground()
        
        // set the total score label
        totalScoreLabel.text = String(Int(gameplaySongPlayer!.scoring.finalScore))
        
        saveScoreToPlayer()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setGameplaySongPlayer(gameplaySongPlayer: GameplaySongPlayer) {
        self.gameplaySongPlayer = gameplaySongPlayer
        setDistinctChords(song: gameplaySongPlayer.song)
    }
    
    // UICollectionViewDataSource functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return distinctChords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chordScoresCollection.dequeueReusableCell(withReuseIdentifier: "ChordScoreBox", for: indexPath) as! ChordScoreUICollectionViewCell
        let chordScore = gameplaySongPlayer!.scoring.getChordScore(chord: distinctChords[indexPath.item])
        cell.chordScoreLabel.text = distinctChords[indexPath.item]
        cell.chordTextLabel.text = String(Int(chordScore))
        return cell
    }
    
    private func setDistinctChords(song: Song) {
        for chord in song.chords {
            if chord.chord != nil {
                if !distinctChords.contains(chord.chord!.name) {
                    distinctChords.append(chord.chord!.name)
                }
            }
        }
    }
    
    private func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.7529411765, blue: 0.7176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func saveScoreToPlayer() {
        var player = Player.getPlayer()
        player.playedSong(name: gameplaySongPlayer!.song.title, artist: gameplaySongPlayer!.song.artist, score: gameplaySongPlayer!.scoring.finalScore)
    }
}
