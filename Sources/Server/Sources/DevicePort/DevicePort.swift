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
import CoreFoundation

public final class DevicePort: PortWrap {
	
	// MARK: Constants
	
	private static let DefaultPort: UInt16 = 2347
	
	// MARK: Init
	
	public convenience init() {
		self.init(
			delegate: PortDelegateFake(),
			dataDelegate: DataDecodingFake()
		)
	}
	
	public convenience init(delegate: PortDelegate, dataDelegate: DataDecoding) {
		self.init(
			port: DevicePort.DefaultPort,
			delegate: delegate,
			dataDelegate: dataDelegate
		)
	}
	
	public convenience init(port: UInt16, delegate: PortDelegate, dataDelegate: DataDecoding) {
        let handle = Memory<CFSocketNativeHandle>(initialValue: -1)
        let queue = DispatchQueue.global(qos: .background)
        let data = DictionaryReference<Data, DataStream>()
        let connections = SocketConnections(
            queue: DispatchQueue.global(qos: .background),
            readReaction: StreamDelegates(
                delegates: [
                    ReadStreamReaction(
                        delegate: dataDelegate,
                        mapping: { (data: Data) -> (OODataArray) in
                            return OODataArrayFake()
                        }
                    ),
                    CloseStreamReaction(),
                    DisconnectStreamReaction(
                        delegate: delegate,
                        port: DevicePort(
                            port: port,
                            queue: queue,
                            connections: SocketConnections(
                                queue: queue,
                                readReaction: StreamDelegates(),
                                writeReaction: StreamDelegates(),
                                connections: data
                            ),
                            socket: handle
                        )
                    )
                ]
            ),
            writeReaction: CloseStreamReaction(),
            connections: data
        )
		self.init(
			port: port,
			queue: queue,
            connections: InsertConnectionReaction(
                origin: connections,
                delegate: delegate,
                port: DevicePort(
                    port: port,
                    queue: queue,
                    connections: connections,
                    socket: handle
                )
            ),
			socket: handle
		)
	}
	
    public required init(port: UInt16, queue: DispatchQueue, connections: Connections, socket: Memory<CFSocketNativeHandle>) {
		super.init(
			origin: OpeningDevicePort(
				origin: ClosingDevicePort(
					origin: WritingDevicePort(
						origin: PortFake(),
						stream: Memory<WriteStream?>(initialValue: nil)
					),
					socket: socket,
					connections: connections
				),
				port: port,
				queue: queue,
				connections: connections,
				socket: socket
			)
		)
    }
}
