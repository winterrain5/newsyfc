//
//  contentpage.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import Foundation
import SwiftUI

struct calendarpage: View {
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var screenstatus: String
    @Binding var mainschedulelist: [schedules]
    @Binding var mainholidaylist: [holidays]
    
    @State var datarefresh: Bool = false
    @State var calendarrefresh: Bool = false
    @State var notificationrefresh: Bool = false
    @State var eventid: Int = 0
    @State var screenvariable: String = "blankdate"
    @State var selecteddate: Date = Calendar.current.date(byAdding: .day, value:2, to: Date()) ?? Date()
    @State var reselectdate: Bool = true
    
    var selectedatestring: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        if(reselectdate == true){
            return "Select Date: "
        }
        else {
            return dateFormatter.string(from: selecteddate)
        }
    }
    
    var body: some View {
        VStack{
            navigationbar(screenstatus: $screenstatus, calendarrefresh: $calendarrefresh, notificationrefresh: $notificationrefresh, reselectdate: $reselectdate, titlename: "My Calendar", selecteddatestring: selectedatestring)
            
            ScrollView {
                if(calendarrefresh == true){
                    calendarobject(eventid: $eventid, screenvariable: $screenvariable, mainschedulelist: $mainschedulelist, mainholidaylist: $mainholidaylist, selecteddate: $selecteddate, calendarrefresh: $calendarrefresh, reselectdate: $reselectdate)
                } else {
                    calendarobject(eventid: $eventid, screenvariable: $screenvariable, mainschedulelist: $mainschedulelist, mainholidaylist: $mainholidaylist, selecteddate: $selecteddate, calendarrefresh: $calendarrefresh, reselectdate: $reselectdate)
                }
                
                Spacer()
                calendartab(currenttoken: $currenttoken, currentuserid: $currentuserid, eventid: $eventid, screenvariable: $screenvariable, mainschedulelist: $mainschedulelist, selecteddate: $selecteddate, calendarrefresh: $calendarrefresh, reselectdate: $reselectdate)
            }
        }
        .padding(.bottom, 40)
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
}
