//
//  ImageView.swift
//  SamplePagerApp iOS
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI

struct ImageView: View {
    @Binding var selection: Int
    let imageName: String

    var body: some View {
        VStack {
            VStack {
                // You can load image here dynamically by using AsyncImage
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                Text(imageName.capitalized)
                    .font(.title)
            }
            .padding()
            
#if os(macOS)
            // For macOS, buttons to change pages are required like below.
            HStack(spacing: 8) {
                Button {
                    selection -= 1
                } label: {
                    Label("Prev", systemImage: "arrowtriangle.left.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
                Button {
                    selection += 1
                } label: {
                    Label("Next", systemImage: "arrowtriangle.right.fill").labelStyle(.iconOnly)
                }
                .font(.title3)
                .buttonStyle(.bordered)
            }
#else
            Text("You can swipe in horizontal direction")
                .foregroundColor(.secondary)
#endif
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView(selection: .constant(0), imageName: "circle")
    }
}
