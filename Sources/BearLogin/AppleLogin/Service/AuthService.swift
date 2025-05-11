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

public protocol AuthServiceProtocol {
    /// 苹果登录
    func fetchAuthApple(with authorizationCode: String) -> AnyPublisher<ApiResponse<AuthModel>, MoyaError>
}

public class AuthService: AuthServiceProtocol {
    
    public init() {}
    
    private let provider = MoyaProvider<AuthTarget>(plugins: plugins_bear)
    
    public func fetchAuthApple(with authorizationCode: String) -> AnyPublisher<ApiResponse<AuthModel>, MoyaError> {
        let target = AuthTarget.authApple(authorizationCode: authorizationCode)
        return provider.requestPublisher(target)
            .mapResult()
            .eraseToAnyPublisher()
    }
    
}
