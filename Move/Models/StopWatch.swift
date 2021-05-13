//
//  StopWatch.swift
//  Move
//
//  Created by Sergiu Corbu on 06.05.2021.
//

import Foundation

class StopWatch: ObservableObject {
	private var sourceTimer: DispatchSourceTimer?
	private let queue = DispatchQueue(label: "stopwatch.timer")
	private var counter: Int = 0
	
	var stopWatchTime = "00:00" {
		didSet { self.update() }
	}
	
	func start() {
		guard let _ = self.sourceTimer else { self.startTimer() ;return }
		self.resumeTimer()
	}
	
	func reset() {
		self.stopWatchTime = "00:00"
		self.counter = 0
	}
	
	func update() {
		objectWillChange.send()
	}
	
	private func startTimer() {
		self.sourceTimer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: self.queue)
		self.resumeTimer()
	}
	
	private func resumeTimer() {
		self.sourceTimer?.setEventHandler { self.updateTimer() }
		self.sourceTimer?.schedule(deadline: .now(), repeating: 0.01)
		self.sourceTimer?.resume()
	}
	
	func stop() {
		self.sourceTimer?.suspend()
		self.reset()
	}
	
	private func updateTimer() {
		self.counter += 1
		DispatchQueue.main.async { self.stopWatchTime = StopWatch.convertCountToTimeString(counter: self.counter) }
	}
}

extension StopWatch {
	static func convertCountToTimeString(counter: Int) -> String {
		let seconds = counter / 100
		let minutes = seconds / 60

		var secondsString = "\(seconds)"
		var minutesString = "\(minutes)"
		
		if seconds < 10 { secondsString = "0" + secondsString }
		if minutes < 10 { minutesString = "0" + minutesString }
		return "\(minutesString):\(secondsString)"
	}
}
