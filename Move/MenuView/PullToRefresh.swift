//
//  PullToRefresh.swift
//  Move
//
//  Created by Sergiu Corbu on 06.05.2021.
//

import SwiftUI

struct PullToRefresh: View {
	
	var coordinateSpaceName: String
	var onRefresh: ()->Void
	
	@State var needRefresh: Bool = false
	
	var body: some View {
		GeometryReader { geo in
			if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
				Spacer()
					.onAppear { needRefresh = true }
			} else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
				Spacer()
					.onAppear {
						if needRefresh {
							needRefresh = false
							onRefresh()
						}
					}
			}
			HStack {
				Spacer()
				if needRefresh {
					ProgressView()
				} else {
					Text("⬇️")
				}
				Spacer()
			}
		}.padding(.top, -50)
	}
}

struct Content: View {
	var body: some View {
		ScrollView {
			PullToRefresh(coordinateSpaceName: "pullToRefresh") {
				// do your stuff when pulled
			}
			
			Text("Some view...")
		}.coordinateSpace(name: "pullToRefresh")
	}
}

struct PullToRefresh_Previews: PreviewProvider {
    static var previews: some View {
       Content()
    }
}
