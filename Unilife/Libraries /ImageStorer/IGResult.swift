//
//  Result.swift
//  BubbleBud
//
//  Created by Apple on 21/08/19.
//  Copyright © 2019 Promatics. All rights reserved.
//

import Foundation

public enum IGResult<V, E> {
    case success(V)
    case failure(E)
}
