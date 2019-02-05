//
//  PlaySongScene.swift
//  GuitarGame
//
//  Created by Mac Macoy on 11/4/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import SceneKit

class PlaySongView {
    
    // for testing
    let simulator = false
    
    // model
    var gameplaySongPlayer: GameplaySongPlayer!
    
    // view
    private var view: SCNView!
    private var mainScene: SCNScene!
    private var chordSCNNodeFactory = ChordSCNNodeFactory()
    private var lyricUILabelFactory = LyricUILabelFactory()
    private var viewConstants = ViewConstants()
    private let colors = Colors()
    private var chordSCNNodes = [SCNNode?]()
    private var chordSCNNodesHit = [Bool]()
    private var lyricUILabels = [UILabel]()
    private var currentLyricIndex = -1
    private var chordChartNowView = UIImageView()
    private var chordChartNextView = UIImageView()
    private var blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private var exitButton: UIButton!
    
    init(scnView: SCNView, gameplaySongPlayer: GameplaySongPlayer, viewController: UIViewController) {
        // set view as the scene
        view = scnView
        self.gameplaySongPlayer = gameplaySongPlayer
        self.viewController = viewController
        initMainScene()
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    func initMainScene() {
        view.scene = SCNScene(named: "art.scnassets/Main.scn")
        self.mainScene = view.scene
        setUpBackground()
        initChordViews()
        initLyricViews()
        setUpCamera()
        setUpLighting()
        moveTimeZeroMarker()
        
        // it usually loads lazily, so call this to build it now
        view.prepare(view.scene, shouldAbortBlock: nil)
    }
    
    func setSCNViewDelegate(delegate: SCNSceneRendererDelegate) {
        view.delegate = delegate
    }
    
    func initChordViews() {
        var chordIndex = 0
        for chord in gameplaySongPlayer.song.chords {
            let zRange = secondsToZRange(timeToNow: chord.time)
            if chord.chord != nil {
                let chordSCNNode = chordSCNNodeFactory.make(chordName: chord.chord!.name,
                                                            zLength: zRange.upperBound - zRange.lowerBound,
                                                            zStart: zRange.lowerBound,
                                                            zEnd: zRange.upperBound)
                chordSCNNode.name = "Chord" + String(chordIndex)
                self.mainScene.rootNode.addChildNode(chordSCNNode)
                chordSCNNodes.append(chordSCNNode)
            }
            else {
                chordSCNNodes.append(nil)
            }
            chordIndex += 1
        }
        chordSCNNodesHit = [Bool](repeating: false, count: gameplaySongPlayer.song.chords.count)
    }
    
    func initLyricViews() {
        for lyric in gameplaySongPlayer.song.lyrics {
            var lyricUILabel = lyricUILabelFactory.makeLyricView(lyric: lyric.lyric)
            lyricUILabels.append(lyricUILabel)
        }
    }
    
    func startScene() {
        for chordSCNNode in chordSCNNodes {
            if chordSCNNode != nil {
                moveChordNode(chordSCNNode: chordSCNNode!)
            }
        }
        setUpLyricsOnScreen()
    }
    
    private func setChordViewColor(node: SCNNode, chordName: String, hit: Double?) {
        if hit != nil {
            node.geometry?.firstMaterial?.diffuse.contents = colors.chordHit(hitScore: hit!)
        }
        else {
            node.geometry?.firstMaterial?.diffuse.contents = colors.chordNotHit
        }
    }
    
    private func moveChordNode(chordSCNNode: SCNNode) {
        let moveAction = SCNAction.move(by: SCNVector3(0,0,-totalMovementLength), duration: gameplaySongPlayer.song.duration)
        chordSCNNode.runAction(moveAction)
    }
    
    private func secondsToZRange(timeToNow: ClosedRange<Double>) -> ClosedRange<Double> {
        let lowerBound = secondsToZ(time: timeToNow.lowerBound)
        let upperBound = secondsToZ(time: timeToNow.upperBound)
        return lowerBound...upperBound
    }
    
    private func secondsToZ(time: Double) -> Double {
        return (time - viewConstants.secondsInZRange.lowerBound) * zPerSecond + chordSCNNodeFactory.defaultChordSCNNodeLength/2
    }
    
    private var zPerSecond: Double {
        return (viewConstants.zRange.upperBound - viewConstants.zRange.lowerBound) / (viewConstants.secondsInZRange.upperBound - viewConstants.secondsInZRange.lowerBound)
    }
    
    func updateView() {
        // chords
        let currentChord = gameplaySongPlayer.getCurrentChord()
        if currentChord.chordIndex != -1 {
            if !chordSCNNodesHit[currentChord.chordIndex] && gameplaySongPlayer.scoring.hit[currentChord.chordIndex] != nil
                && currentChord.chord != nil && chordSCNNodes[currentChord.chordIndex] != nil {
                setChordViewColor(node: chordSCNNodes[currentChord.chordIndex]!, chordName: currentChord.chord!.name, hit: gameplaySongPlayer.scoring.hit[currentChord.chordIndex])
            }
            
//            // remove chordview if passed
//            // ** do it in main thread if so
//            for i in 0..<currentChord.chordIndex {
//                if chordSCNNodes[i] != nil {
//                    if chordSCNNodes[i]!.parent != nil {
//                        if !view.isNode(chordSCNNodes[i]!, insideFrustumOf: view.pointOfView!) {
//                            chordSCNNodes[i]!.removeFromParentNode()
//                            chordSCNNodes[i]!.removeAllActions()
//                        }
//                    }
//                }
//            }
            
            // lyrics
            let nextLyricIndex = gameplaySongPlayer.currentLyricIndex
            
            // update lyrics
            if nextLyricIndex > currentLyricIndex {
                updateLyrics(nextLyricIndex: nextLyricIndex)
            }
        }
    }
    
    private func setUpLyricsOnScreen() {
//        nextLyricFadeInAnimation(lyricIndex: 0)
    }
    
    private func updateLyrics(nextLyricIndex: Int) {
        for i in currentLyricIndex..<nextLyricIndex {
            currentLyricFadeOutAnimation(lyricIndex: i)
        }
        currentLyricIndex = nextLyricIndex
        if currentLyricIndex < gameplaySongPlayer.song.lyrics.count {
            nextLyricFadeInAnimation(lyricIndex: currentLyricIndex)
        }
    }
    
    private func currentLyricFadeOutAnimation(lyricIndex: Int) {
        if lyricIndex >= 0 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.viewConstants.lyricFadeTimeInterval, animations: {
                    self.lyricUILabels[lyricIndex].alpha = 0.0
                }, completion: {
                    (finished: Bool) in self.lyricUILabels[lyricIndex].removeFromSuperview()
                })
            }
        }
//        lyricUILabels[lyricIndex].removeFromSuperview()
    }
    
    private func nextLyricFadeInAnimation(lyricIndex: Int) {
        DispatchQueue.main.async {
            self.view.addSubview(self.lyricUILabels[lyricIndex])
            self.lyricUILabels[lyricIndex].alpha = 0.0
            let originalTransform = self.lyricUILabels[lyricIndex].transform
            let translatedTransform = originalTransform.translatedBy(x: 0.0, y: self.viewConstants.lyricRectHeight/2)
            UIView.animate(withDuration: self.viewConstants.lyricFadeTimeInterval, animations: {
                self.lyricUILabels[lyricIndex].transform = translatedTransform
                self.lyricUILabels[lyricIndex].alpha = self.viewConstants.lyricAlphaRange.upperBound
            })
        }
    }
    
    private func drawChordLane() {
        
    }
    
    private func moveTimeZeroMarker() {
        let timeZeroSCNNode = self.mainScene.rootNode.childNode(withName: "Time 0", recursively: true)!
        timeZeroSCNNode.position.z = Float(secondsToZ(time: 0)) + Float(viewConstants.timeZeroAdditionalZ)
        timeZeroSCNNode.eulerAngles.x = viewConstants.timeZeroEulerAngle(zAtZeroSeconds: timeZeroSCNNode.position.z)
    }
    
    private var totalMovementLength: Double {
        return (gameplaySongPlayer.song.duration / viewConstants.windowSize) * viewConstants.zLength
    }
    
    private func setUpCamera() {
        let cameraNode = self.mainScene.rootNode.childNode(withName: "Camera", recursively: true)!
        cameraNode.position.y = viewConstants.cameraY
        cameraNode.position.z = viewConstants.cameraZ
        cameraNode.eulerAngles.x = viewConstants.cameraEulerAngle(yFov: Float((cameraNode.camera! as! SCNCamera).yFov))
    }
    
    private func setUpLighting() {
        let omniLight1Node = self.mainScene.rootNode.childNode(withName: "Omni Light 1", recursively: true)!
        omniLight1Node.position.y = viewConstants.cameraY + viewConstants.lightHeight
        omniLight1Node.position.z = viewConstants.cameraZ
        if simulator {
            omniLight1Node.light!.intensity = 1000
        }
    }
    
    private func setUpBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [#colorLiteral(red: 0.1301445663, green: 0.1413801014, blue: 0.1564518511, alpha: 1).cgColor, #colorLiteral(red: 0.1450980392, green: 0.3490196078, blue: 0.4588235294, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = self.view.bounds
        let image = UIImage.imageWithLayer(layer: gradientLayer)
        mainScene.background.contents = image
    }
    
    func pause() {
        for chordSCNNode in chordSCNNodes {
            chordSCNNode?.isPaused = true
        }
        setChordCharts()
        blurBackground()
        view.addSubview(chordChartNowView)
        view.addSubview(chordChartNextView)
        showExitButton()
    }
    
    func pauseButDontBlur() {
        for chordSCNNode in chordSCNNodes {
            chordSCNNode?.isPaused = true
        }
    }
    
    func unpause() {
        for chordSCNNode in chordSCNNodes {
            chordSCNNode?.isPaused = false
        }
        chordChartNowView.removeFromSuperview()
        chordChartNextView.removeFromSuperview()
        unBlurBackground()
        removeExitButton()
    }
    
    func blurBackground() {
        blurEffect.frame = view.bounds
        view.addSubview(blurEffect)
    }
    
    func unBlurBackground() {
        blurEffect.removeFromSuperview()
    }
    
    func setChordCharts() {
        // get current chord
        let currentChordIndex = gameplaySongPlayer.currentChordIndex
        var currentChord: Chord? = nil
        if currentChordIndex < gameplaySongPlayer.song.chords.count && currentChordIndex != -1 {
            if gameplaySongPlayer.song.chords[currentChordIndex].chord != nil {
                currentChord = gameplaySongPlayer.song.chords[currentChordIndex].chord
            }
        }
        
        // get next chord
        var nextChordIndex = gameplaySongPlayer.currentChordIndex + 1
        var nextChord: Chord? = nil
        while nextChord == nil {
            if nextChordIndex < gameplaySongPlayer.song.chords.count && currentChordIndex != -1 {
                if gameplaySongPlayer.song.chords[nextChordIndex].chord != nil {
                    nextChord = gameplaySongPlayer.song.chords[nextChordIndex].chord
                }
                else {
                    nextChordIndex += 1
                }
            }
        }
        
        // set UIImageViews
        if currentChord != nil && nextChord != nil {
            let imageCurrent = ChordCartUIImageFactory.make(chord: currentChord!.name)
            let sizeCurrent = CGSize(width: viewConstants.screenWidth/2, height: viewConstants.screenWidth/2)
            let originCurrent = CGPoint(x: viewConstants.screenWidth/2 - sizeCurrent.width/2, y: 2*viewConstants.screenHeight/3 - sizeCurrent.height/2)
            chordChartNowView.frame = CGRect(origin: originCurrent, size: sizeCurrent)
            chordChartNowView.image = imageCurrent
 
            let imageNext = ChordCartUIImageFactory.make(chord: nextChord!.name)
            let sizeNext = CGSize(width: viewConstants.screenWidth/2, height: viewConstants.screenWidth/2)
            let originNext = CGPoint(x: viewConstants.screenWidth/2 - sizeNext.width/2, y: viewConstants.screenHeight/3 - sizeNext.height/2)
            chordChartNextView.frame = CGRect(origin: originNext, size: sizeNext)
            chordChartNextView.image = imageNext
        }
        else if currentChord != nil {
            let imageCurrent = ChordCartUIImageFactory.make(chord: currentChord!.name)
            let sizeCurrent = CGSize(width: viewConstants.screenWidth/2, height: viewConstants.screenWidth/2)
            let originCurrent = CGPoint(x: viewConstants.screenWidth/2 - sizeCurrent.width/2, y: viewConstants.screenHeight/2 - sizeCurrent.height/2)
            chordChartNowView.frame = CGRect(origin: originCurrent, size: sizeCurrent)
            chordChartNowView.image = imageCurrent
        }
        else if nextChord != nil {
            let imageNext = ChordCartUIImageFactory.make(chord: nextChord!.name)
            let sizeNext = CGSize(width: viewConstants.screenWidth/2, height: viewConstants.screenWidth/2)
            let originNext = CGPoint(x: viewConstants.screenWidth/2 - sizeNext.width/2, y: viewConstants.screenHeight/2 - sizeNext.height/2)
            chordChartNextView.frame = CGRect(origin: originNext, size: sizeNext)
            chordChartNextView.image = imageNext
        }
    }
    
    func showExitButton() {
        exitButton = UIButton()
        exitButton.setTitle("Exit", for: .normal)
        exitButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        let x = viewConstants.screenWidth*4/5
        let y = viewConstants.screenHeight - viewConstants.screenWidth*1/5
        let width = 50
        let height = 50
        exitButton.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
        exitButton.addTarget(self, action: #selector(exit(_:)), for: .touchUpInside)
        view.addSubview(exitButton)
    }
    
    func removeExitButton() {
        if exitButton != nil {
            exitButton.removeFromSuperview()
            exitButton = nil
        }
    }
    
    // only used for exit function
    private var viewController: UIViewController?
    
    @objc private func exit(_ sender: UIButton?) {
        let mainMenuController = Utils.getViewController(viewControllerName: "MainMenu")
        Utils.setCurrentViewController(from: viewController!, to: mainMenuController)
    }
}
