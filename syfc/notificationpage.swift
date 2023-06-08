//
//  notificationpage.swift
//  newsyfc
//
//  Created by Admin on 18/5/22.
//

import Foundation
import SwiftUI

struct notificationpage: View {
    @Binding var screenstatus: String
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    
    @State var calendarrefresh: Bool = false
    @State var notificationrefresh: Bool = false
    @State var reselectdate: Bool = false
    
    var body: some View {
        
        VStack{
            navigationbar(screenstatus: $screenstatus, calendarrefresh: $calendarrefresh, notificationrefresh: $notificationrefresh, reselectdate: $reselectdate, titlename: "My Notification", selecteddatestring: "")
            
            if(notificationrefresh == true){
                notificationtab(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid, notificationrefresh: $notificationrefresh)
            } else {
                notificationtab(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid, notificationrefresh: $notificationrefresh)
            }

            Spacer()
        }
        .padding(.bottom, 20)
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
}
