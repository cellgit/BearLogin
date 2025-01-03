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
    
    // 使用Service层获取数据
    func fetchAuth(with authorizationCode: String) {
        
        service.fetchAuthApple(with: authorizationCode)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    debugPrint("error ======= \(error)")
                }
            }, receiveValue: { model in
                debugPrint("model.token ==== \(String(describing: model.token))")
                self.token = model.token
            })
            .store(in: &cancellables)
    }
    
}
