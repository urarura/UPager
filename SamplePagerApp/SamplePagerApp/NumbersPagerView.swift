//
//  NumbersPagerView.swift
//  SamplePagerApp
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI
import UPager

struct NumbersPagerView: View {
    @State private var selection = 1
    let cacheNum = 5

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            UPager(selection: $selection) { element in
                NumberView(selection: $selection, num: element)
            } onReachedToFirst: { element in
                return Array((element-cacheNum)..<element)
            } onReachedToLast: { element in
                return Array((element+1)...(element+cacheNum))
            } onPageChanged: { element in
                print("\(element) is currently displayed.")
            }

            CloseButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NumbersPagerView_Previews: PreviewProvider {
    static var previews: some View {
        NumbersPagerView()
    }
}
