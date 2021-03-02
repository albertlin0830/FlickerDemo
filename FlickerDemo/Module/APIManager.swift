//
//  APIManager.swift
//  FlickerDemo
//
//  Created by albertlin on 2021/3/1.
//

import Foundation
import PKHUD

class APIManager {

    static func sendGet(scheme:String!, host:String!, path:String!, queryItems: [URLQueryItem]? = nil) {
        
        var component = URLComponents()
        
        component.scheme = scheme
        component.host = host
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
            
//            do {
//                let result = try JSONDecoder().decode(ResultModel.self, from: data)
//                debugPrint(result)
//            } catch {
//                debugPrint("decode error: = \(error.localizedDescription)")
//            }
        }
        task.resume()
    }
}
