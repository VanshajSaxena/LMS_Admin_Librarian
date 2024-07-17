//
//  MembershipCardView.swift
//  LMSAdminLibrarian
//
//  Created by ayush yadav on 16/07/24.
//

import SwiftUI

struct MembershipCardView: View {
    @ObservedObject var viewModel: MembershipViewModel
    @State private var selectedTimeIndex = 0
    @State private var isPremium = false
    
    var filteredPlans: [Membership] {
        viewModel.membershipPlans.filter { $0.isPremium == isPremium }
    }
    
    var currentPlan: Membership {
        let index = selectedTimeIndex % filteredPlans.count
        return filteredPlans[index]
    }
    
    var body: some View {
        VStack(spacing: 0) {
            premiumHeaderView()
            
            VStack(spacing: 20) {
                paymentInfoView()
                togglePremiumView()
                payNowButton()
            }
            .padding(20)
            .background(Color.white.opacity(0.2))
            .background(VisualEffectBlur(blurStyle: .systemUltraThinMaterialLight))
            .cornerRadius(20)
            .padding([.leading, .trailing], 300)
            .offset(y: -100)
            
            VStack(alignment: .leading, spacing: 15) {
                ForEach(currentPlan.perks, id: \.self) { perk in
                    FeatureRow(text: perk)
                }
            }
            .padding(20)
            .padding(.trailing, 440)
            .background(Color.white)
            .offset(y: -120)
        }
        .padding(.bottom, -120)
        .background(Color.white)
        .cornerRadius(20)
        .padding()
    }
    
    @ViewBuilder
    private func premiumHeaderView() -> some View {
        VStack(alignment: .center, spacing: 10) {
            Text("Unlock More with Premium")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Join the premium subscription to avail new and exciting features that would enhance your experience!")
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .padding(.bottom, 100)
        .padding(.top, 30)
        .background(Color.themeOrange)
        .cornerRadius(20)
    }
    
    private func paymentInfoView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("You'll Pay")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(currentPlan.price)")
                    .font(.system(size: 40, weight: .bold))
                Text("/ \(currentPlan.duration == 1 ? "month" : "\(currentPlan.duration) months")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Picker("Duration", selection: $selectedTimeIndex) {
                ForEach(0..<filteredPlans.count, id: \.self) { index in
                    Text("\(filteredPlans[index].duration) \(filteredPlans[index].duration == 1 ? "month" : "months")")
                }
            }
            .pickerStyle(MenuPickerStyle())
            .background(Color.white.opacity(0.2))
            .cornerRadius(8)
        }
    }
    
    private func togglePremiumView() -> some View {
        Toggle(isOn: $isPremium) {
            Text("Premium Plan")
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .tint(.themeOrange)
        .onChange(of: isPremium) {
            selectedTimeIndex = 0
        }
    }
    
    private func payNowButton() -> some View {
        Button(action: {
            // Action for Pay Now
        }) {
            Text("Pay Now")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.black)
                .cornerRadius(8)
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

struct FeatureRow: View {
    let text: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
        }
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}


//struct MembershipCardView_Previews: PreviewProvider {
//    static var previews: some View {
//    }
//}

