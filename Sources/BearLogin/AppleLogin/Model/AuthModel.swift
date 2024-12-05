//
//  File.swift
//  BearLogin
//
//  Created by liuhongli on 2024/12/5.
//

import Foundation

// 苹果登录
struct AuthModel: Decodable, Hashable, Identifiable {
    var token: String?
    var id: String? = UUID().uuidString
}
