//
//  ContentView.swift
//  Restart
//
//  Created by Gabriel Orlando on 06/06/24.
//

import SwiftUI

struct ContentView: View {
	@AppStorage("onboarding") var isOnboardingViewActive: Bool = true
	
    var body: some View {
		ZStack {
			if isOnboardingViewActive {
				OnboardingView()
			} else {
				HomeView()
			}
		}
    }
}

#Preview {
    ContentView()
}
