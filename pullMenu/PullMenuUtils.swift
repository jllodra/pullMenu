//
//  PullMenuUtils.swift
//  pullMenu
//
//  Created by Ruben on 12/24/14.
//  Copyright (c) 2014 Ruben Nine & Josep Llodra. All rights reserved.
//

struct PullMenuUtils {
    static func mapValue(v: CGFloat, minV: CGFloat, maxV: CGFloat, outMinV: CGFloat, outMaxV: CGFloat) -> CGFloat {
        return (v - minV) * (outMaxV - outMinV) / (maxV - minV) + outMinV
    }
}
