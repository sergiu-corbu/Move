//
//  SNUnlock.swift
//  Move
//
//  Created by Sergiu Corbu on 27.04.2021.
//

import SwiftUI
import Introspect

struct SNUnlock: View {
    @ObservedObject var unlockViewModel: UnlockViewModel = UnlockViewModel()
    let action:() -> Void
    //let onCompleted: (String) -> Void
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            NavigationBar(title: "Enter serial number", color: .white, avatar: nil, flashLight: false, backButton: "close", action: { action() })
                .padding(.horizontal, 24)
            title
            subtitle.padding(.bottom, 100)
            digitRow
            unlockOptions
        }
        .background(
            Image("rect-background-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
    var title: some View {
        Text("Enter the scooter's\nserial number")
            .font(.custom(FontManager.Primary.bold, size: 32))
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 20)
            .padding(.top, 55)
    }
    var subtitle: some View {
        Text("You can find it on the\nscooter's front panel")
            .font(.custom(FontManager.Primary.medium, size: 16))
            .foregroundColor(.white)
            .opacity(0.6)
            .multilineTextAlignment(.center)
            .lineSpacing(5)
    }
    
    var digitRow: some View {
        HStack {
           // ForEach(0..<4) { index in
             //   DigitField(unlockViewModel: unlockViewModel, index: index)
            //}
        }
    }
    var unlockOptions: some View {
		ScooterElements.UnlockRow(unlockButton1: UnlockOptionButton(text: "QR", action: {print(unlockViewModel.unlockCode)}), unlockButton2: UnlockOptionButton(text: "NFC", action: {})).padding(.top, 100)
    }
}
/*
struct DigitField: View {
    
    @ObservedObject var unlockViewModel: UnlockViewModel
    var index: Int
    
    var body: some View {
        
        TextField("", text: $unlockViewModel.digits[index])
            .keyboardType(.numberPad)
            .frame(width: 52, height: 52)
           // .background(activeField ? Color.white : Color.fadePurple)
            .background(Color.fadePurple)
            .accentColor(.black)
            .multilineTextAlignment(.center)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .padding(.horizontal, 5)
       
            /*.introspectTextField { textfield in
                if !unlockViewModel.enteredDigit && index == 0 {
                    textfield.becomeFirstResponder()
                } else {
                    unlockViewModel.unlockCode += unlockViewModel.digit
                    textfield.resignFirstResponder() }
            }*/
    }
}
*/

struct SNUnlock_Previews: PreviewProvider {
    static var previews: some View {
        SNUnlock( action: {})
    }
}
