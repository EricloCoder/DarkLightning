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

internal final class OpeningDevicePort: WriteStream {
	private let origin: WriteStream
	private let port: UInt16
	private let queue: DispatchQueue
	private let connections: Connections
	private let socket: Memory<CFSocketNativeHandle>
	
	// MARK: Init
    
	internal required init(origin: WriteStream, port: UInt16, queue: DispatchQueue, connections: Connections, socket: Memory<CFSocketNativeHandle>) {
        self.origin = origin
		self.port = port
		self.queue = queue
		self.connections = connections
		self.socket = socket
    }
	
	// MARK: Private
	
	private func context() -> CFSocketContext {
		var context = CFSocketContext()
		context.info = Unmanaged<OpeningDevicePort>.passUnretained(self).toOpaque()
		return context
	}
	
	private func socket(context: CFSocketContext) -> CFSocket {
		var aContext = context
		return CFSocketCreate(
			kCFAllocatorDefault,
			PF_INET,
			SOCK_STREAM,
			IPPROTO_TCP,
			CFSocketCallBackType.acceptCallBack.rawValue,
			{ (socket: CFSocket?, callbackType: CFSocketCallBackType, address: CFData?, data: UnsafeRawPointer?, info: UnsafeMutableRawPointer?) -> Swift.Void in
				let devicePort = Unmanaged<OpeningDevicePort>.fromOpaque(info!).takeUnretainedValue()
				let theSocket = data!.load(as: CFSocketNativeHandle.self)
				devicePort.connections.removeAll()
				devicePort.connections.insert(address: address! as Data, socket: theSocket)
			},
			&aContext
		)
	}
	
    // MARK: WriteStream
	
	public func open() {
		if socket.rawValue == -1 {
			let socket = self.socket(context: context())
			CFSocketSetReuseFlags(socket: socket)
			CFSocketConfigureAddress(socket: socket, address: INADDR_LOOPBACK, port: port)
			let socketSource = CFSocketCreateRunLoopSource(kCFAllocatorDefault, socket, 0)
			queue.sync {
				CFRunLoopAddSource(RunLoop.current.getCFRunLoop(), socketSource!, CFRunLoopMode.defaultMode)
			}
			queue.async {
				RunLoop.current.run()
			}
			self.socket.rawValue = CFSocketGetNative(socket)
		}
		else {
			origin.open()
		}
	}
	
	public func close() {
		origin.close()
	}
	
	public func write(data: Data) {
		origin.write(data: data)
	}
}
