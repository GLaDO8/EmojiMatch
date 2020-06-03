//
//  Array+Only.swift
//  flippyCards
//
//  Created by shreyas gupta on 02/06/20.
//  Copyright © 2020 shreyas gupta. All rights reserved.
//

import Foundation

extension Array{
    var only: Element?{
        return self.count == 1 ? self.first : nil
    }
}

