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
	
	// MARK: Init
    
    public convenience init(deviceID: Int, dictionary: DictionaryReference<Int, Data>, port: UInt32, path: String) {
        self.init(
            deviceID: deviceID,
            dictionary: dictionary,
            daemon: USBDaemon(
                socket: Memory<CFSocketNativeHandle>(initialValue: CFSocketInvalidHandle),
                path: path,
                queue: DispatchQueue.global(qos: .background),
                stream: Memory<DataStream?>(initialValue: nil),
                closure: { (handle: Memory<CFSocketNativeHandle>) -> (DataStream) in
                    let state = Memory<Int>(initialValue: 0)
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
                                            return ResultMessage(
                                                origin: USBMuxMessageFake(),
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
                                        outputStream: outputStream!.takeRetainedValue() as OutputStream
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
                }
            )
        )
    }
    
    public required init(deviceID: Int, dictionary: DictionaryReference<Int, Data>, daemon: Daemon) {
        self.deviceID = deviceID
		self.dictionary = dictionary
        self.daemon = daemon
    }
    
    // MARK: CustomStringConvertible
	
	public func connect() {
		daemon.start()
	}
	
	public func disconnect() {
		daemon.stop()
	}
	
	public func writeData(data: Data) {
		
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
