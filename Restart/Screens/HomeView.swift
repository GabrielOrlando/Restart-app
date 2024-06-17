//
//  HomeView.swift
//  Restart
//
//  Created by Gabriel Orlando on 06/06/24.
//

import SwiftUI

struct HomeView: View {
	// MARK: - PROPERTIES
	
	@AppStorage("onboarding") var isOnboardingViewActive: Bool = false
	@State private var isAnimating: Bool = false
	
	// MARK: - BODY
	
	var body: some View {
		VStack(spacing: 20) {
			// MARK: - HEADER
			
			Spacer()
			
			ZStack {
				CircleGroupView(ShapeColor: .blue, ShapeOpacity: 0.1)
				
				Image("character-2")
					.resizable()
					.scaledToFit()
					.padding()
					.offset(y: isAnimating ? 35 : -35)
					.animation(
						Animation
							.easeInOut(duration: 4)
							.repeatForever()
						, value: isAnimating
					)
			}
			
			// MARK: - CENTER
			Text("The time that leads to mastery is dependent on the intensity of our focus.")
				.font(.title3)
				.fontWeight(.light)
				.foregroundStyle(Color.secondary)
				.multilineTextAlignment(.center)
				.padding()
			
			// MARK: - FOOTER
			
			Spacer()
			
			Button {
				withAnimation {
					playSound(sound: "success", type: "m4a")
					isOnboardingViewActive = true
				}
			} label: {
				Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
					.imageScale(.large)
				
				Text("Restart")
					.font(.system(.title3, design: .rounded))
					.fontWeight(.bold)
				
			} //: BUTTON
			.buttonStyle(.borderedProminent)
			.buttonBorderShape(.capsule)
			.controlSize(.large)
			
		} //: VSTACK
		.onAppear(perform: {
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
				isAnimating = true
			})
		})
	}
}

#Preview {
    HomeView()
}
