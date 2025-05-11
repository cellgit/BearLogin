//
//  File.swift
//  BearLogin
//
//  Created by liuhongli on 2024/12/11.
//

import Foundation
import Combine

public class AuthViewModel: ObservableObject {
    @Published public var token: String?
    private var cancellables = Set<AnyCancellable>()
    private let service: AuthServiceProtocol
    
    public init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
    }
    func fetchAuth(with authorizationCode: String) {
        service.fetchAuthApple(with: authorizationCode)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("❌ 请求失败: \(error)")
                }
            }, receiveValue: { res in
                // ✅ 这里 `res` 是 `APIResponse<AuthModel>`
                self.token = res.data.token // 提取 token
                debugPrint("✅ 登录成功: token = \(self.token), code = \(res.code), message = \(res.message)")
            })
            .store(in: &cancellables)
    }
    
}
