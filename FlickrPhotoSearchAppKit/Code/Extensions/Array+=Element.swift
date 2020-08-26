//
//  Array+=Element.swift
//  ares
//
//  Created by Matthias Wagner on 20.02.20.
//  Copyright © 2020 Michael Wagner. All rights reserved.
//

import Foundation

extension Array {

    static public func +=( left: inout Array, right: Element) {
        left += [right]
    }
}
