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
    
	internal required init(plist: [String: Any]) {
        super.init(
			origin: AttachMessage(
				origin: DetachMessage(
					origin: ResultMessage(
						origin: USBMuxMessageFake(),
						plist: plist
					),
					plist: plist
				),
				plist: plist
			)
		)
    }
}
