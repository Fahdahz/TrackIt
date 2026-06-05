//
//  Font+NewYork.swift
//  HabitApp
//
//  Created by Fahdah Alsamari on 17/12/1447 AH.
//

import SwiftUI

extension Font {

    static func nyBold(
        _ size: CGFloat
    ) -> Font {

        .custom(
            "NewYork-Bold",
            size: size
        )
    }

    static func nyRegular(
        _ size: CGFloat
    ) -> Font {

        .custom(
            "NewYork-Regular",
            size: size
        )
    }
}
