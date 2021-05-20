//
//  text.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import SwiftUI
import Introspect

struct text: View {
	@State var text: String = ""
	@State var isEditing: Bool = false
	
    var body: some View {
		TextField("Email", text: $text) { isEditing in
			self.isEditing = isEditing
		} onCommit: {
			self.isEditing = false
		}
		.introspectTextField { textfield in
			if isEditing {
			
			}
		}
    }
}

struct text_Previews: PreviewProvider {
    static var previews: some View {
        text()
    }
}
