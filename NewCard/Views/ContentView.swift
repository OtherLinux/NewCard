//
//  ContentView.swift
//  NewCard
//
//  Created by Marek Polame on 30.05.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.self) var environment
    @Environment(\.modelContext) private var context
    let testingData: [Card] = [Card(),Card()]
    
    @State var searchedTerm: String = ""
    @Query(sort: \Card.lastUsed, order: .reverse) var cardData: [Card]
    
    
    
    var filteredCards: [Card] { //Card filter
        guard !searchedTerm.isEmpty else {
            return cardData
        }
        return cardData.filter { card in
            if (card.title.lowercased().contains(searchedTerm.lowercased()) ||
                card.data.lowercased().contains(searchedTerm.lowercased())) {
                return true
            } else {
                return false
            }
        }
        
    }
    
    @State var data: [Card] = []
    
    @State var searchShown: Bool = false
    
    @State var selectedCard:Card?
    @State var displayCreationForm:Bool = false
    @State var UIBrightness = UIScreen.main.brightness
    
    let cardGridLayout = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    @State var startingLocation: CGPoint?
    
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { i in
                if (startingLocation == nil) {
                    startingLocation = i.location
                    //Sets start
                }
                if let point = startingLocation {
                    if (point.y - i.location.y < -240) {
                    }
                }
                
            }
            .onEnded { i in
                startingLocation = nil
            }
    }
    
    
    
    var body: some View {
        VStack {
            NavigationStack {
                ScrollView {
                    LazyVGrid(columns: cardGridLayout, spacing: 20) {
                        ForEach(filteredCards, id: \.self) { card in
                            Button(action: {
                                selectedCard = card
                                UIScreen.main.brightness = CGFloat(1)
                            }) {
                                Text(card.title)
                                    .frame(width:175, height: 100)
                                    .font(.system(size: 32))
                                    .fontWeight(.bold)
                                    .background(card.getBackgroundColor())
                                    .foregroundStyle(card.getTextColor())
                                    .cornerRadius(10)
                            }
                            .shadow(radius: 4)
                            
                            
                            
                        }
                        
                    }
                    .padding(.horizontal,8)
                    .padding(.top,4)
                }
                .scrollDismissesKeyboard(.interactively)
                .navigationTitle("Your cards")
                .toolbar {
                    Button(action: {displayCreationForm = true}) {
                        Image(systemName: "plus")
                            .foregroundStyle(.blue)
                        
                    }
                    
                }
            }
            .searchable(text: $searchedTerm)
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .sheet(item: $selectedCard, onDismiss: {
            UIScreen.main.brightness = UIBrightness
        }) { card in
            DetailView(card:card)
                .onAppear() {
                    withAnimation {
                        card.lastUsed = Int(Date().timeIntervalSince1970 * 1000)
                    }
                }
        }
        .fullScreenCover(isPresented: $displayCreationForm) {
            CardCreationView()
                .environment(\.modelContext, context)
            
        }
    }
}

#Preview {
    ContentView()
}
