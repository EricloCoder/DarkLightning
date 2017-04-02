//
//  USBDaemon.swift
//  DarkLightning
//
//  Created by Jens Meder on 27/03/17.
//
//

import Foundation
import CoreFoundation

public final class USBDaemon: Daemon {
	private let handle: Memory<CFSocketNativeHandle>
	private let path: String
	private let queue: DispatchQueue
	private let closure: (Memory<CFSocketNativeHandle>, RunLoop) -> (WriteStream)
	private var stream: WriteStream?
	
	// MARK: Init
	
	public convenience init() {
		self.init(
			socket: Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle),
			path: "/var/run/usbmuxd",
			queue: DispatchQueue.global(qos: .background),
			closure: { (handle: Memory<CFSocketNativeHandle>, runLoop: RunLoop) -> (WriteStream) in
				var inputStream: Unmanaged<CFReadStream>? = nil
				var outputStream: Unmanaged<CFWriteStream>? = nil
				CFStreamCreatePairWithSocket(
					kCFAllocatorDefault,
					handle.rawValue,
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
				let state = Memory<Int>(initialValue: 0)
				return SocketStream(
					inputStream: inputStream?.takeRetainedValue() as! InputStream,
					outputStream: outputStream?.takeRetainedValue() as! OutputStream,
					readReaction: StreamDelegates(
						delegates: [
							ReadStreamReaction(
								delegate: ReceivingDataReaction(
									mapping: { (plist: [String : Any]) -> (USBMuxMessage) in
										return USBMuxProtocol(plist: plist)
									}
								),
								mapping: { (data: Data) -> (OOData) in
									return USBMuxMessageData(origin: data)
								}
							),
							CloseStreamReaction(),
							DisconnectReaction(
								handle: handle,
								state: state
							)
						]
					),
					writeReaction: StreamDelegates(
						delegates: [
							OpenReaction(
								state: state,
								outputStream: SocketStream(
									inputStream: inputStream?.takeRetainedValue() as! InputStream,
									outputStream: outputStream?.takeRetainedValue() as! OutputStream,
									readReaction: StreamDelegates(),
									writeReaction: StreamDelegates(),
									runLoop: RunLoop.current
								)
							),
							CloseStreamReaction(),
						]
					),
					runLoop: runLoop
				)
			}
		)
	}
	
	public required init(socket: Memory<CFSocketNativeHandle>, path: String, queue: DispatchQueue, closure: @escaping (Memory<CFSocketNativeHandle>, RunLoop) -> (WriteStream)) {
        self.handle = socket
		self.path = path
		self.queue = queue
		self.closure = closure
    }
	
	// MARK: Internal
	
	private func addr() -> sockaddr_un {
		let length = path.withCString { Int(strlen($0)) }
		var addr: sockaddr_un = sockaddr_un()
		addr.sun_family = sa_family_t(AF_UNIX)
		_ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
			path.withCString {
				strncpy(ptr, $0, length)
			}
		}
		return addr
	}
	
	private func configure(socketHandle: CFSocketNativeHandle) {
		var on: Int = Int(true)
		setsockopt(socketHandle, SOL_SOCKET, SO_NOSIGPIPE, &on, socklen_t(MemoryLayout<Int>.size))
		setsockopt(socketHandle, SOL_SOCKET, SO_REUSEADDR, &on, socklen_t(MemoryLayout<Int>.size))
		setsockopt(socketHandle, SOL_SOCKET, SO_REUSEPORT, &on, socklen_t(MemoryLayout<Int>.size))
	}
	
	private func openStreams() {
		queue.sync {
			stream = closure(handle, RunLoop.current)
			stream?.open()
		}
		queue.async {
			RunLoop.current.run()
		}
	}
	
    // MARK: WriteStream
	
	public func start() {
		if handle.rawValue == CFSocketInvalidHandle {
			let socketHandle = socket(AF_UNIX, SOCK_STREAM, 0)
			if socketHandle != CFSocketInvalidHandle {
				configure(socketHandle: socketHandle)
				var addr = self.addr()
				let result = withUnsafeMutablePointer(to: &addr) {
					$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
						connect(socketHandle, $0, socklen_t(MemoryLayout.size(ofValue: addr)))
					}
				}
				if result != -1 {
					handle.rawValue = socketHandle
					openStreams()
					
				}
			}
		}
	}
	
	public func stop() {
		if handle.rawValue != CFSocketInvalidHandle {
			stream?.close()
			stream = nil
		}
	}
}
