//
//  DetailView.swift
//  NewCard
//
//  Created by Marek Polame on 01.06.2025.
//

import SwiftUI

struct DetailView: View {
    @State var card: Card
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var context
    
    @State var startingLocation: CGPoint?
    @State var offset: CGFloat = 0
    @State var circleSize: CGFloat = 0
    @State var opacity: Double = 1
    
    @State var showAlert: Bool = false
    @State var showEditing: Bool = false
    
    @State var dismissal: Bool = false
    
    @State var UIBrightness = UIScreen.main.brightness
    
    
    
    func closeWindow() {
        if (!dismissal) {
            
            UIScreen.main.brightness = UIBrightness
            dismissal = true
            withAnimation(.spring) {
                offset=0
            }
            withAnimation(.linear(duration: 0.215)) {
                if (UIScreen.main.bounds.height > UIScreen.main.bounds.width) {
                    circleSize = UIScreen.main.bounds.height + 350
                    
                } else {
                    circleSize = UIScreen.main.bounds.width + 350
                }
            } completion: {
                withAnimation() {
                    circleSize = UIScreen.main.bounds.height
                }
                opacity = 0
                dismiss()
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        Menu {
                            Button(action: {showEditing = true}) {
                                Label("Edit",systemImage: "pencil")
                            }
                            Button(action: {showAlert = true}) {
                                Label("Remove",systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.title)
                        }
                        Spacer()
                        Button(action: {dismiss()}) {
                            Image(systemName: "xmark")
                        }
                        .font(.title)
                    }
                    HStack {
                        Spacer()
                        Text(card.title)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .padding(.horizontal, 25)
                        Spacer()
                    }
                }
                VStack {
                    switch card.codeType {
                    case ("barcode"):
                        generateBarCode(data: card.data)
                            .resizable()
                            .frame(width:350, height: 125)
                            .aspectRatio(contentMode: .fit)
                    case ("qr"):
                        generateQrCode(data: card.data)
                            .resizable()
                            .frame(width:250, height: 250)
                            .aspectRatio(contentMode: .fit)
                    default:
                        generateBarCode(data: card.data)
                            .resizable()
                            .frame(width:350, height: 125)
                            .aspectRatio(contentMode: .fit)
                        
                    }
                    Text(card.data)
                        .foregroundStyle(.black)
                        .font(.footnote)
                        .offset(y:-30)
                        .padding()
                    
                }
                .background(Color.white)
                .cornerRadius(10)
                
            }
            .frame(maxHeight: .infinity,alignment: .topTrailing,)
            .padding()
            .opacity(opacity)
            .offset(y:-offset)
            
            
            Group {
                Circle()
                    .fill(card.getTextColor())
                    .frame(width: circleSize, height: circleSize, alignment: .center)
            }
            .position(x:UIScreen.main.bounds.width/2,y:UIScreen.main.bounds.height/2)
        }
        .background(opacity != 1 ? Color.clear : card.getBackgroundColor())
        .foregroundStyle(card.getTextColor())
        .sheet(isPresented: $showEditing) {
            CardEdit(card: $card)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            UIScreen.main.brightness = CGFloat(1)
        }
        .alert("Delete?", isPresented: $showAlert) {
            Button("No", role: .cancel, action: {showAlert = false})
            Button("Confirm", role: .destructive, action: {showAlert=false; context.delete(card); dismiss()})
        }
        
    }
}

