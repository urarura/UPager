//
//  ImagesPagerView.swift
//  SamplePagerApp
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI
import UPager

struct ImagesPagerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selection = 0
    let images = ["circle", "triangle", "rectangle", "pentagon", "hexagon"]
    let cacheNum = 3

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            UPager(selection: $selection) { element in
                ImageView(selection: $selection, imageName: imageName(element))
            } onPageChanged: { element in
                let imageName = imageName(element)
                print("\(imageName) is currently displayed.")
            } onReachedToFirst: { element in
                return Array((element-cacheNum)..<element)
            } onReachedToLast: { element in
                return Array((element+1)...(element+cacheNum))
            }
            
            CloseButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func imageName(_ index: Int) -> String {
        var idx = index % images.count
        if idx < 0 { idx = idx + images.count }
        return images[idx]
    }
}

struct ImagesPagerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagesPagerView()
    }
}
