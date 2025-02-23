//
//  File.swift
//  BearLogin
//
//  Created by liuhongli on 2024/12/11.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    
    @Published var token: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let service: AuthServiceProtocol
    
    // 初始化传入Service
    init(service: AuthServiceProtocol = AuthService()) {
        self.service = service
    }
    
//    // 使用Service层获取数据
//    func fetchAuth(with authorizationCode: String) {
//        
//        service.fetchAuthApple(with: authorizationCode)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished:
//                    break
//                case .failure(let error):
//                    debugPrint("error ======= \(error)")
//                }
//            }, receiveValue: { model in
//                debugPrint("model.token ==== \(String(describing: model.token))")
//                self.token = model.token
//            })
//            .store(in: &cancellables)
//    }
    
    
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
//                self.authCode = res.code // 提取业务状态码
//                self.authMessage = res.message // 提取业务信息
                
                debugPrint("✅ 登录成功: token = \(self.token), code = \(res.code), message = \(res.message)")
            })
            .store(in: &cancellables)
    }

    
}
