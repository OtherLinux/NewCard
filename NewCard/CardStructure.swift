//
//  CardStructure.swift
//  NewCard
//
//  Created by Marek Polame on 30.05.2025.
//

import SwiftUI
import SwiftData

@Model
class Card {
    
    public func setDataFromCompany(data:Company) {
        self.title = data.name
        self.backgroundColor = data.getRawBackgroundColor()
        self.textColor = data.getRawTextColor()
        self.codeType = data.codeType
        self.companyId = data.id
    }
    
    private func getArrayFromColor(data:Color) -> [Double] {
        @Environment(\.self) var environment
        let colorData = data.resolve(in: environment)
        return [
            round(Double(colorData.red)*255),
            round(Double(colorData.green)*255),
            round(Double(colorData.blue)*255),
            round(Double(colorData.opacity)),
        ]
    }
    
    private func getColorFromArray(data:[Double]) -> Color {
        @Environment(\.self) var environment
        return Color(red:data[0]/255, green: data[1]/255, blue: data[2]/255, opacity: data[3])
    }
    
    public func getBackgroundColor() -> Color {
        return getColorFromArray(data: backgroundColor)
    }
    
    public func getTextColor() -> Color {
        return getColorFromArray(data: textColor)
    }
    
    public func setBackgroundColor(data: Color) -> Void {
        backgroundColor = getArrayFromColor(data: data)
    }
    
    public func setTextColor(data: Color) -> Void {
        textColor = getArrayFromColor(data: data)
    }
    
    public func getRawBackgroundColor() -> [Double] {
        return backgroundColor
    }
    
    public func getRawTextColor() -> [Double] {
        return textColor
    }
    
    
    public var id = UUID()
    public var companyId: Int = 0
    public var title: String = "Default"
    public var data: String = "Error"
    public var lastUsed: Int = Int(Date().timeIntervalSince1970 * 1000)
    public var codeType: String = "barcode"
    private var backgroundColor: [Double] = [0,0,0,1]
    private var textColor: [Double] = [255,255,255,1]
    
    
    init() {
    }
}


func saveCard() {
    
}








