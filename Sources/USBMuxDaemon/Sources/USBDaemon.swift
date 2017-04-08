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

public final class USBDaemon: DaemonWrap {
	
    // MARK: Constants
    
    private static let USBMuxDPath = "/var/run/usbmuxd"
    private static let DefaultPort: UInt32 = 2347
    
	// MARK: Init
	
	public convenience init() {
        self.init(
            delegate: DevicesDelegateFake(),
            port: USBDaemon.DefaultPort
        )
	}
    
    public convenience init(delegate: DevicesDelegate) {
        self.init(
            delegate: delegate,
            port: USBDaemon.DefaultPort
        )
    }
	
    public convenience init(delegate: DevicesDelegate, port: UInt32) {
        let handle = Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle)
        let state = Memory<Int>(initialValue: 0)
        let devices = DictionaryReference<Int, Data>()
        let inputStream = Memory<InputStream?>(initialValue: nil)
        let outputStream = Memory<OutputStream?>(initialValue: nil)
		self.init(
			socket: handle,
			path: USBDaemon.USBMuxDPath,
			queue: DispatchQueue.global(qos: .background),
			stream: SocketStream(
                handle: handle,
                inputStream: inputStream,
                outputStream: outputStream,
                readReaction: StreamDelegates(
                    delegates: [
                        ReadStreamReaction(
                            delegate: ReceivingDataReaction(
                                mapping: { (plist: [String : Any]) -> (USBMuxMessage) in
                                    return AttachMessage(
                                        origin: DetachMessage(
                                            origin: USBMuxMessageFake(),
                                            plist: plist,
                                            devices: devices,
                                            delegate: delegate,
                                            closure: { (deviceID: Int, devices: DictionaryReference<Int, Data>) -> (Device) in
                                                return USBDevice(
                                                    deviceID: deviceID,
                                                    dictionary: devices,
                                                    port: port,
                                                    path: USBDaemon.USBMuxDPath,
                                                    delegate: delegate
                                                )
                                            }
                                        ),
                                        plist: plist,
                                        devices: devices,
                                        delegate: delegate,
                                        closure: { (deviceID: Int, devices: DictionaryReference<Int, Data>) -> (Device) in
                                            return USBDevice(
                                                deviceID: deviceID,
                                                dictionary: devices,
                                                port: port,
                                                path: USBDaemon.USBMuxDPath,
                                                delegate: DevicesDelegateFake()
                                            )
                                        }
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
                            )
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
                            outputStream: SocketWriteStream(
                                outputStream: outputStream
                            )
                        ),
                        CloseStreamReaction(),
                        ]
                )
            )
		)
	}
    
    public required init(socket: Memory<CFSocketNativeHandle>, path: String, queue: DispatchQueue, stream: DataStream) {
        super.init(
            origin: StoppingUSBDaemon(
                origin: StartingUSBDaemon(
                    socket: socket,
                    path: path,
                    queue: queue,
                    stream: stream
                ),
                handle: socket,
                stream: stream
            )
        )
    }
}
