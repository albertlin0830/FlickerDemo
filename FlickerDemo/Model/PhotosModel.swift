//
//  PhotosModel.swift
//  FlickerDemo
//
//  Created by albertlin on 2021/3/2.
//

import Foundation

struct PhotosModel:Codable {
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [PhotoModel]
}
