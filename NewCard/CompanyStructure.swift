//
//  CompanyStructure.swift
//  NewCard
//
//  Created by Marek Polame on 08.06.2025.
//

import SwiftUI

struct Company: Identifiable, Hashable, Codable {
    private func getArrayFromColor(data:Color) -> [Double] {
        @Environment(\.self) var environment
        let colorData = data.resolve(in: environment)
        return [
            Double(colorData.red)*255,
            Double(colorData.green)*255,
            Double(colorData.blue)*255,
            Double(colorData.opacity),
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
    
    public func getRawBackgroundColor() -> [Double] {
        return backgroundColor
    }
    
    public func getRawTextColor() -> [Double] {
        return textColor
    }
    
    var id: Int
    public var name: String = "Unnamed"
    private var backgroundColor: [Double] = [255,255,255,1]
    private var textColor: [Double] = [255,255,255,1]
    public var codeType: String
}

class Companies: ObservableObject {
    @Published var companies: [Company] = []
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "Companies", withExtension: "json") else {
            print("json not found")
            return
        }
        let data = try? Data(contentsOf: url)
        let companies = try? JSONDecoder().decode([Company].self, from: data!)
        self.companies = companies!
    }
    
    func getCompanies() -> [Company] {
        return self.companies
    }
    
    func getCompany(name: String) -> Company? {
        for company in self.companies {
            if company.name == name {
                return company
            }
        }
        return nil
    }
    
}

var companiesGlobal = Companies()


