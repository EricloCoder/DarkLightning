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

internal final class ClosingDevicePort: WriteStream {
	private let origin: WriteStream
	private let socket: Memory<CFSocketNativeHandle>
	private let connections: Connections
	
	// MARK: Init
	
	internal required init(origin: WriteStream, socket: Memory<CFSocketNativeHandle>, connections: Connections) {
		self.origin = origin
		self.socket = socket
		self.connections = connections
	}
	
	// MARK: Private
	
	deinit {
		close()
	}
	
    // MARK: WriteStream
	
	public func open() {
		origin.open()
	}
	
	public func close() {
		if socket.rawValue != -1 {
			connections.removeAll()
			let socket = CFSocketCreateWithNative(kCFAllocatorDefault, self.socket.rawValue, 0, nil, nil)
			CFSocketInvalidate(socket)
			self.socket.rawValue = -1
		}
		else {
			origin.close()
		}
	}
	
	public func write(data: Data) {
		origin.write(data: data)
	}
}
