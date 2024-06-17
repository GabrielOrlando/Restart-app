//
//  OnboardingView.swift
//  Restart
//
//  Created by Gabriel Orlando on 06/06/24.
//

import SwiftUI

struct OnboardingView: View {
	// MARK: - PROPERTIES
	
	@AppStorage("onboarding") var isOnboardingViewActive: Bool = true
	
	@State private var buttonWidth : Double = UIScreen.main.bounds.width - 80 // Estado de Tamanho do botão de arrastar
	@State private var buttonOfsset : CGFloat = 0 // Estado da posição do botão de arrastar
	@State private var isAnimating : Bool = false // Estado de animação
	@State private var imageOffset : CGSize = .zero // Estado da posição da imagem
	@State private var indicatorOpacity : Double = 1.0 // Estado de opacidade do indicador de setas
	@State private var textTitle : String = "Share."
	
	let hapticFeedback = UINotificationFeedbackGenerator()
	
	// MARK: - BODY
	
    var body: some View {
		ZStack {
			Color("ColorBlue")
				.ignoresSafeArea(.all, edges: .all)
			
			VStack(spacing: 20) {
				// MARK: - HEADER
				
				Spacer()
				
				VStack(spacing: 0){
					Text(textTitle)
						.font(.system(size: 60))
						.fontWeight(.heavy)
						.foregroundStyle(Color(.white))
						.transition(.opacity)
						.id(textTitle)
					
					Text("""
					It's not how much we give but
					how much love we put into giving.
					""")
					.font(.title3)
					.fontWeight(.light)
					.foregroundStyle(Color(.white))
					.multilineTextAlignment(.center)
					.padding(.horizontal, 10)
					
				} //: HEADER
				.opacity(isAnimating ? 1 : 0)
				.offset(y: isAnimating ? 0 : -40)
				.animation(.easeOut(duration: 1), value: isAnimating)
				
				// MARK: - CENTER
				
				ZStack {
					CircleGroupView(ShapeColor: .white, ShapeOpacity: 0.2)
						.offset(x: imageOffset.width * -1)
						.blur(radius: abs(imageOffset.width / 5))
						.animation(.easeOut(duration: 1), value: imageOffset)
					
					Image("character-1")
						.resizable()
						.scaledToFit()
						.opacity(isAnimating ? 1 : 0)
						.animation(.easeOut(duration: 0.5), value: isAnimating)
						.offset(x: imageOffset.width * 1.2, y: 0)
						.rotationEffect(.degrees(Double(imageOffset.width / 20)))
						.gesture(
							DragGesture()
								.onChanged { gesture in
									if abs(imageOffset.width) <= 150 { // ABS retorna o número absoluto, transformando negativos em positivos.
										imageOffset = gesture.translation
										
										withAnimation(.linear(duration: 0.25)) {
											indicatorOpacity = 0
											textTitle = "Give."
										}
									}
								}
								.onEnded { _ in
									imageOffset = .zero
									
									withAnimation(.linear(duration: 0.25)) {
										indicatorOpacity = 1
										textTitle = "Share."
									}
								}
							
						) //: GESTURE
						.animation(.easeOut(duration: 1), value: imageOffset)
				} //: CENTER
				.overlay(
					Image(systemName: "arrow.left.and.right.circle")
						.font(.system(size: 44, weight: .ultraLight))
						.foregroundStyle(Color(.white))
						.offset(y: 20)
						.opacity(isAnimating ? 1 : 0)
						.animation(.easeInOut(duration: 1).delay(2), value: isAnimating)
						.opacity(indicatorOpacity)
					, alignment: .bottom
				)
				
				Spacer()
				
				// MARK: - FOOTER
				
				ZStack {
					// PARTS OF THE CUSTOM BUTTON
					
					// 1. BACKGROUND (STATIC)
					
					Capsule()
						.fill(Color.white.opacity(0.2))
					
					Capsule()
						.fill(Color.white.opacity(0.2))
						.padding(8)
					
					// 2. CALL-TO-ACTION (STATIC)
					
					Text("Get started")
						.font(.system(.title3, design: .rounded))
						.fontWeight(.bold)
						.foregroundStyle(Color.white)
						.offset(x: 20)
					
					// 3. CAPSULE (DYNAMIC WIDTH)
					
					HStack {
						Capsule()
							.fill(Color("ColorRed"))
							.frame(width: buttonOfsset + 80)
							
						Spacer()
					}
					
					// 4. CIRCLE (DRAGGABLE)
					
					HStack {
						ZStack {
							Circle()
								.fill(Color("ColorRed"))
							
							Circle()
								.fill(.black.opacity(0.15))
								.padding(8)
							
							Image(systemName: "chevron.right.2")
								.font(.system(size: 24, weight: .bold))
						}
						.foregroundStyle(Color(.white))
						.frame(width: 80, height: 80, alignment: .center)
						.offset(x: buttonOfsset)
						.gesture(
							DragGesture()
								.onChanged { gesture in
									if gesture.translation.width > 0 && buttonOfsset <= buttonWidth - 80 {
										buttonOfsset = gesture.translation.width
									}
								}
								.onEnded { _ in
									withAnimation(Animation.easeOut(duration: 0.4)) {
										if buttonOfsset > buttonWidth / 2 {
											hapticFeedback.notificationOccurred(.success)
											playSound(sound: "chimeup", type: "mp3")
											buttonOfsset = buttonWidth - 80
											isOnboardingViewActive = false
										} else {
											buttonOfsset = 0
											hapticFeedback.notificationOccurred(.warning)
										}
									}
								}
						) //: GESTURE
						
						
						Spacer()
					} //: HSTACK
				} //: FOOTER
				.frame(width: buttonWidth, height: 80, alignment: .center)
				.padding()
				.opacity(isAnimating ? 1 : 0)
				.offset(y: isAnimating ? 0 : 40)
				.animation(.easeOut(duration: 1), value: isAnimating)
				
			} //: VSTACK
		} //: ZSTACK
		.onAppear(perform: {
			isAnimating = true
		})
		.preferredColorScheme(.dark)
    }
}

#Preview {
    OnboardingView()
}
