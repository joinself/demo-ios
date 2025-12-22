//
//  ApplicationAddressView.swift
//  ios-client
//

import SwiftUI

public struct ApplicationAddressView: View {
    let onBack: (() -> Void)?
    var onEnterAddress: ((String) -> Void)?
    @State private var applicationAddress = ""
    
    private let maxCharacters = 66
    
    private var isValidServerAddress: Bool {
        return applicationAddress.count == maxCharacters && applicationAddress.allSatisfy { $0.isHexDigit }
    }
    
    public init(onEnterAddress: @escaping (String) -> Void, onBack: (() -> Void)? = nil) {
        self.onEnterAddress = onEnterAddress
        self.onBack = onBack
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // DEBUG Header
                HStack {
                    Button {
                        onBack?()
                    } label: {
                        Image(systemName: ResourceHelper.ICON_BACK)
                            .foregroundStyle(Color.primaryBlue)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                
                VStack(spacing: 40) {
                    // Cloud Icon and Title Section
                    VStack(spacing: 24) {
                        // Cloud Icon
                        Image("private_connectivity", bundle: ResourceHelper.bundle)
                            .padding(.top, 40)
                        
                        // Title and Subtitle
                        VStack(spacing: 12) {
                            Text("Register by Address")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                            
                            Text("Enter application address to register your Self account.")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Enter the 66-character hexadecimal server address/ID.")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            TextField("Enter 66-char hex address", text: $applicationAddress)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .font(.system(size: 16))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: applicationAddress) { newValue in
                                    // Limit to 66 characters and ensure hex
                                    let filtered = newValue.filter { $0.isHexDigit }
                                    if filtered.count > maxCharacters {
                                        applicationAddress = String(filtered.prefix(maxCharacters))
                                    } else {
                                        applicationAddress = filtered
                                    }
                                }
                            
                            HStack {
                                Text("\(applicationAddress.count)/\(maxCharacters) characters")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 60)
                    
                    Button(action: {
                        onEnterAddress?(applicationAddress)
                    }) {
                        HStack {
                            Text("Register")
                        }
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isValidServerAddress ? .white : .black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isValidServerAddress ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            Spacer(minLength: 80)
        }
        .background(Color.white)
    }
}

#Preview {
    ApplicationAddressView { address in
        
    } onBack: {
        
    }

}
