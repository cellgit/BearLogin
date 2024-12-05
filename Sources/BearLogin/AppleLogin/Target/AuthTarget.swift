//
//  File.swift
//  BearLogin
//
//  Created by liuhongli on 2024/12/5.
//

import Moya
import CombineMoya
import BearBasic

public enum AuthTarget {
    /// 苹果登录
    case authApple(authorizationCode: String)
}

extension AuthTarget: BaseTargetType {
    public var path: String {
        switch self {
        case .authApple:
            return "/auth/apple"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .authApple:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .authApple(authorizationCode: let authorizationCode):
            let dict = ["authorizationCode": authorizationCode]
            return self.jsonTask(parameters: dict)
        }
    }
    
    public var headers: [String : String]? {
        return commonHeaders
    }
    
    
}
