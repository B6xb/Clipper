//
//  AboutView.swift
//  Clipper
//
//  Created by Bander Almutairi on 25/02/2025.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack(alignment: .top) {
            VStack(){
                HStack(){
                    Image(systemName: "clipboard")
                        .scaledToFit()
                    Text("Clipper")
                        .bold()
                        .font(.title)
                }
                Divider()
                HStack(){
                    Text("Manny Thanks to Bander for such a great idea")
                }
                .padding()
                HStack(){
                    Text("Combining both simplicty and effictivness")
                }
                .padding()
            }
        }.frame(width: 500)
    }
}
