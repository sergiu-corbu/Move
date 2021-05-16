//
//  StopWatch.swift
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
    var isRunning: Bool = false
	var tripTime: String = "00:00"
	
	init() {
		self.startTimer()
	}
	
    func startTimer() {
        isRunning = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			if self.isRunning {
				self.stopWatch.time += 1
				self.tripTime = StopWatchViewModel.convertCountToTimeString(counter: self.stopWatch.time)
				self.startTimer()
			}
		}
	}
}

extension StopWatchViewModel {
	static func convertCountToTimeString(counter: Int) -> String {
		var seconds = counter
		let minutes = seconds / 60
		
		var secondsString = "\(seconds)"
		var minutesString = "\(minutes)"
		if counter == 60 { seconds = 1}
		if seconds < 10 { secondsString = "0" + secondsString }
		if minutes < 60 { minutesString = "0" + minutesString }
		
		return "\(minutesString):\(secondsString)"
	}
}
