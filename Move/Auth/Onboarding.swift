//
//  OnboardingPage.swift
//  Move
//
//  Created by Sergiu Corbu on 4/7/21.
//

import SwiftUI

struct Onboarding: View {
    
    @State private var currentIndex: Int = 0
    let onFinished: () -> Void
    var title: String {
        return onboardingData[currentIndex].title
    }
    var description: String {
        return onboardingData[currentIndex].description
    }
    var image: String {
        return onboardingData[currentIndex].image
    }
    var lastPage: Bool {
        if currentIndex < onboardingData.count - 1 { return false }
        return true
    }
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                Image(image)
                    .resizable()
                    .frame(width: geometry.size.width, height: geometry.size.height / 0.9)
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.top)
            }
            VStack(alignment: .leading, spacing: 0) {
                titleLine
                descriptionLine
                pageControlLine
			}
            .padding(.horizontal, 24)
        }
        .background(Color.white)
    }
    
    var titleLine: some View {
        HStack {
            Text(title)
                .font(.custom(FontManager.Primary.bold, size: 34.0))
                .foregroundColor(.darkPurple)
            Spacer()
            if  !lastPage {
                Button(action: {
                    onFinished()
                }, label: {
                    Text("Skip")
                        .font(.custom(FontManager.Primary.semiBold, size: 18))
                        .foregroundColor(.fadePurple)
                })
            }
        }
        .padding(.bottom, 20)
    }
    
	var descriptionLine: some View {
		VStack(alignment: .leading) {
			Text(description)
				.font(.custom(FontManager.Primary.medium, size: 17))
				.foregroundColor(.darkPurple)
				.opacity(0.7)
				.lineSpacing(4)
				.fixedSize(horizontal: false, vertical: true)
			Spacer()
		}
	}
    
    var pageControlLine: some View {
		HStack {
			PageControl(currentIndex: $currentIndex)
			Spacer()
			Button(action: {
				if currentIndex == onboardingData.count - 1 {
					onFinished()
				} else { currentIndex += 1 }
			}, label: {
				HStack {
					Text(lastPage ? "Get Started" : "Next")
						.font(.custom(FontManager.Primary.bold, size: 18))
					Image(systemName: "arrow.right")
				}
				.foregroundColor(.white)
				.padding(.all, 16)
				.background(Rectangle()
								.foregroundColor(.coralRed)
								.cornerRadius(16))})
		}
		.padding(.bottom, 40)
	}
}

struct PageControl: View {
    @Binding var currentIndex: Int
    var body: some View {
        ForEach(0..<onboardingData.count) { page in
            RoundedRectangle(cornerRadius: 1.5)
                .foregroundColor(currentIndex == page ? .darkPurple : .fadePurple)
                .frame(width: currentIndex == page ? 16 : 4, height: 4)
                .padding(.trailing, 5)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE (2nd generation)", "iPhone 12"], id: \.self) { deviceName in
            Onboarding(onFinished: {})
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
