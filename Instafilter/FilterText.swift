//
//  FilterText.swift
//  Instafilter
//
//  Created by Даниил Сивожелезов on 07.12.2024.
//

import SwiftUI

struct FilterText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .frame(maxWidth: 70)
            .multilineTextAlignment(.leading)
    }
}
