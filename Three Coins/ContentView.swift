//
//  ContentView.swift
//  Three Coins
//
//  Created by Jacopo Donati on 16/02/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var somme: [String] = []
    @State private var linesVisible = false
    @State private var conteggioPremuto: Int = 0
    // Costante per il numero massimo consentito di clic
    let numeroMassimoClic: Int = 6
    
    // Mappatura tra somme e nomi dei file delle immagini
    let immaginiPerSomma: [String: String] = [
        "9": "yang_mobile",
        "8": "yin_statico",
        "7": "yang_statico",
        "6": "yin_mobile"
    ]
    
    // Array di immagini vuote iniziali
    let immaginiVuote: [String] = Array(repeating: "vuoto", count: 6)
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                // Area centrale per mostrare l'esagramma
                VStack() {
                    ForEach(0..<6, id: \.self) { index in
                        if linesVisible {
                            let imageName = somme.indices.contains(5 - index) ? immaginiPerSomma[somme[5 - index]] ?? "vuoto" : "vuoto"
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: -20, leading: 20, bottom: -20, trailing: 20))
                        } else {
                            let imageName = somme.indices.contains(5 - index) ? immaginiPerSomma[somme[5 - index]] ?? "vuoto" : "vuoto"
                            if imageName == "vuoto" {
                                Circle()
                                    .foregroundColor(.black)
                                    .frame(width: 10, height: 10)
                            } else {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity)
                                    .padding(EdgeInsets(top: -20, leading: 20, bottom: -20, trailing: 20))
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .opacity(linesVisible ? 1.0 : 0)
                
                Spacer()
                
                HStack {
                    Button(action: {
                        self.linesVisible.toggle()
                    }) {
                        Image(systemName: linesVisible ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.white)
                            .padding()
                    }
                    .background(linesVisible ? Color.green : Color.red)
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .bold))
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 20))
                    
                    Button(action: {
                        conteggioPremuto += 1
                        calcolaSommaNumeri()
                    }) {
                        Text("Lancia")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 30)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .opacity(conteggioPremuto >= numeroMassimoClic ? 0.5 : 1.0)
                    }
                    .disabled(conteggioPremuto >= numeroMassimoClic)
                    .onLongPressGesture {
                        conteggioPremuto = 0
                        somme.removeAll()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    func calcolaSommaNumeri() {
        // Crea un dispatch group per gestire l'esecuzione in parallelo
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter() // Entra nel dispatch group
        
        // Esegui l'estrazione dei numeri in parallelo
        DispatchQueue.global().async(group: dispatchGroup) {
            var sommaParziale = 0
            for _ in 0..<3 {
                let numeroCasuale = [2, 3].randomElement() ?? 0
                sommaParziale += numeroCasuale
            }
            
            // Aggiorna la somma calcolata
            DispatchQueue.main.async {
                let sommaText = "\(sommaParziale)"
                somme.append(sommaText)
                dispatchGroup.leave() // Lascia il dispatch group quando il calcolo è completato
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
