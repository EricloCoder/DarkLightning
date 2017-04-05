//
//  DictionaryReference.swift
//  DarkLightning
//
//  Created by Jens Meder on 04/04/17.
//
//

import Foundation

public final class DictionaryReference<K:Hashable, T> {
	private var dictionary: [K: T]
	
	// MARK: Init
	
	public convenience init() {
		self.init(dictionary: [:])
	}
	
    public required init(dictionary: [K: T]) {
        self.dictionary = dictionary
    }
    
    // MARK: Public
	
	public subscript(key: K) -> T? {
		get {
			return dictionary[key]
		}
		set {
			dictionary[key] = newValue
		}
	}
    
    public func removeAll() {
        dictionary.removeAll()
    }
    
    public var isEmpty: Bool {
        return dictionary.isEmpty
    }
    
    public var values: LazyMapCollection<Dictionary<K, T>, T> {
        return dictionary.values
    }
}
