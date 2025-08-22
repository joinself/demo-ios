//
//  RegistrationIntroScreen.swift
//  ios-client
//

import SwiftUI

public struct RegistrationIntroScreen: View {
    @Binding private var isProcessing: Bool
    @State private var errorMessage: String? = nil
    @State private var isOn = false
    
    let onNext: () -> Void
    let onRestore: () -> Void
    public init(isProcessing: Binding<Bool> = .constant(false), errorMessage: String? = nil, onNext: @escaping () -> Void, onRestore: @escaping () -> Void) {
        self._isProcessing = isProcessing
        self.errorMessage = errorMessage
        self.onNext = onNext
        self.onRestore = onRestore
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // DEBUG Header
            HStack {
                Button {
                    onRestore()
                } label: {
                    Text("Restore Account")
                        .foregroundStyle(Color.gray)
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            
            VStack(spacing: 40) {
                // User Icon and Title Section
                VStack(spacing: 40) {
                    // User Icon
                    Image("person_add", bundle: ResourceHelper.bundle)
                        .padding()
                    
                    // Title and Subtitle
                    VStack(spacing: 12) {
                        Text("Register Your Account")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)
                        
                        Text("Complete a quick liveness check to securely register your Self account")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                
                // What to Expect Section
                CardView(icon: ResourceHelper.ICON_LIVENESS, title: "Liveness Check Required", description: "You will be asked for camera permission when you start. Look directly at the camera and follow the on-screen instructions.")
                
                Spacer()
                VStack (spacing: 0){
                    Text(self.cal())
                        .foregroundStyle(.black)
                        .tint(.blue) // link color
                        .multilineTextAlignment(.center)
                }
                
                HStack (alignment: .center) {
                    Toggle("", isOn: $isOn)
                        .toggleStyle(CustomToggleStyle(onColor: Color(red: 0, green: 0.64, blue: 0.43), offColor: Color(red: 0.24, green: 0.24, blue: 0.24), thumbColor: .white))
                        .frame(maxWidth: 40)
                        .padding()
                    Text("I agree")
                        .foregroundStyle(Color.black)
                        .onTapGesture {
                            isOn.toggle()
                        }
                }
                
                // Start Registration Button
                Button(action: {
                    onNext()
                }) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                            Text("Registering...")
                        } else {
                            Text("Start")
                                .foregroundStyle(!isOn ? Color(red: 0.31, green: 0.31, blue: 0.31) : .white)
                        }
                    }
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(!isOn ? Color(red: 0.95, green: 0.95, blue: 0.95) : Color.blue)
                    .cornerRadius(12)
                }
                .disabled(!isOn)
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                
                // Error Message
                if let error = errorMessage {
                    Text("Error: \(error)")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
        }
        .background(Color.white)
    }
    
    private func cal() -> AttributedString {
        let str = "To use Self, please agree to our\n[terms & conditions](https://docs.joinself.com/agreements/consumer_terms_and_conditions) & [privacy policy](https://docs.joinself.com/agreements/app_privacy_notice)."
        var markdownText = try! AttributedString(markdown: str, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        let termAndConditionLink = markdownText.range(of: "terms & conditions")!
        markdownText[termAndConditionLink].underlineStyle = .single
        
        let privacyPolicyLink = markdownText.range(of: "privacy policy")!
        markdownText[privacyPolicyLink].underlineStyle = .single
        
        return markdownText
    }
}

struct CustomToggleStyle: ToggleStyle {
    var onColor: Color
    var offColor: Color
    var thumbColor: Color
    
    public init(onColor: Color, offColor: Color, thumbColor: Color) {
        self.onColor = onColor
        self.offColor = offColor
        self.thumbColor = thumbColor
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Button(action: {
                configuration.isOn.toggle()
            }) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(configuration.isOn ? onColor : offColor)
                    .frame(width: 50, height: 30)
                    .overlay(
                        Circle()
                            .fill(thumbColor)
                            .padding(3)
                            .offset(x: configuration.isOn ? 10 : -10)
                    )
                    .animation(.easeInOut, value: configuration.isOn)
            }
        }
    }
}

#Preview {
    RegistrationIntroScreen(isProcessing: .constant(false), onNext: {
            
        }) {
            // restore
        }
}
