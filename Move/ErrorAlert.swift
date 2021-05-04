//
//  ErrorAlert.swift
//  Move
//
//  Created by Sergiu Corbu on 03.05.2021.
//

import SwiftUI
import UIKit
import SwiftMessages

struct ErrorAlert: View {
	@State var text = NSMutableAttributedString(string: "show the error")
	
	var body: some View {
		EmptyView()
		//SwiftMessages.show(view: ErrorView(text: $text))
		//ErrorView(text: $text)
	}
}

struct ErrorAlert_Previews: PreviewProvider {
    static var previews: some View {
        ErrorAlert()
    }
}

struct ErrorView: UIViewRepresentable {
	
	@Binding var text: NSMutableAttributedString
	
	func makeUIView(context: Context) -> UITextView {
		let view = UITextView()
		
		return view
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.attributedText = text
	}
}
