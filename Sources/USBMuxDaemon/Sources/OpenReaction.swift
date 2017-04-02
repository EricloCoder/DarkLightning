//
//  OpenReaction.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

internal final class OpenReaction: NSObject, StreamDelegate {
	private let state: Memory<Int>
	private let outputStream: WriteStream
	private let message: OOData
	
	// MARK: Init
	
	internal convenience init(state: Memory<Int>, outputStream: WriteStream) {
		self.init(
			state: state,
			outputStream: outputStream,
			message: ListeningMessageData()
		)
	}
	
	internal required init(state: Memory<Int>, outputStream: WriteStream, message: OOData) {
		self.state = state
		self.outputStream = outputStream
		self.message = message
    }
    
    // MARK: StreamDelegate
	
	func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
		if eventCode == .hasSpaceAvailable && state.rawValue == 0 {
			state.rawValue = 1
			outputStream.write(data: message.rawValue)
		}
	}
}
