//
//  AppDelegate.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/21/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // make my app direction in Library/Application Support
        makeAppDirectories()
        
        // for testing
        //  you don't want songs coming in the bundle in case you need to remove them
//        moveInitalSongFiles()
        
        // get songs available
        SongSearch.searchAllSongsAPI(text: "")
        
        // set some view constants
        viewStuff()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        if let currentViewController = navigationController?.visibleViewController as? PlaySongViewController {
            currentViewController.pauseButDontBlur()
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        // TODO: need to figure out how to pause if user leaves mid song
        let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        if let currentViewController = navigationController?.visibleViewController as? PlaySongViewController {
            currentViewController.pauseButDontBlur()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    private func viewStuff() {
        UINavigationBar.appearance().barTintColor = Colors.navigationBarColor
        UINavigationBar.appearance().tintColor = Colors.navigationItemColor
        UITabBar.appearance().unselectedItemTintColor = Colors.unselectedTabItemColor
    }
    
    private func moveInitalSongFiles() {
        let fileManager = FileManager.default
        
        // move song files from bundle to library
        let initialSongFiles = [
            "short_test_song%test.json"
        ]
        let bundle = Bundle.main
        for initialSongFile in initialSongFiles {
            do {
                let bundleFileURL = bundle.url(forResource: initialSongFile, withExtension: "json")!
                let fileURL = FileSystemConstants.songsDirectoryURL.appendingPathComponent(initialSongFile + ".json")
//                print(fileURL)
                try fileManager.copyItem(at: bundleFileURL, to: fileURL)
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func makeAppDirectories() {
        let fileManager = FileManager.default
        do {
            // make songs directory
            try fileManager.createDirectory(at: FileSystemConstants.songsDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print(error.localizedDescription)
        }
    }

}
