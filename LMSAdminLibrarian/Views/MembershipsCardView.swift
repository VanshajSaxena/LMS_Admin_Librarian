//
//  MembershipsCardView.swift
//  LMSAdminLibrarian
//
//  Created by Aida Sharon Bruce on 14/07/24.
//

import SwiftUI

struct MembershipsCardView: View {
    var body: some View {
        ZStack {
//            VStack(spacing: 20) {
//                           // Top Section
//                           VStack(spacing: 10) {
//                               Text("Unlock More with Premium")
//                                   .font(.headline)
//                                   .fontWeight(.bold)
//                                   .foregroundColor(.white)
//                               
//                               Text("Join the premium subscription to avail new and exciting features that would enhance your experience!")
//                                   .font(.subheadline)
//                                   .foregroundColor(.white)
//                                   .multilineTextAlignment(.center)
//                                   .padding(.horizontal, 20)
//                           }
//                           .frame(width: 350, height: 150)
//                           .background(Color.orange)
//                           .cornerRadius(10)
//                           
//                           // Price Section
//                           VStack {
//                               HStack {
//                                   Text("You'll Pay")
//                                       .font(.subheadline)
//                                       .foregroundColor(.gray)
//                                   
//                                   Spacer()
//                                   
//                                   Button(action: {
//                                       // Action for button
//                                   }) {
//                                       HStack {
//                                           Text("Monthly")
//                                           Image(systemName: "chevron.down")
//                                       }
//                                       .padding(10)
//                                       .background(Color.gray.opacity(0.2))
//                                       .cornerRadius(5)
//                                   }
//                               }
//                               
//                               HStack(alignment: .firstTextBaseline) {
//                                   Text("500")
//                                       .font(.system(size: 50, weight: .bold))
//                                   
//                                   Text("/ month")
//                                       .font(.title2)
//                                       .foregroundColor(.gray)
//                               }
//                               
//                               Button(action: {
//                                   // Action for button
//                               }) {
//                                   Text("Read More")
//                                       .foregroundColor(.white)
//                                       .padding()
//                                       .background(Color.black)
//                                       .cornerRadius(10)
//                               }
//                           }
//                           .padding()
//                           .frame(width: 350, height: 200)
//                           .background(LinearGradient(gradient: Gradient(colors: [Color.orange.opacity(0.5), Color.white]), startPoint: .top, endPoint: .bottom))
//                           .cornerRadius(10)
//                           .shadow(radius: 5)
//                           
//                           // Features Section
//                           VStack(alignment: .leading, spacing: 10) {
//                               HStack {
//                                   Image(systemName: "checkmark.circle")
//                                   Text("Book The Book")
//                               }
//                               HStack {
//                                   Image(systemName: "checkmark.circle")
//                                   Text("Unlimited Library Access")
//                               }
//                               HStack {
//                                   Image(systemName: "checkmark.circle")
//                                   Text("Kuch to ayega yaha")
//                               }
//                           }
//                           .padding(.horizontal, 20)
//                           .frame(width: 350)
//                       }
//                       .background(Color.white)
//                       .cornerRadius(10)
//                       .shadow(radius: 5)
                   
            Rectangle()
                .fill(Color.white)
                .cornerRadius(10)
                .frame(width: 400, height: 500)
                .overlay(
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Book The Book")
                            
                            
                        }
                        .padding()
                        .offset(x: -50, y: 200)
                        .foregroundColor(.black)
                        
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Unlimited Library Access")
                        }
                        .padding()
                        .offset(x: -50, y: 170)
                        .foregroundColor(.black)
                        
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Kuch to ayega yaha")
                        }
                        .padding()
                        .offset(x: -50, y: 140)
                        .foregroundColor(.black)
                    })
                
            
            Rectangle()
                .fill(Color.accentColor)
                .cornerRadius(10)
                .frame(width: 400, height: 240)
                .offset(y: -130)
                .shadow(radius: 8)
                .overlay(
                    Text("Unlock More with Premium")
                        .font(.headline)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, -200)
                )
                .overlay(
                    Text("Join the premium subscription to avail new and exciting features that would enhance your experience!")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.top, -160)
                        .padding()
                )
            
            
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .cornerRadius(10)
                .frame(width: 300, height: 180)
                .offset(y: 0)
                .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterialLight))
                .overlay(
                    Text("You'll pay")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .offset(x: -100, y: -30)
                )
                .overlay(
                    HStack {
                        Text("500")
                            .font(.title)
                            .bold()
                            .foregroundColor(.black)
                            .offset(x: -70, y: 0)
                        Text("/ month")
                            .font(.footnote)
                            .foregroundColor(.black)
                            .offset(x: -70, y: 0)
                    }
                    )
                .overlay(
                    Button(action: {
                        // Action for button
                    }) {
                        Text("Read More")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black)
                            .font(.footnote)
                            .cornerRadius(10)
                            .frame(width: 200, height: 100)
                            .offset(x: 80, y: 50)
                    }
                        .padding()
                )
            
        }
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
                view.layer.cornerRadius = 10
                view.clipsToBounds = true
                return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

struct MembershipsCardView_Previews: PreviewProvider {
    static var previews: some View {
        MembershipsCardView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
