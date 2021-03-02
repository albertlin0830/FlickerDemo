//
//  PhotoModel.swift
//  FlickerDemo
//
//  Created by albertlin on 2021/3/2.
//

import Foundation

struct PhotoModel:Codable {
    var id: String?
    var owner: String?
    var secret: String?
    var server: String?
    var farm: Int?
    var title: String?
    var ispublic: Int?
    var isfriend: Int?
    var isfamily: Int?
}
