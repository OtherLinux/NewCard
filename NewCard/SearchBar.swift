//
//  SearchBar.swift
//  NewCard
//
//  Created by Marek Polame on 14.06.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchedTerm: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color(.systemGray2))
                .padding(.leading, 5)
            TextField("Search...", text: $searchedTerm)
        }
        .padding(.vertical,8)
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .ignoresSafeArea()
    }
}
