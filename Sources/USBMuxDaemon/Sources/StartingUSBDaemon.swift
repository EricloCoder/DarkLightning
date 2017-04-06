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

internal final class StartingUSBDaemon: Daemon {
    
    // MARK: Members
    
    private let handle: Memory<CFSocketNativeHandle>
    private let path: String
    private let queue: DispatchQueue
    private let stream: DataStream
    
    // MARK: Init
    
    public required init(socket: Memory<CFSocketNativeHandle>, path: String, queue: DispatchQueue, stream: DataStream) {
        self.handle = socket
        self.path = path
        self.queue = queue
        self.stream = stream
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
                    stream.open(in: queue)
                }
            }
        }
    }
    
    func stop() {
        
    }
}
