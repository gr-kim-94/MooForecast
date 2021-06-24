//
//  ApiError.swift
//  MooForecast
//
//  Created by 김가람 on 2021/06/23.
//

import Foundation

enum ApiError: Error {
    case unknown
    case invalidUrl(String)
    case invalidResponse
    case failed(Int)
    case emptyData
}
