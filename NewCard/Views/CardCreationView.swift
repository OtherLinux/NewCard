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
    var filteredCompanies: [Company] { //Search filtering
        guard !searchedTerm.isEmpty else {
            return companies.getCompanies()
        }
        return companies.getCompanies().filter { company in
            company.name.lowercased().contains(searchedTerm.lowercased())
        }
        
    }
    
    @State var newCard: Card = Card()
    @State var cardName: String = ""
    @State var isShowing: Bool = false //Card scanner
    @State var scannedData: String = ""
    @State var manualEntryShown: Bool = false
    @State var creatingCustomCard: Bool = false
    @State var editingMenuShown: Bool = false
    
    @State var showAlert: Bool = false
    
    @State var startingLocation: CGPoint?
    @State var dismissal: Bool = false
    
    
    var body: some View {
        NavigationStack { //Company display
            
            List {
                Button(action:{ //Custom card creation
                    creatingCustomCard = true
                    newCard = Card() //Resets card data. Fix to bug where users custom card could look the same as a company card
                    newCard.title = "Custom"
                    let minOffset = 0.35
                    var colorData = [Double.random(in: 0.0..<1.0), Double.random(in: 0.0..<1.0), Double.random(in: 0.0..<1.0)]
                    
                    while (
                        abs(2 * colorData[0] - 1) < minOffset && abs(2 * colorData[1] - 1) < minOffset && abs(2 * colorData[2] - 1) < minOffset
                    ) {
                        colorData = [Double.random(in: 0.0..<1.0), Double.random(in: 0.0..<1.0), Double.random(in: 0.0..<1.0)]
                    }
                    
                    newCard.setBackgroundColor(data:Color(red: colorData[0], green: colorData[1], blue: colorData[2]))
                    newCard.setTextColor(data: Color(red: (1 - colorData[0]), green: (1 - colorData[1]), blue: (1 - colorData[2])))
                    isShowing = true
                }){
                    HStack {
                        Image(systemName: "plus")
                        Text("New Card")
                    }
                        .frame(maxWidth: .infinity, maxHeight: 150)
                        .font(.system(size: 32))
                        .fontWeight(.semibold)
                        .background(Color.primary)
                        .foregroundStyle(Color(.systemBackground))
                        .cornerRadius(8)
                }
                .shadow(radius: 2)
                .buttonStyle(PlainButtonStyle())
                .listRowSeparator(.hidden)
                ForEach(filteredCompanies,id:\.self) { company in //Companies from json file
                    Button(action:{
                        newCard.setDataFromCompany(data: company)
                        creatingCustomCard = false
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
                ToolbarItem(placement:.topBarTrailing) {
                    Button(action: {dismiss()}) {
                        Image(systemName: "xmark")
                            .foregroundStyle(.blue)
                    }
                }
            }/**/
            
        }
        .searchable(text: $searchedTerm)
        .alert("Duplicate", isPresented: $showAlert) { //Warns when card code data is duplicate
            Button("No", role: .cancel, action: {showAlert = false})
            Button("Yes", role: .destructive, action: {
                showAlert = false
                newCard.data = scannedData
                modelContext.insert(newCard)
                if (creatingCustomCard) {
                    editingMenuShown = true
                } else {
                    dismiss()
                }
            })
        } message: {
            Text("This card already exists \n Do you want to add it anyway?")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .sheet(isPresented: $editingMenuShown, onDismiss: {
            dismiss()
        }) {
            DetailView(card: newCard)
                .sheet(isPresented: $editingMenuShown) {
                    CardEdit(card: $newCard)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
        }
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
                    if (creatingCustomCard) {
                        editingMenuShown = true
                    } else {
                        dismiss()
                    }
                }
                else {
                    showAlert = true
                }
            }
        }) {
            ZStack {
                ScannerView(scannedString: $scannedData) //BarCode scanner
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
                VStack {
                    Spacer()
                    Button(action: {manualEntryShown = true}) {
                        Text("Enter manually")
                            .frame(width:350, height: 50)
                    }
                    .foregroundStyle(Color(.systemBackground))
                    .background(Color.primary)
                    .cornerRadius(20)
                    .padding(10)
                    .padding(.bottom, 25)
                }
                .sheet(isPresented: $manualEntryShown) {
                    VStack { //Manual card entry
                        Group {
                            HStack { //Top text
                                Text("Add card manually")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Spacer()
                                Button(action: {manualEntryShown = false}) {
                                    Text("Cancel")
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            HStack { //Bottom text
                                Text("Enter the card numbers printed on your card")
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            Group { //Text data entry field
                                TextField(text: $scannedData, prompt: Text("Tap to start writing")) {
                                }
                                .onSubmit({
                                    isShowing = false
                                })
                                .padding()
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(12)
                            }
                            .padding()
                            Spacer()
                            HStack { //Submit button
                                Button(action: {isShowing = false}) {
                                    Text("Submit")
                                        .frame(width:350, height: 50)
                                }
                            }
                            .foregroundStyle(Color(.systemBackground))
                            .background(Color.primary)
                            .cornerRadius(20)
                            .padding(10)
                            .padding(.bottom, 25)
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .background(Color(.systemGroupedBackground))
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}


