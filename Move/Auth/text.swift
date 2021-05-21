//
//  text.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import SwiftUI
import Introspect

struct text: View {
	@State var text1: String = ""
	@State var text1Placeholder: String = "email"
	@State var text2: String = ""
	@State var index: Int = 0
    var body: some View {
		VStack {
			TextField(self.$text1Placeholder.wrappedValue, text: $text1, onEditingChanged: { (isEditing) in
				if isEditing {
					self.$text1Placeholder.wrappedValue = self.$text1.wrappedValue
					self.$text1.wrappedValue = ""
				} else {
				}
			}, onCommit: {
				index += 1
				print(index)
				
			})
			.introspectTextField { textfield in
				if index == 0 {
					textfield.becomeFirstResponder()
				}
			}
			TextField("password", text: $text2)
			.introspectTextField { textfield in
				if index == 1 {
					textfield.becomeFirstResponder()
				}
			}
		}
		.frame(width: 300, height: 50)
		.background(Color.fadePurple)
    }
}

struct SetFirstResponder: ViewModifier {
	@State var isFirstResponder = false
	
	func body(content: Content) -> some View {
		content
			.introspectTextField { textfield in
				if !self.isFirstResponder {
					textfield.becomeFirstResponder()
					self.isFirstResponder = true
				}
			}
	}
}

struct text_Previews: PreviewProvider {
    static var previews: some View {
        text()
    }
}
