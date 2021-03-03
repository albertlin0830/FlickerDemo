//
//  HttpTools.swift
//  FlickerDemo
//
//  Created by albertlin on 2021/3/3.
//

import Foundation
import PKHUD

typealias Success = (Any?) -> Void

class HttpTools {

    static func sendGet(path:String!, queryItems: [URLQueryItem]? = nil, success : @escaping Success) {
        
        var component = URLComponents()
        
        component.scheme = "https"
        component.host = "www.flickr.com"
        component.path = path
        component.queryItems = queryItems
        
        guard let url = component.url else {
            fatalError("url error")
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                debugPrint("get error: = \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                debugPrint("data is nil")
                return
            }
            
            success(data)
        }
        task.resume()
    }
}
