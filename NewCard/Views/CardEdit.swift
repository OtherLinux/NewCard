//
//  CardEdit.swift
//  NewCard
//
//  Created by Marek Polame on 16.06.2025.
//

import SwiftUI

struct CardEdit: View {
    @Binding var card: Card
    @State var lastCardData: String?
    @Environment(\.dismiss) var dismiss
    @State var bgColor: Color = Color.white
    @State var textColor: Color = Color.black
    
    var types: [String] = ["barcode", "qr"]
    
    
    var body: some View {
        Form {
            HStack {
                Text("Name")
                TextField(text:$card.title, prompt: Text("Card Name")) {}
                    .autocorrectionDisabled(true)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Data")
                TextField(text:$card.data, prompt: Text("Card Data")) {}
                    .autocorrectionDisabled(true)
                    .multilineTextAlignment(.trailing)
                    .onChange(of: card.data, initial: true) {
                        if (card.data.range(of: "^[a-zA-Z0-9]*$", options: .regularExpression) != nil){
                            lastCardData = card.data
                        } else {
                            if let lastData = lastCardData {
                                card.data = lastData
                            }
                        }
                        
                    }
            }
            ColorPicker(selection: $bgColor, supportsOpacity: false) {
                Text("Background Color")
            }
            .onChange(of: bgColor, initial: false, {
                card.setBackgroundColor(data: bgColor)
            })
            ColorPicker(selection: $textColor, supportsOpacity: false) {
                Text("Text Color")
            }
            .onChange(of: textColor, initial: false, {
                card.setTextColor(data: textColor)
            })
            Picker("Data Type: ", selection: $card.codeType) {
                ForEach(types, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.palette)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .scrollDismissesKeyboard(.interactively)
        .cornerRadius(12)
        .font(.title)
        .ignoresSafeArea(.all)
        .onSubmit {
            print(card.getRawBackgroundColor())
            print(card.getRawTextColor())
            dismiss()
        }
        .onAppear {
            print(card.getRawBackgroundColor())
            print(card.getRawTextColor())
            textColor = card.getTextColor()
            bgColor = card.getBackgroundColor()
        }
    }
}
