//
//  SwiftUIHomeView.swift
//  AtlasSupportSDK
//
//  Created by Andrey Doroshko on 1/17/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import SwiftUI
import AtlasSupportSDK

struct SwiftUIHomeView: View {
    @State private var showModal = false

    var body: some View {
        ZStack {
            // Content of the main view
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                showModal.toggle()
            }) {
                Text("Open Modal")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

        }
        .sheet(isPresented: $showModal) {
            // Modal view content
            ModalView()
        }
    }
}

struct ModalView: View {
    var body: some View {
        VStack {
            AtlasSDK.getAtlassSwiftUIView()
        }
    }
}

