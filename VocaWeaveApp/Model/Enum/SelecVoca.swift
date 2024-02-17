//
//  SelecVoca.swift
//  VocaWeaveApp
//
//  Created by 천광조 on 2/17/24.
//

import Foundation

enum SelecVoca {
    case myVoca
    case dicVoca
    case bookmarkVoca
    
    var tagValue: Int {
        switch self {
        case .myVoca:
            return 0
        case .dicVoca:
            return 1
        case .bookmarkVoca:
            return 2
        }
    }
}
