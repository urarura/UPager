//
//  MonthsPagerView.swift
//  SamplePagerApp
//
//  Created by Hiroki Urashima on 2022/09/27.
//

import SwiftUI
import UPager

struct DatesPagerView: View {
    @State private var selection = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    let cacheNum = 5
    let dateFormatter = {
        let df = DateFormatter()
        df.calendar = Calendar.current
        df.dateStyle = .long
        return df
    }()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            UPager(selection: $selection) { element in
                DateView(selection: $selection, dateComps: element)
            } onReachedToFirst: { element in
                let cal = Calendar.current
                return ((-cacheNum)..<0).map { num in
                    cal.dateComponents([.year, .month, .day], from: cal.date(byAdding: .day, value: num, to: cal.date(from: element)!)!)
                }
            } onReachedToLast: { element in
                let cal = Calendar.current
                return (1...cacheNum).map { num in
                    cal.dateComponents([.year, .month, .day], from: cal.date(byAdding: .day, value: num, to: cal.date(from: element)!)!)
                }
            } onPageChanged: { element in
                let dateStr = dateFormatter.string(from: Calendar.current.date(from: element)!)
                print("\(dateStr) is currently displayed.")
            }
            
            CloseButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MonthsPagerView_Previews: PreviewProvider {
    static var previews: some View {
        DatesPagerView()
    }
}
