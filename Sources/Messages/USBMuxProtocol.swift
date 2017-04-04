//
//  USBMuxProtocol.swift
//  DarkLightning
//
//  Created by Jens Meder on 22/03/17.
//
//

import Foundation

internal final class USBMuxProtocol: USBMuxMessageWrap {

	// MARK: Init
    
	internal required init(plist: [String: Any], devices: DictionaryReference<Int, Data>, delegate: DevicesDelegate) {
        super.init(
			origin: AttachMessage(
				origin: DetachMessage(
					origin: ResultMessage(
						origin: USBMuxMessageFake(),
						plist: plist
					),
					plist: plist,
					devices: devices,
					delegate: delegate,
					closure: { (deviceID: Int, devices: DictionaryReference<Int, Data>) -> (Device) in
						return USBDevice(deviceID: deviceID, dictionary: devices)
				}
				),
				plist: plist,
				devices: devices,
				delegate: delegate,
				closure: { (deviceID: Int, devices: DictionaryReference<Int, Data>) -> (Device) in
					return USBDevice(deviceID: deviceID, dictionary: devices)
				}
			)
		)
    }
}
