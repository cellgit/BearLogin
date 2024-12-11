//
//  File.swift
//  BearLogin
//
//  Created by liuhongli on 2024/12/11.
//

import Foundation
import AuthenticationServices
import SwiftUI

typealias MTCallback = ([String: Any]?, Error?) -> Void

@MainActor
class AppleSignInManager: NSObject, ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var userInfo: [String: Any]? = nil
    @Published var error: Error? = nil

    public static let shared = AppleSignInManager() // 单例实例
    private var callback: MTCallback?

    public func performAppleSignIn(callback: @escaping MTCallback) {
        self.callback = callback
        checkAppleIDLoginStatus()
    }

    public func performAppleSignInContinue() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    public func logOut() {
        UserDefaults.standard.removeObject(forKey: "appleAuthorizedUserIdKey")
        self.isSignedIn = false
        self.userInfo = nil
    }

    private func checkAppleIDLoginStatus() {
        guard let userIdentifier = UserDefaults.standard.string(forKey: "appleAuthorizedUserIdKey") else {
            performAppleSignInContinue()
            return
        }

        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
            Task { @MainActor in
                if let error = error {
                    print("Error fetching credential state: \(error)")
                    self.performAppleSignInContinue()
                    return
                }

                switch credentialState {
                case .authorized:
                    print("User is authorized")
                    self.isSignedIn = true
                case .revoked, .notFound:
                    print("User is not found or revoked")
                    self.performAppleSignInContinue()
                default:
                    break
                }
            }
        }
    }
}



@available(iOS 13.0, *)
extension AppleSignInManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userId = appleIDCredential.user
            UserDefaults.standard.set(userId, forKey: "appleAuthorizedUserIdKey")
            if let authorizationCode = appleIDCredential.authorizationCode,
               let code = String(data: authorizationCode, encoding: .utf8) {
                print("authorizationCode is: \(code)")
                DispatchQueue.main.async {
                    self.isSignedIn = true
                    self.userInfo = ["authorizationCode": code]
                }
                self.callback?(["authorizationCode": code], nil)
            } else {
                print("Failed to decode authorizationCode")
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Authorization failed: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isSignedIn = false
            self.error = error
        }
        self.callback?(nil, error)
    }
    
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return controller.presentationContextProvider?.presentationAnchor(for: controller) ?? ASPresentationAnchor()
    }
}

struct SignInWithAppleButton: View {
    @ObservedObject var signInManager = AppleSignInManager.shared
    
    var body: some View {
        VStack {
            if signInManager.isSignedIn {
                Text("Signed in as: \(signInManager.userInfo?["authorizationCode"] as? String ?? "Unknown")")
                Button("Sign Out") {
                    signInManager.logOut()
                }
            } else {
                Button("Sign in with Apple") {
                    signInManager.performAppleSignIn { info, error in
                        if let error = error {
                            print("Sign-in error: \(error)")
                        } else {
                            print("Sign-in success: \(info ?? [:])")
                        }
                    }
                }
            }
        }
        .padding()
    }
}
