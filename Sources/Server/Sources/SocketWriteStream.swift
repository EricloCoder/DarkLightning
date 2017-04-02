//
//  SocketWriteStream.swift
//  DarkLightning
//
//  Created by Jens Meder on 02/04/17.
//
//

import Foundation

internal final class SocketWriteStream: WriteStream {
	private let outputStream: OutputStream
	
	// MARK: Init
    
    internal required init(outputStream: OutputStream) {
        self.outputStream = outputStream
    }
    
    // MARK: WriteStream
	
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
