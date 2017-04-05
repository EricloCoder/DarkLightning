//
//  USBDevice.swift
//  DarkLightning
//
//  Created by Jens Meder on 04/04/17.
//
//

import Foundation

public final class USBDevice: Device, CustomStringConvertible {
	private let dictionary: DictionaryReference<Int, Data>
	private let deviceID: Int
    private let daemon: Daemon
    private let stream: WriteStream
	
	// MARK: Init
    
    public convenience init(deviceID: Int, dictionary: DictionaryReference<Int, Data>, port: UInt32, path: String) {
        let handle = Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle)
        let state = Memory<Int>(initialValue: 0)
        let inputStream = Memory<InputStream?>(initialValue: nil)
        let outputStream = Memory<OutputStream?>(initialValue: nil)
        self.init(
            deviceID: deviceID,
            dictionary: dictionary,
            daemon: USBDaemon(
                socket: handle,
                path: path,
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
                                        return ResultMessage(
                                            plist: plist
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
            )
        )
    }
    
    public required init(deviceID: Int, dictionary: DictionaryReference<Int, Data>, daemon: Daemon, stream: WriteStream) {
        self.deviceID = deviceID
		self.dictionary = dictionary
        self.daemon = daemon
        self.stream = stream
    }
    
    // MARK: CustomStringConvertible
	
	public func connect() {
		daemon.start()
	}
	
	public func disconnect() {
		daemon.stop()
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
