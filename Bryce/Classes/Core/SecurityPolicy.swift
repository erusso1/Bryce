//
//  SecurityPolicy.swift
//  Alamofire
//
//  Created by Ephraim Russo on 2/6/19.
//

import Foundation

public enum SecurityPolicy {
    
    case none
    
    case certifcatePinning(path: URL)
}

