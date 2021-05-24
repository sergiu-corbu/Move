//
//  StopWatchViewModel.swift
//  Move
//
//  Created by Sergiu Corbu on 06.05.2021.
//
import Foundation

struct StopWatch {
	var time: Int = 0
}

class StopWatchViewModel: ObservableObject {
	
    @Published var stopWatch: StopWatch = StopWatch()
	@Published var tripTime: String = ""
    var isRunning: Bool = false
	
    func startTimer() {
        isRunning = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			if self.isRunning {
				self.stopWatch.time += 1
				self.tripTime = convertTime(time: self.stopWatch.time)
				self.startTimer()
			}
		}
	}
	
	func resetTimer() {
		isRunning = false
		tripTime = ""
		stopWatch.time = 0
	}
}
