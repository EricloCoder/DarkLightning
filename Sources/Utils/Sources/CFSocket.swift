//
//  CFSocket.swift
//  DarkLightning-Swift
//
//  Created by Jens Meder on 19/03/17.
//  Copyright © 2017 Jens Meder. All rights reserved.
//

import Foundation

internal func CFSocketSetOption(socket: CFSocket, option: Int32, aValue: Int) {
	var value = aValue
	setsockopt(
		CFSocketGetNative(socket),
		SOL_SOCKET,
		option,
		&value,
		socklen_t(MemoryLayout<Int>.size)
	)
}

internal func CFSocketConfigureAddress(socket: CFSocket, address: UInt32, port: UInt16) {
	var sin =  sockaddr_in(
		sin_len: UInt8(MemoryLayout<sockaddr_in>.size),
		sin_family: sa_family_t(AF_INET),
		sin_port: NetworkUInt16(origin: port).rawValue,
		sin_addr: in_addr(
			s_addr: NetworkUInt32(origin: address).rawValue
		),
		sin_zero: (0,0,0,0,0,0,0,0)
	)
	let sincfd = NSData(
		bytes: &sin,
		length: MemoryLayout<sockaddr_in>.size
	)
	CFSocketSetAddress(
		socket,
		sincfd
	)
}

internal func CFSocketSetReuseFlags(socket: CFSocket) {
	CFSocketSetOption(
		socket: socket,
		option: SO_REUSEADDR,
		aValue: Int(true)
	)
	CFSocketSetOption(
		socket: socket,
		option: SO_REUSEPORT,
		aValue: Int(true)
	)
}
