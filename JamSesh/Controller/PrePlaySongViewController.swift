//
//  PrePlaySongViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/29/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class PrePlaySongViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var song: Song? = nil
    private var distinctChords = [String]()
    private let preSongChordViewFactory = PreSongChordViewFactory()
    private let menuViewConstants = MenuViewConstants()
    
    @IBOutlet weak var chordCollection: UICollectionView!
    @IBOutlet weak var capoStepper: UIStepper!
    @IBOutlet weak var capoUILabel: UILabel!
    @IBOutlet weak var transposeStepper: UIStepper!
    @IBOutlet weak var transposeLabel: UILabel!
    
    
    @IBAction func capoValueChanged(_ sender: UIStepper) {
        if sender == capoStepper {
            song!.setCapo(capo: Int(sender.value))
            capoUILabel.text = Int(sender.value).description
            setDistinctChords(song: song!)
            chordCollection.reloadData()
        }
        if sender == transposeStepper {
            song!.transpose(transpose: Int(sender.value))
            transposeLabel.text = Int(sender.value).description
            setDistinctChords(song: song!)
            chordCollection.reloadData()
        }
        // make sure the navigation bar is hidden
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = EvenUICollectionViewFlowLayout()
        layout.itemSize = menuViewConstants.prePlayChordUICollectionViewCellSize(uiCollectionViewSize: chordCollection.bounds)
        chordCollection.collectionViewLayout = layout
        capoStepper.maximumValue = 12
        
        let layer = chordCollection.layer
        
        layer.cornerRadius = 4.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        
        self.navigationController?.isNavigationBarHidden = false
        
        // set background
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        setBackground()
        
        // next button
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(next(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is PlaySongViewController
        {
            let playSongViewController = segue.destination as! PlaySongViewController
            playSongViewController.setModel(song: self.song!, gameplaySongPlayer: GameplaySongPlayer(song: self.song!))
        }
    }
    
    func setSong(song: Song) {
        self.song = song
        setDistinctChords(song: song)
    }
    
    private func setDistinctChords(song: Song) {
        distinctChords.removeAll()
        for chord in song.chords {
            if chord.chord != nil {
                if !distinctChords.contains(chord.chord!.name) {
                    distinctChords.append(chord.chord!.name)
                }
            }
        }
    }
    
    // UICollectionViewDataSource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return distinctChords.count
    }
    
    private var fingerChartRect = CGRect()
    private var fingerChartRectSet = false
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chordCollection.dequeueReusableCell(withReuseIdentifier: "Chord", for: indexPath) as! ChordChartView
        cell.chordText.text = distinctChords[indexPath.item]
        if !fingerChartRectSet {
            fingerChartRect = cell.frame.insetBy(dx: cell.frame.width/8, dy: cell.frame.height/8)
            fingerChartRectSet = true
        }
        var fingerChart: UIImage!
        do {
            fingerChart = ChordCartUIImageFactory.make(chord: distinctChords[indexPath.item])
        }
        catch {
            fingerChart = UIImage(named: "art.scnassets/FingerChart.png")
        }
        cell.chart.frame(forAlignmentRect: fingerChartRect)
        cell.chart.image = fingerChart
        return cell
    }
    
    private func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1).cgColor, #colorLiteral(red: 0.3529411765, green: 0.7529411765, blue: 0.7176470588, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc private func next(_ sender: UIButton?) {
        // go to next
        let playSongViewController = Utils.getViewController(viewControllerName: "PlaySongViewController") as! PlaySongViewController
        playSongViewController.setModel(song: self.song!, gameplaySongPlayer: GameplaySongPlayer(song: self.song!))
        Utils.setCurrentViewController(from: self, to: playSongViewController)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellSize = menuViewConstants.prePlayChordUICollectionViewCellSize(uiCollectionViewSize: chordCollection.collectionViewLayout.collectionViewContentSize)
//        return cellSize
//    }
}
