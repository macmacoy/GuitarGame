//
//  WebApiConstants.swift
//  JamSesh
//
//  Created by Mac Macoy on 1/28/19.
//  Copyright © 2019 Mac Macoy. All rights reserved.
//
import Foundation

class WebApi {
    
    static let queue = DispatchQueue(label: "api-caller")
    
    static let apiKey = "eSy0ma0OpU1K94fZlM5RHq7DwMVUwmr393ZiyQ94"
    
    static let base = URL(string: "https://qx31b8ilpf.execute-api.us-east-1.amazonaws.com/beta")
    static var search: URL {
        return self.base!.appendingPathComponent("/search")
    }
    static var song: URL {
        return self.base!.appendingPathComponent("/song")
    }
    static var allSongs: URL {
        return self.base!.appendingPathComponent("/all-songs")
    }
    
    static func get(url: URL, host: String) -> [String:Any]? {
        return call(method: "GET", url: url, host: host)
    }
    
    static func post(url: URL, host: String) -> [String:Any]? {
        return call(method: "PUT", url: url, host: host)
    }
    
    static private func call(method: String, url: URL, host: String) -> [String:Any]? {
        
        var responseDict: [String:Any]? = nil
        let timeoutInterval = 10.0
        
        let headers = [
            "x-api-key": self.apiKey,
            "Content-Type": "application/x-www-form-urlencoded",
            "Host": host,
            "X-Amz-Date": "20190202T152022Z",
            "Authorization": "AWS4-HMAC-SHA256 Credential=/20190202/us-east-1/execute-api/aws4_request, SignedHeaders=cache-control;content-type;host;postman-token;x-amz-date;x-api-key, Signature=dbcc54757009ac0854224cdb0a6eba713af00ed7213b6e1acbf3efc682965eba",
            "cache-control": "no-cache",
            "Postman-Token": "795e2305-523b-4c1b-abbb-c9500b8bfa2f"
        ]
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: timeoutInterval)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        queue.async {
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse)
                if let data = data {
                    do {
                        // Convert the data to JSON
                        let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                        responseDict = jsonSerialized
                    }  catch let error as NSError {
                        print(error.localizedDescription)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }
            })
            dataTask.resume()
        }
        
        let now = Date()
        while abs(now.timeIntervalSinceNow) < timeoutInterval {
            if responseDict != nil {
                return responseDict
            }
        }
        return responseDict
    }
}
