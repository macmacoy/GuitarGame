//
//  GameViewController.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/4/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import UIKit
import SceneKit

class PlaySongViewController: UIViewController, SCNSceneRendererDelegate {
    
    // model
    private(set) var song: Song? = nil
    private var gameplaySongPlayer: GameplaySongPlayer? = nil
    
    // view
    private var playSongView: PlaySongView!
    private var viewUpdaterThreadQueue = DispatchQueue(label: "view-updater")
    private let viewConstants = ViewConstants()
    
    override func viewDidLoad() {
        
        // make PlaySongView
        initPlaySongView()
        
        // make sure the navigation bar is hidden
        self.navigationController?.isNavigationBarHidden = true
        
        // start the song
        startSong()
        
        // set self as scnview delegate
        playSongView.setSCNViewDelegate(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // SCNSceneRendererDelegate method
    func renderer(_ aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        // per-frame code here
        if !self.gameplaySongPlayer!.isDone() {
            self.playSongView.updateView()
        }
        else {
            DispatchQueue.main.async {
                self.songIsDone()
            }
        }
    }
    
    func setModel(song: Song, gameplaySongPlayer: GameplaySongPlayer) {
        self.song = song
        self.gameplaySongPlayer = gameplaySongPlayer
    }
    
    func initPlaySongView() {
        playSongView = PlaySongView(scnView: self.view as! SCNView, gameplaySongPlayer: self.gameplaySongPlayer!, viewController: self)
    }
    
    func startSong() {
        viewUpdaterThreadQueue.async {
            sleep(1)
            DispatchQueue.main.async {
                self.playSongView.startScene()
            }
            self.gameplaySongPlayer!.play()
        }
    }
    
    private func songIsDone() {
        let postSongViewController = Utils.getViewController(viewControllerName: "PostSongViewController") as! PostSongViewController
        postSongViewController.setGameplaySongPlayer(gameplaySongPlayer: gameplaySongPlayer!)
        Utils.setCurrentViewController(from: self, to: postSongViewController)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameplaySongPlayer!.started {
            if !gameplaySongPlayer!.paused {
                playSongView.pause()
                gameplaySongPlayer?.pause()
            }
            else {
                playSongView.unpause()
                gameplaySongPlayer?.play()
            }
        }
    }
    
    func pause() {
        playSongView.pause()
        gameplaySongPlayer?.pause()
    }
    
    func pauseButDontBlur() {
        playSongView.pauseButDontBlur()
        gameplaySongPlayer?.pause()
    }
    
}
