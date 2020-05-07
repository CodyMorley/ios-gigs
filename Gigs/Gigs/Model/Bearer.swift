//
//  Bearer.swift
//  Gigs
//
//  Created by Cody Morley on 5/5/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation

struct Bearer: Codable {
    var id: Int
    var token: String
    var userId: Int
}
