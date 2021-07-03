//
//  File.swift
//  
//
//  Created by Ephraim Russo on 7/3/21.
//

import Foundation
import Bryce

struct CustomError: CodableError, Equatable {
    
    let reason: String
    let isFixable: Bool
}
