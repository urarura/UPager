//
//  ContentView.swift
//  SamplePagerApp
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI

struct ContentView: View {
    @State private var showNumbersSample = false
    @State private var showDatesSample = false
    @State private var showImagesSample = false
    let windowSize: CGSize?
    
    init() {
#if os(macOS)
        windowSize = CGSize(width: 600, height: 400)
#else
        windowSize = nil
#endif
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("SUPager Samples")
                .font(.title.bold())
                .padding()
            
            List {
                Button("Numbers", action: { showNumbersSample.toggle() })
                Button("Dates", action: { showDatesSample.toggle() })
                Button("Images", action: { showImagesSample.toggle() })
            }
            .listStyle(.plain)
            .frame(maxWidth: .infinity)
        }
        .frame(minWidth: windowSize?.width, minHeight: windowSize?.height)
        .sheet(isPresented: $showNumbersSample) {
            NumbersPagerView()
                .frame(minWidth: windowSize?.width, minHeight: windowSize?.height)
        }
        .sheet(isPresented: $showDatesSample) {
            DatesPagerView()
                .frame(minWidth: windowSize?.width, minHeight: windowSize?.height)
        }
        .sheet(isPresented: $showImagesSample) {
            ImagesPagerView()
                .frame(minWidth: windowSize?.width, minHeight: windowSize?.height)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
