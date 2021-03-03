//
//  APIManager.swift
//  FlickerDemo
//
//  Created by albertlin on 2021/3/1.
//

import Foundation

class APIManager {

    static let shared = APIManager()
    
    public func getPhotoData(search:String, per_page:String, currentPage:Int, success : @escaping Success) -> Void {

        let method = "flickr.photos.search"
        let api_key = "438339be156d4d3234195ec95a2b62f0"
        let format = "json"
        let nojsoncallback = "1"
        
        let queryItems: [URLQueryItem]? = [.init(name: "method", value: method), .init(name: "api_key", value: api_key), .init(name: "text", value: search), .init(name: "per_page", value: per_page), .init(name: "format", value: format), .init(name: "nojsoncallback", value: nojsoncallback), .init(name: "page", value: "\(currentPage)")]
        
        HttpTools.sendGet(path: "/services/rest/",
                         queryItems: queryItems,
                         success: { (response) in
                            
                            do {
                                
                                let result:ResultModel = try JSONDecoder().decode(ResultModel.self, from: response as! Data)

                                success(result)
                                
                            } catch {
                                
                                debugPrint("decode error: = \(error.localizedDescription)")
                            }
                         })
    }
}
