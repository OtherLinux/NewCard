//
//  CardCreationView.swift
//  NewCard
//
//  Created by Marek Polame on 03.06.2025.
//

import SwiftUI
import SwiftData

struct CardCreationView: View {
    @State var companies: Companies = companiesGlobal
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query var cardData: [Card]
    
    
    
    @State var searchedTerm: String = ""
    var filteredCompanies: [Company] {
        guard !searchedTerm.isEmpty else {
            return companies.getCompanies()
        }
        return companies.getCompanies().filter { company in
            company.name.lowercased().contains(searchedTerm.lowercased())
        }
        
    }
    
    @State var newCard: Card = Card()
    @State var cardName: String = ""
    @State var isShowing: Bool = false
    @State var scannedData: String = ""
    
    @State var showAlert: Bool = false
    
    @State var startingLocation: CGPoint?
    @State var dismissal: Bool = false
    
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { i in
                if (startingLocation == nil) {
                    startingLocation = i.location
                    //Sets start
                }
                if let point = startingLocation {
                    if (point.y - i.location.y < -180 && !dismissal) {
                        dismissal = true
                        dismiss()
                    }
                }
                
            }
            .onEnded { i in
                startingLocation = nil
            }
    }
    
    
    var body: some View {
        NavigationStack {
            
            List {
                ForEach(filteredCompanies,id:\.self) { company in
                    Button(action:{
                        newCard.setDataFromCompany(data: company)
                        isShowing = true
                    }){
                        Text(company.name)
                            .frame(maxWidth: .infinity, maxHeight: 150)
                            .font(.system(size: 32))
                            .fontWeight(.semibold)
                            .background(company.getBackgroundColor())
                            .foregroundStyle(company.getTextColor())
                            .cornerRadius(8)
                    }
                    .shadow(radius: 2)
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .listStyle(.plain)
            .navigationTitle("Add card")
            .toolbar {
                Button(action: {dismiss()}) {
                    Image(systemName: "xmark")
                        .foregroundStyle(.blue)
                }
            }
            
            
            
            
            
        }
        .searchable(text: $searchedTerm)
        .alert("Duplicate", isPresented: $showAlert) {
            Button("No", role: .cancel, action: {showAlert = false})
            Button("Yes", role: .destructive, action: {
                showAlert = false
                newCard.data = scannedData
                modelContext.insert(newCard)
                dismiss()
            })
        } message: {
            Text("This card already exists \n Do you want to add it anyway?")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        
        .sheet(isPresented: $isShowing, onDismiss: { //Scanner
            if (scannedData != "") {
                var foundMatch:Bool = false
                for card in cardData {
                    if (scannedData == card.data) {
                        foundMatch = true
                    }
                }
                if (!foundMatch) {
                    newCard.data = scannedData
                    modelContext.insert(newCard)
                    dismiss()
                }
                else {
                    showAlert = true
                }
            }
        }) {
            ZStack {
                ScannerView(scannedString: $scannedData)
                    .edgesIgnoringSafeArea(.all)
                HStack {
                    Spacer()
                    Button(action: {
                        isShowing = false
                    }) {
                        Text("Cancel")
                            .foregroundStyle(.primary)
                            .font(.title2)
                    }
                }
                .frame(maxWidth:.infinity,maxHeight:.infinity, alignment: .topTrailing)
                .padding()
                
                
                
                switch newCard.codeType {
                case "qr":
                    Image(systemName: "qrcode.viewfinder")
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.white)
                        .opacity(0.6)
                default:
                    Image(systemName: "barcode.viewfinder")
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(Color.white)
                        .opacity(0.6)
                }
            }
        }
    }
}


