//
//  QRCameraPreview.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import Foundation
import UIKit
import AVFoundation

class QRCameraPreview: UIView {
	
	private var label: UILabel?
	
	var previewLayer: AVCaptureVideoPreviewLayer?
	var session = AVCaptureSession()
	weak var delegate: QRCameraDelegate?
	
	init(session: AVCaptureSession) {
		super.init(frame: .zero)
		self.session = session
	}
	
	required init?(coder: NSCoder) {
		fatalError("init has not been implemented")
	}
	
	func createSimulatorView(delegate: QRCameraDelegate) {
		self.delegate = delegate
		self.backgroundColor = UIColor.black
		label = UILabel(frame: self.bounds)
		label?.numberOfLines = 4
		label?.text = "Click here to simulate scan"
		label?.textColor = .white
		label?.textAlignment = .center
		if let label = label {
			addSubview(label)
		}
		let gesture = UITapGestureRecognizer(target: self, action: #selector(onClick))
		self.addGestureRecognizer(gesture)
	}
	
	@objc func onClick() {
		delegate?.onSimulateScanning()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		previewLayer?.frame = self.bounds
	}
	
}
