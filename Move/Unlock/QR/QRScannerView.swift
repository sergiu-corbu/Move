//
//  QRScannerView.swift
//  Move
//
//  Created by Sergiu Corbu on 19.05.2021.
//

import SwiftUI
import UIKit
import AVFoundation

struct QRScannerView: UIViewRepresentable {
    
	var supportedBarcodeTypes: [AVMetadataObject.ObjectType] = [.qr]
	typealias UIViewType = QRCameraPreview
	
	private let session = AVCaptureSession()
	private let delegate = QRCameraDelegate()
	private let metadataOutput = AVCaptureMetadataOutput()
	
	
	func codeFound(callback: @escaping(String) -> Void) -> QRScannerView {
		delegate.resultCompletion = callback
		return self
	}
	
	func setupCamera(_ uiView: QRCameraPreview) {
		if let backCamera = AVCaptureDevice.default(for: AVMediaType.video) {
			if let input = try? AVCaptureDeviceInput(device: backCamera) {
				session.sessionPreset = .photo
				
				if session.canAddInput(input) {
					session.addInput(input)
				}
				
				if session.canAddOutput(metadataOutput) {
					session.addOutput(metadataOutput)
					
					metadataOutput.metadataObjectTypes = supportedBarcodeTypes
					metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
				}
				let previewLayer = AVCaptureVideoPreviewLayer(session: session)
				
				uiView.backgroundColor = UIColor.gray
				previewLayer.videoGravity = .resizeAspectFill
				uiView.layer.addSublayer(previewLayer)
				uiView.previewLayer = previewLayer
				
				session.startRunning()
			}
		}
	}
	
	func makeUIView(context: Context) -> QRCameraPreview {
		let cameraView = QRCameraPreview(session: session)
		checkCameraAuthorizationStatus(cameraView)
		
		
		return cameraView
	}
	
	private func checkCameraAuthorizationStatus(_ uiView: QRCameraPreview) {
		let status = AVCaptureDevice.authorizationStatus(for: .video)
		if status == .authorized {
			setupCamera(uiView)
		} else {
			AVCaptureDevice.requestAccess(for: .video) { granted in
				DispatchQueue.main.async {
					if granted {
						self.setupCamera(uiView)
					}
				}
			}
		}
	}
	
	func updateUIView(_ uiView: QRCameraPreview, context: Context) {
		uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
		uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
	}
	
}

struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView()
    }
}
