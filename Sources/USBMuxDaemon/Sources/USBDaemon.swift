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
    
	// MARK: Init
	
	public convenience init() {
		self.init(delegate: DevicesDelegateFake())
	}
	
	public convenience init(delegate: DevicesDelegate) {
		self.init(
			socket: Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle),
			path: USBDaemon.USBMuxDPath,
			queue: DispatchQueue.global(qos: .background),
			stream: Memory<DataStream?>(initialValue: nil),
			closure: { (handle: Memory<CFSocketNativeHandle>) -> (DataStream) in
                let state = Memory<Int>(initialValue: 0)
                let devices = DictionaryReference<Int, Data>()
                var inputStream: Unmanaged<CFReadStream>? = nil
				var outputStream: Unmanaged<CFWriteStream>? = nil
				CFStreamCreatePairWithSocket(
					kCFAllocatorDefault,
					handle.rawValue,
					&inputStream,
					&outputStream
				)
				return SocketStream(
					inputStream: inputStream!.takeRetainedValue() as InputStream,
					outputStream: outputStream!.takeRetainedValue() as OutputStream,
					readReaction: StreamDelegates(
						delegates: [
							ReadStreamReaction(
								delegate: ReceivingDataReaction(
									mapping: { (plist: [String : Any]) -> (USBMuxMessage) in
										return USBMuxProtocol(
											plist: plist,
											devices: devices,
											delegate: delegate
										)
									}
								),
								mapping: { (data: Data) -> (OODataArray) in
									return USBMuxMessageDataArray(
										data: data,
										closure: { (data: Data) -> (OOData) in
											return RawData(data)
										}
									)
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
								outputStream: SocketWriteStream(
									outputStream: outputStream!.takeRetainedValue() as OutputStream
								)
							),
							CloseStreamReaction(),
						]
					)
				)
			}
		)
	}
    
    public required init(socket: Memory<CFSocketNativeHandle>, path: String, queue: DispatchQueue, stream: Memory<DataStream?>, closure: @escaping (Memory<CFSocketNativeHandle>) -> (DataStream)) {
        super.init(
            origin: StoppingUSBDaemon(
                origin: StartingUSBDaemon(
                    socket: socket,
                    path: path,
                    queue: queue,
                    stream: stream,
                    closure: closure
                ),
                handle: socket,
                stream: stream
            )
        )
    }
}
