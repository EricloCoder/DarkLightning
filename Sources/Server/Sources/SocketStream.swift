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

internal final class SocketStream: WriteStream {
	private let readReaction: StreamDelegate
	private let writeReaction: StreamDelegate
	private let inputStream: InputStream
	private let outputStream: OutputStream
	private let runLoop: RunLoop
	
	// MARK: Init
    
	internal convenience init(socket: CFSocketNativeHandle, readReaction: StreamDelegate, writeReaction: StreamDelegate, runLoop: RunLoop) {
		var inputStream: Unmanaged<CFReadStream>? = nil
		var outputStream: Unmanaged<CFWriteStream>? = nil
		CFStreamCreatePairWithSocket(
			kCFAllocatorDefault,
			socket,
			&inputStream,
			&outputStream
		)
		CFReadStreamSetProperty(
			inputStream!.takeUnretainedValue(),
			CFStreamPropertyKey(
				rawValue: kCFStreamPropertyShouldCloseNativeSocket
			),
			kCFBooleanTrue
		)
		CFWriteStreamSetProperty(
			outputStream!.takeUnretainedValue(),
			CFStreamPropertyKey(
				rawValue: kCFStreamPropertyShouldCloseNativeSocket
			),
			kCFBooleanTrue
		)
		self.init(inputStream: inputStream!.takeRetainedValue() as CFReadStream, outputStream: outputStream!.takeRetainedValue() as CFWriteStream, readReaction: readReaction, writeReaction: writeReaction, runLoop: runLoop)
    }
	
	internal required init(inputStream: InputStream, outputStream: OutputStream, readReaction: StreamDelegate, writeReaction: StreamDelegate, runLoop: RunLoop) {
		self.inputStream = inputStream
		self.outputStream = outputStream
		self.readReaction = readReaction
		self.writeReaction = writeReaction
		self.runLoop = runLoop
	}
	
	// MARK: Internal
	
	deinit {
		close()
	}
    
    // MARK: WriteStream
	
	func open() {
		self.inputStream.schedule(in: runLoop, forMode: RunLoopMode.defaultRunLoopMode)
		self.outputStream.schedule(in: runLoop, forMode: RunLoopMode.defaultRunLoopMode)
		self.inputStream.delegate = self.readReaction
		self.outputStream.delegate = self.writeReaction
		self.inputStream.open()
		self.outputStream.open()
	}
	
	func close() {
		if inputStream.streamStatus != .closed {
			inputStream.close()
		}
		if outputStream.streamStatus != .closed {
			outputStream.close()
		}
	}
	
	func write(data: Data) {
		if data.count > 0 {
			let bytes = [UInt8](data)
			var bytesWritten = outputStream.write(bytes, maxLength: data.count)
			while bytesWritten > 0 && bytesWritten != data.count {
				autoreleasepool {
					let subData = [UInt8](data.subdata(in: bytesWritten..<data.count-bytesWritten))
					bytesWritten += outputStream.write(subData, maxLength:subData.count)
				}
			}
		}
	}
}