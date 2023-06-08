//
//  settingspage.swift
//  newsyfc
//
//  Created by Admin on 18/5/22.
//

import Foundation
import SwiftUI

struct settingspage: View {
    @Binding var screenstatus: String
    
    @State var calendarrefresh: Bool = false
    @State var notificationrefresh: Bool = false
    @State var reselectdate: Bool = false
    
    var body: some View {
        VStack{
            navigationbar(screenstatus: $screenstatus, calendarrefresh: $calendarrefresh, notificationrefresh: $notificationrefresh, reselectdate: $reselectdate, titlename: "My Settings", selecteddatestring: "")
            privacypolicy()
        }
        .padding(.bottom, 40)
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
}
