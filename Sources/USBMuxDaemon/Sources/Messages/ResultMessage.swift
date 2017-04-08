/**
 *
 * 	DarkLightning
 *
 *
 *
 *	The MIT License (MIT)
 *
 *	Copyright (c) 2017 Jens Meder
 *
 *	Permission is hereby granted, free of charge, to any person obtaining a copy of
 *	this software and associated documentation files (the "Software"), to deal in
 *	the Software without restriction, including without limitation the rights to
 *	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 *	the Software, and to permit persons to whom the Software is furnished to do so,
 *	subject to the following conditions:
 *
 *	The above copyright notice and this permission notice shall be included in all
 *	copies or substantial portions of the Software.
 *
 *	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *	FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *	COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *	IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

internal final class ResultMessage: USBMuxMessage {
	
	// MARK: Constants
	
	private static let MessageTypeResult = "Result"
	private static let MessageTypeKey = "MessageType"
	
	// MARK: Members
	
	private let origin: USBMuxMessage
	private let plist: [String: Any]
    private let tcpMode: Memory<Bool>
    private let delegate: DevicesDelegate
    private let device: Device
	
	// MARK: Init
	
    internal convenience init(plist: [String: Any], tcpMode: Memory<Bool>, delegate: DevicesDelegate, device: Device) {
        self.init(
            origin: USBMuxMessageFake(),
            plist: plist,
            tcpMode: tcpMode,
            delegate: delegate,
            device: device
        )
    }
    
	internal required init(origin: USBMuxMessage, plist: [String: Any], tcpMode: Memory<Bool>, delegate: DevicesDelegate, device: Device) {
		self.origin = origin
		self.plist = plist
        self.tcpMode = tcpMode
        self.delegate = delegate
        self.device = device
	}
	
	// MARK: USBMuxMessage
	
	func decode() {
		let messageType: String = plist[ResultMessage.MessageTypeKey] as! String
		if messageType == ResultMessage.MessageTypeResult {
			let number = plist["Number"] as! Int
            if number == 0 {
                tcpMode.rawValue = true
                DispatchQueue.main.async {
                    self.delegate.device(didConnect: self.device)
                }
            }
            else {
                DispatchQueue.main.async {
                    self.delegate.device(didFailToConnect: self.device)
                    self.device.disconnect()
                }
            }
		}
		else {
			origin.decode()
		}
	}
}
