//
//  FixedImagesPagerView.swift
//  SamplePagerApp
//
//  Created by Hiroki Urashima on 2022/09/29.
//

import SwiftUI
import UPager

struct FixedImagesPagerView: View {
    @State private var selection = "circle"
    let images = ["circle", "triangle", "rectangle", "pentagon", "hexagon"]

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            UPager(images, selection: $selection) { element in
                imageView(imageName: element)
            }
            
            CloseButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func imageView(imageName: String) -> some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
#if os(macOS)
            // For macOS, buttons to change pages are required like below.
            HStack(spacing: 8) {
                Button {
                    if let idx = images.firstIndex(of: selection) {
                        selection = images[idx - 1]
                    }
                } label: {
                    Label("Prev", systemImage: "arrowtriangle.left.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
                .disabled(images.first == selection)
                Button {
                    if let idx = images.firstIndex(of: selection) {
                        selection = images[idx + 1]
                    }
                } label: {
                    Label("Next", systemImage: "arrowtriangle.right.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
                .disabled(images.last == selection)
            }
#else
            Text("You can swipe in horizontal direction")
                .foregroundColor(.secondary)
#endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct FixedImagesPagerView_Previews: PreviewProvider {
    static var previews: some View {
        FixedImagesPagerView()
    }
}
