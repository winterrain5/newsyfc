//
//  calendarobject.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import Foundation
import SwiftUI
import FSCalendar

struct calendarobject: View {
    @Binding var eventid: Int
    @Binding var screenvariable: String
    @Binding var mainschedulelist: [schedules]
    @Binding var mainholidaylist: [holidays]
    @Binding var selecteddate: Date
    @Binding var calendarrefresh: Bool
    @Binding var reselectdate: Bool
    
    @State var minimumdate = Calendar.current.date(byAdding: .day, value:2, to: Date()) ?? Date()
    
    
    var body: some View {
        CalendarRepresentable(eventid: $eventid, screenvariable: $screenvariable, minimumdate: $minimumdate, selecteddate: $selecteddate, mainschedulelist: $mainschedulelist, mainholidaylist: $mainholidaylist, calendarrefresh: $calendarrefresh, reselectdate: $reselectdate)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 19, x: 0.0, y: 0.0)
            )
            .frame(height: 350)
            .padding()
    }
}

struct CalendarRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    var calendar = FSCalendar()
    @Binding var eventid: Int
    @Binding var screenvariable: String
    @Binding var minimumdate: Date
    @Binding var selecteddate: Date
    @Binding var mainschedulelist: [schedules]
    @Binding var mainholidaylist: [holidays]
    @Binding var calendarrefresh: Bool
    @Binding var reselectdate: Bool
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.appearance.todayColor = .none
        calendar.appearance.titleTodayColor = .gray
        calendar.appearance.eventDefaultColor = .red
        
        calendar.appearance.selectionColor = .init(hexaString: "#16588D")
        calendar.select(nil)
        
        return calendar
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: CalendarRepresentable
        
        init(_ parent: CalendarRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
                
            return 0
        }
        
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let eventdates = prepareblockdates()
            for blockdates in eventdates {
                if (date == blockdates){
                    return false
                }
            }
            
            return true
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            var eventcolour = false
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let eventdates = prepareblockdates()
            for blockdates in eventdates {
                if (date == blockdates){
                    return .gray
                }
            }
            for dates in self.parent.mainholidaylist {
                let eventDate = formatter.date(from: dates.holiday_date ?? "")
                if date.compare(eventDate!) == .orderedSame {
                    eventcolour = true
                }
            }
            if eventcolour == true {
                return .systemGreen
            }
            return nil
        }
        
        func minimumDate(for calendar: FSCalendar) -> Date {
            let date = Date()
            var returnvariable = Calendar.current.date(byAdding: .day, value:1, to: Date()) ?? Date()
            if(Calendar.current.component(.hour, from: date) < 8){
                returnvariable = Calendar.current.date(byAdding: .day, value:1, to: Date()) ?? Date()
                if(Calendar.current.component(.weekday, from: date) == 1){
                    returnvariable = Calendar.current.date(byAdding: .day, value:2, to: Date()) ?? Date()
                    print("sunday")
                }
            }
            if(Calendar.current.component(.hour, from: date) >= 8){
                returnvariable = Calendar.current.date(byAdding: .day, value:2, to: Date()) ?? Date()
                if(Calendar.current.component(.weekday, from: date) == 7){
                    returnvariable = Calendar.current.date(byAdding: .day, value:3, to: Date()) ?? Date()
                    print("saturday")
                }
            }
            self.parent.minimumdate = returnvariable
            self.parent.selecteddate = returnvariable
            return returnvariable
        }
        
        func maximumDate(for calendar: FSCalendar) -> Date {
            return Calendar.current.date(byAdding: .month, value:1, to: Date()) ?? Date()
        }
        
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            self.parent.selecteddate = date
            self.parent.reselectdate = false
            
            let formatter = DateFormatter()
            self.parent.screenvariable = "normaldate"
            formatter.dateFormat = "yyyy-MM-dd"
            
            for dates in self.parent.mainschedulelist {
                guard let eventDate = formatter.date(from: dates.lesson_date ) else {return}
                if date.compare(eventDate) == .orderedSame {
                    self.parent.screenvariable = "eventdate"
                    self.parent.eventid = dates.student_available_id
                }
            }
            
            for dates in self.parent.mainholidaylist {
                guard let eventDate = formatter.date(from: dates.holiday_date ?? "") else {return}
                if date.compare(eventDate) == .orderedSame {
                    self.parent.screenvariable = "holidaydate"
                }
            }
        }
        
        func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dateFormatter.timeZone = TimeZone.current
            var dateStr = ""
            
            for dates in self.parent.mainschedulelist {
                let eventDate = dateFormatter.date(from: dates.lesson_date)
                if date.compare(eventDate!) == .orderedSame {
                    let wav01 = dates.wave_one
                    let wav02 = dates.wave_two
                    let wav03 = dates.wave_three
                    let wav04 = dates.wave_four
                    if (wav01 == true && wav02 == false && wav03 == false && wav04 == false){
                        dateStr = "1"
                    }
                    else if (wav01 == false && wav02 == true && wav03 == false && wav04 == false){
                        dateStr = "2"
                    }
                    else if (wav01 == false && wav02 == false && wav03 == true && wav04 == false){
                        dateStr = "3"
                    }
                    else if (wav01 == false && wav02 == false && wav03 == false && wav04 == true){
                        dateStr = "4"
                    }
                    else if (wav01 == true && wav02 == true && wav03 == false && wav04 == false){
                        dateStr = "1, 2"
                    }
                    else if (wav01 == true && wav02 == false && wav03 == true && wav04 == false){
                        dateStr = "1, 3"
                    }
                    else if (wav01 == true && wav02 == false && wav03 == false && wav04 == true){
                        dateStr = "1, 4"
                    }
                    else if (wav01 == false && wav02 == true && wav03 == true && wav04 == false){
                        dateStr = "2, 3"
                    }
                    else if (wav01 == false && wav02 == true && wav03 == false && wav04 == true){
                        dateStr = "2, 4"
                    }
                    else if (wav01 == false && wav02 == false && wav03 == true && wav04 == true){
                        dateStr = "3, 4"
                    }
                    else if (wav01 == true && wav02 == true && wav03 == true && wav04 == false){
                        dateStr = "1, 2, 3"
                    }
                    else if (wav01 == true && wav02 == true && wav03 == false && wav04 == true){
                        dateStr = "1, 2, 4"
                    }
                    else if (wav01 == true && wav02 == false && wav03 == true && wav04 == true){
                        dateStr = "1, 3, 4"
                    }
                    else if (wav01 == false && wav02 == true && wav03 == true && wav04 == true){
                        dateStr = "2, 3, 4"
                    }
                    else if (wav01 == true && wav02 == true && wav03 == true && wav04 == true){
                        dateStr = "1 - 4"
                    }
                    else {
                        dateStr = "Booking"
                    }
                    return dateStr
                }
                else {
                    dateStr = ""
                }
            }
            
            for dates in self.parent.mainholidaylist {
                guard let eventDate = dateFormatter.date(from: dates.holiday_date ?? "") else {return ""}
                if date.compare(eventDate) == .orderedSame {
                    dateStr = "PH"
                }
            }
            
            return dateStr
        }
        
        func prepareblockdates() -> Array<Date> {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var dateholder = [String]()
            var mondayholder = [Date]()
            var currentdate = self.parent.minimumdate
            let enddate = Calendar.current.date(byAdding: .month, value:1, to: Date()) ?? Date()
            while currentdate <= enddate {
                dateholder.append(formatter.string(from:currentdate))
                currentdate = Calendar.current.date(byAdding: .day, value:1, to: currentdate)!
            }
            
            for dates in dateholder {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let tempdate = formatter.date(from: dates)
                let daychecker = Calendar.current.component(.weekday, from: tempdate!)
                if (daychecker == 2){
                    mondayholder.append(tempdate!)
                }
            }
            return mondayholder
        }
    }
}
