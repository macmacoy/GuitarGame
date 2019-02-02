//
//  Utils.swift
//  GuitarGame
//
//  Created by Mac Macoy on 10/6/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func convertToDictionary(jsonText: String) -> [String: Any]? {
        if let data = jsonText.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    static func getDictionary(forResource: String, withExtension: String) throws -> [String: Any]? {
        var text = ""
        do {
            let fileManager = FileManager.default
            let fileURL = FileSystemConstants.dataDirectoryURL.appendingPathComponent(forResource + "." + withExtension)
            text = try String(contentsOf: fileURL, encoding: .utf8)
            return Utils.convertToDictionary(jsonText: text)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func getDictionary(forResource: URL) -> [String: Any]? {
        var text = ""
        do {
            text = try String(contentsOf: forResource, encoding: .utf8)
        }
        catch {
            print(error.localizedDescription)
        }
        return Utils.convertToDictionary(jsonText: text)
    }
    
    static func writeDictionaryToJson(dict: Dictionary<String, Any>, forResource: String, withExtension: String) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let fileURL = FileSystemConstants.dataDirectoryURL.appendingPathComponent(forResource + "." + withExtension)
            try jsonData.write(to: fileURL)
        }
        catch {
            print(error.localizedDescription)
            print("unable to write dictionary to json file")
        }
    }
    
    static func getViewController(viewControllerName: String) -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: viewControllerName)
    }
    
    static func setCurrentViewController(from: UIViewController, to: UIViewController) {
        from.present(to, animated: true, completion: nil)
    }
    
}

extension UIImage {
    class func imageWithLayer(layer: CALayer) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    static func capitalizeFirstLetter(s: String) -> String {
        return s.capitalizingFirstLetter()
    }
}
