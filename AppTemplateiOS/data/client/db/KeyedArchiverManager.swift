//
//  KeyedArchiverManager.swift
//  AppTemplateiOS
//
//  Created by Junio Moquiuti on 27/03/20.
//  Copyright © 2020 Junio Moquiuti. All rights reserved.
//

import Foundation

final class KeyedArchiverManager {
    
    static func saveObjectWith(key: String, object: NSObject?) {
        let data: Data?
        if let object = object {
            data = NSKeyedArchiver.archivedData(withRootObject: object) as Data?
        } else {
            data = nil
        }
        
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func retrieveObjectWith<T: NSObject>(key: String, type: T.Type) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data,
            let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? T else {
                return nil
        }
        
        return object
    }
}
