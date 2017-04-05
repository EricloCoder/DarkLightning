//
//  USBDaemon.swift
//  DarkLightning
//
//  Created by Jens Meder on 27/03/17.
//
//

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
                                                    path: USBDaemon.USBMuxDPath
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
                                                path: USBDaemon.USBMuxDPath
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
