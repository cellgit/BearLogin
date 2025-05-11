//
//  SwiftUIView.swift
//  BearLogin
//
//  Created by liuhongli on 2024/12/12.
//

import SwiftUI
import AuthenticationServices

public struct AppleSignInButtonView: View {
    
    @Binding var token: String? // 使用 Binding 接收 token
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel: AuthViewModel
    public init(token: Binding<String?>, viewModel: AuthViewModel) {
        _token = token
        // 初始化 @StateObject
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        VStack {
            if #available(macOS 11.0, *) {
                SignInWithAppleButton(.signIn, onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                }, onCompletion: { result in
                    switch result {
                    case .success(let authorization):
                        handleAuthorization(authorization)
                    case .failure(let error):
                        print("Apple login failed: \(error)")
                    }
                })
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .frame(height: 50) // 控制按钮高度
                .cornerRadius(10) // 添加圆角
                .shadow(radius: 10) // 为按钮添加阴影
                .padding(.horizontal) // 增加按钮的水平间距
            } else {
                // Fallback on earlier versions
            }
        }
        .padding()
        .onChange(of: viewModel.token) { oldValue, newValue in
            self.token = newValue // 绑定 ViewModel 中的 token 到外部视图的 token
        }
    }
    
    private func handleAuthorization(_ authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let code = String(data: authorizationCode, encoding: .utf8) {
                print("authorizationCode is: \(code)")
                // 进行网络请求,将`code`传递到服务端进行验证
                viewModel.fetchAuth(with: code)
                
            } else {
                print("Failed to decode authorizationCode")
            }
        }
    }
}


#Preview {
    AppleSignInButtonView(token: .constant(""), viewModel: AuthViewModel())
}

