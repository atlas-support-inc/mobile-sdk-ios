//
//  AtlasSwiftUIView.swift
//  Pods
//
//  Created by Andrey Doroshko on 3/7/25.
//

import SwiftUI

public struct AtlasSwiftUIView: UIViewControllerRepresentable {
    
    let atlassViewController: AtlasViewController
    
    public func makeUIViewController(context: Context) -> UIViewController {
        return atlassViewController
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the view controller's state here if needed
    }
}
