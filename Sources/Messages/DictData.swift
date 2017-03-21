//
//  DictData.swift
//  DarkLightning
//
//  Created by Jens Meder on 21/03/17.
//
//

import Foundation

internal final class DictData: OOData {
	private let dict: [String: String]
	
	// MARK: Init
    
	internal required init(dict: [String: String]) {
        self.dict = dict
    }
    
    // MARK: OOData
	
	var rawValue: Data {
		var data = Data()
		do {
			try data = PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
		} catch {
			
		}
		return data
	}
}
