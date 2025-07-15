//
//  ExpectationStepView.swift
//  Example
//
//  Created by Long Pham on 19/6/25.
//

import SwiftUI

struct ExpectationStepView: View {
    let stepNumber: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            // Step Number Circle
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 40, height: 40)
                
                Text("\(stepNumber)")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Step Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
    }
}

#Preview {
    VStack {
        ExpectationStepView(stepNumber: 1, title: "Title", description: "Description")
    }
}
