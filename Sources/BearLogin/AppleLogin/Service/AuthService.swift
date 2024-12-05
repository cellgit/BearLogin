//
//  File.swift
//  BearLogin
//
//  Created by liuhongli on 2024/12/5.
//

import Foundation
import Combine
import Moya
import CombineMoya
import BearBasic

protocol AuthServiceProtocol {
    /// 苹果登录
    func fetchAuthApple(with authorizationCode: String) -> AnyPublisher<AuthModel, MoyaError>
    
}

class AuthService: AuthServiceProtocol {
    
    private let provider = MoyaProvider<AuthTarget>(plugins: plugins_bear)
    
    func fetchAuthApple(with authorizationCode: String) -> AnyPublisher<AuthModel, MoyaError> {
        let target = AuthTarget.authApple(authorizationCode: authorizationCode)
        return provider.requestPublisher(target)
            .mapResult()
            .eraseToAnyPublisher()
    }
    
}
