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

public final class USBDevice: Device, CustomStringConvertible {
	private let dictionary: DictionaryReference<Int, Data>
	private let deviceID: Int
    private let daemon: Daemon
    private let stream: WriteStream
    private let delegate: DevicesDelegate
	
	// MARK: Init
    
	public convenience init(deviceID: Int, dictionary: DictionaryReference<Int, Data>, port: UInt32, path: String, delegate: DevicesDelegate) {
        let handle = Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle)
        let state = Memory<Int>(initialValue: 0)
        let inputStream = Memory<InputStream?>(initialValue: nil)
        let outputStream = Memory<OutputStream?>(initialValue: nil)
        let tcpMode = Memory<Bool>(initialValue: false)
		let queue = DispatchQueue.global(qos: .background)
        self.init(
            deviceID: deviceID,
            dictionary: dictionary,
            daemon: USBDaemon(
                socket: handle,
                path: path,
                queue: queue,
                stream: SocketStream(
                    handle: handle,
                    inputStream: inputStream,
                    outputStream: outputStream,
                    readReaction: StreamDelegates(
                        delegates: [
                            ReadStreamReaction(
                                delegate: TCPMessage(
                                    origin: ReceivingDataReaction(
                                        mapping: { (plist: [String : Any]) -> (USBMuxMessage) in
                                            return ResultMessage(
                                                plist: plist,
                                                tcpMode: tcpMode,
                                                delegate: delegate,
                                                device: USBDevice(
                                                    deviceID: deviceID,
                                                    dictionary: dictionary,
                                                    daemon: USBDaemon(
                                                        socket: handle,
                                                        path: path,
                                                        queue: queue,
                                                        stream: DataStreamFake()
                                                    ),
                                                    stream: SocketWriteStream(
                                                        outputStream: outputStream
                                                    ),
                                                    delegate: delegate
                                                )
                                            )
                                        },
                                        dataMapping: { (data: Data) -> (OODataArray) in
                                            return USBMuxMessageDataArray(
                                                data: data,
                                                closure: { (data: Data) -> (OOData) in
                                                    return RawData(data)
                                                }
                                            )
                                        }
                                    ),
                                    tcpMode: tcpMode,
                                    delegate: delegate,
                                    device: USBDevice(
										deviceID: deviceID,
										dictionary: dictionary,
										daemon: USBDaemon(
											socket: handle,
											path: path,
											queue: queue,
											stream: SocketStream(
												handle: handle,
												inputStream: inputStream,
												outputStream: outputStream
											)
										),
										stream: SocketWriteStream(
											outputStream: outputStream
										),
										delegate: delegate
									)
                                )
                            ),
                            DisconnectReaction(
                                handle: handle,
                                state: state,
                                delegate: delegate,
                                device: USBDevice(
                                    deviceID: deviceID,
                                    dictionary: dictionary,
                                    daemon: USBDaemon(
                                        socket: handle,
                                        path: path,
                                        queue: queue,
                                        stream: SocketStream(
                                            handle: handle,
                                            inputStream: inputStream,
                                            outputStream: outputStream
                                        )
                                    ),
                                    stream: SocketWriteStream(
                                        outputStream: outputStream
                                    ),
                                    delegate: delegate
                                )
                            )
                        ]
                    ),
                    writeReaction: StreamDelegates(
                        delegates: [
                            OpenReaction(
                                state: state,
                                outputStream: SocketWriteStream(
                                    outputStream: outputStream
                                ),
                                message: ConnectMessageData(
                                    deviceID: deviceID,
                                    port: port
                                )
                            ),
                            CloseStreamReaction(),
                        ]
                    )
                )
            ),
            stream: SocketWriteStream(
                outputStream: outputStream
            ),
            delegate: delegate
        )
    }
    
    public required init(deviceID: Int, dictionary: DictionaryReference<Int, Data>, daemon: Daemon, stream: WriteStream, delegate: DevicesDelegate) {
        self.deviceID = deviceID
		self.dictionary = dictionary
        self.daemon = daemon
        self.stream = stream
        self.delegate = delegate
    }
    
    // MARK: CustomStringConvertible
	
	public func connect() {
		daemon.start()
	}
	
	public func disconnect() {
		daemon.stop()
        delegate.device(didDisconnect: self)
	}
	
	public func writeData(data: Data) {
		stream.write(data: data)
	}
	
	public var description: String {
		var result = ""
		do {
			let plist: [String: Any] = try PropertyListSerialization.propertyList(from: dictionary[deviceID]!, options: PropertyListSerialization.ReadOptions.mutableContainers, format: nil) as! [String : Any]
			result = String(format: "%@", plist)
		} catch {
			
		}
		return result
	}
}
