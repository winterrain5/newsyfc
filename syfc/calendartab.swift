//
//  calendartab.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import Foundation
import SwiftUI
import FSCalendar

struct calendartab: View {
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var eventid: Int
    @Binding var screenvariable: String
    @Binding var mainschedulelist: [schedules]
    @Binding var selecteddate: Date
    @Binding var calendarrefresh: Bool
    @Binding var reselectdate: Bool
    
    @State var wave01state: Bool = false
    @State var wave02state: Bool = false
    @State var wave03state: Bool = false
    @State var wave04state: Bool = false
    @State var allwavestate: Bool = false
    @State var calendaractivity: String = ""
    @State var onclicksubmitbutton: Bool = false
    @State var onclickdeletebutton: Bool = false
    @State var submitsuccessful: Bool = false
    @State var deletesuccessful: Bool = false
    
    var selectedatestring: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: selecteddate)
    }
    
    var body: some View {
        let bookingstack = VStack{
            Button(
                action: {
                    screenvariable = "submitdate"
                    calendaractivity = "booking"
                }
            ){
                Text("START BOOKING")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.bluecolour)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
            }
        }
        
        let editingstack = VStack{
            Button(
                action: {
                    screenvariable = "submitdate"
                    calendaractivity = "editing"
                }
            ){
                Text("EDIT BOOKING")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.bluecolour)
                    .foregroundColor(.white)
                    .padding(.horizontal)
            }
            
            Button(
                action: {
                    onclickdeletebutton = true
                }
            ){
                Text("DELETE BOOKING")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.bluecolour)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
            }
            .alert(isPresented: $onclickdeletebutton) { () -> Alert in
                Alert(title: Text("Please Confirm Availability Selected !"), message: Text("Are you sure you would like to delete this availability submission? \n\n \(selectedatestring)"), primaryButton: .default(Text("Yes"), action: {
                    deleteslot(currentuserid: currentuserid, token: currenttoken, availabilityid: eventid)
                    deletesuccessful = true
                    let datesgroup = DispatchGroup()
                    datesgroup.enter()
                    retrievedates(){ (result) in
                        mainschedulelist = result
                        datesgroup.leave()
                    }
                    datesgroup.wait()
                    
                    calendarrefresh.toggle()
                    screenvariable = "blankdate"
                    reselectdate = true
                    
                }), secondaryButton: .cancel(Text("No")))
            }
        }
        
        let submittingstack = VStack{
            let wave01 = CheckboxFieldView(titletext: "Wave 01 (0815 - 1100)", checkState: $wave01state, wave01checkstate: $wave01state, wave02checkstate: $wave02state, wave03checkstate: $wave03state, wave04checkstate: $wave04state, allwavecheckstate: $allwavestate)
            let wave02 = CheckboxFieldView(titletext: "Wave 02 (1030 - 1315)", checkState: $wave02state, wave01checkstate: $wave01state, wave02checkstate: $wave02state, wave03checkstate: $wave03state, wave04checkstate: $wave04state, allwavecheckstate: $allwavestate)
            let wave03 = CheckboxFieldView(titletext: "Wave 03 (1330 - 1615)", checkState: $wave03state, wave01checkstate: $wave01state, wave02checkstate: $wave02state, wave03checkstate: $wave03state, wave04checkstate: $wave04state, allwavecheckstate: $allwavestate)
            let wave04 = CheckboxFieldView(titletext: "Wave 04 (1530 - 1815)", checkState: $wave04state, wave01checkstate: $wave01state, wave02checkstate: $wave02state, wave03checkstate: $wave03state, wave04checkstate: $wave04state, allwavecheckstate: $allwavestate)
            let allwave = CheckboxFieldView(titletext: "All Waves (0815 - 1815)", checkState: $allwavestate, wave01checkstate: $wave01state, wave02checkstate: $wave02state, wave03checkstate: $wave03state, wave04checkstate: $wave04state, allwavecheckstate: $allwavestate)

            HStack{
                VStack(alignment: .leading){
                    wave01
                    wave02
                    wave03
                    wave04
                    allwave
                }
                .onAppear(perform: {
                    checkboxdata()
                })
                
                Spacer()
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            
            Button(
                action: {
                    onclicksubmitbutton = true
                }
            ){
                Text("SUBMIT BOOKING")
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.bluecolour)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
            }
            .alert(isPresented: $onclicksubmitbutton) { () -> Alert in
                
                if(wave01state == false && wave02state == false && wave03state == false && wave04state == false){
                    return Alert(title: Text("Selection Error !"), message: Text("Please select a wave in oder to submit your availability."), dismissButton: .default(Text("Okay")))
                } else {
                    return Alert(title: Text("Please Confirm Availability Selected !"), message: Text(generatepopupstring(selecteddate: selectedatestring, wave01: wave01, wave02: wave02, wave03: wave03, wave04: wave04, allwave: allwave)), primaryButton: .default(Text("Yes"), action: {
                        submitentry(currentuserid: currentuserid, token: currenttoken, calendaractivity: calendaractivity, availabilityid: eventid)
                        
                        let datesgroup = DispatchGroup()
                        datesgroup.enter()
                        retrievedates(){ (result) in
                            mainschedulelist = result
                            datesgroup.leave()
                        }
                        datesgroup.wait()
                        
                        calendarrefresh.toggle()
                        screenvariable = "blankdate"
                        reselectdate = true
                    }), secondaryButton: .cancel(Text("No")))
                }
            }
        }
        
        if(screenvariable == "normaldate"){
            bookingstack
        }
        if(screenvariable == "eventdate"){
            editingstack
        }
        if(screenvariable == "submitdate"){
            submittingstack
        }
        if(screenvariable == "blankdate"){
            
        }
    }
    
    func retrievedates(completion: @escaping ([schedules]) -> ()){
        var retrieveddates = [schedules]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/student-availability-detail/\(currentuserid)/")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                print(error!)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                do {
                    let currentschedule: [schedules] = try JSONDecoder().decode([schedules].self, from: data)
                    retrieveddates = currentschedule
                    
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(retrieveddates)
        }
        task.resume()
    }
    
    func submitentry(currentuserid: Int, token: String, calendaractivity: String, availabilityid: Int){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formatteddate = formatter.string(from: selecteddate)
        var urlstring = ""
        if calendaractivity == "booking" {
            urlstring = "https://optimus.syfc.com.sg/application/student-availability-create/"
        } else if calendaractivity == "editing" {
            urlstring = "https://optimus.syfc.com.sg/application/student-availability-detail-update/\(availabilityid)/"
        }
        guard let url = URL(string: urlstring) else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        
        let hashbody: [String: AnyHashable] = [
            "wave_one": wave01state,
            "wave_two": wave02state,
            "wave_three": wave03state,
            "wave_four": wave04state,
            "lesson_date": formatteddate,
            "student_id": currentuserid
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: hashbody, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }
            catch {
                print("ERROR: \(error)")
            }
        }
        task.resume()
    }
    
    func deleteslot(currentuserid: Int, token: String, availabilityid: Int){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let url = URL(string: "https://optimus.syfc.com.sg/application/student-availability-delete/\(availabilityid)/") else {
            print("url error")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            }
            catch {
                print("ERROR: \(error)")
            }
        }
        task.resume()
    }
    
    func generatepopupstring(selecteddate: String, wave01: CheckboxFieldView, wave02: CheckboxFieldView, wave03: CheckboxFieldView, wave04: CheckboxFieldView, allwave: CheckboxFieldView) -> String {
        var generatedstring = "Do you wish to book your availability for: \n\n \(selecteddate) \n\n"
        print("triggered \(wave01.checkState)")
        if wave01.checkState {
            print("triggered")
            generatedstring = generatedstring + " - Wave 01 \n"
        }
        if wave02.checkState {
            generatedstring = generatedstring + " - Wave 02 \n"
        }
        if wave03.checkState {
            generatedstring = generatedstring + " - Wave 03 \n"
        }
        if wave04.checkState {
            generatedstring = generatedstring + " - Wave 04 \n"
        }
        
        return generatedstring
    }
    
    func statechecker(wave01: CheckboxFieldView, wave02: CheckboxFieldView, wave03: CheckboxFieldView, wave04: CheckboxFieldView, allwave: CheckboxFieldView){
        if allwave.checkState == true {
            wave01.checkState = true
            wave02.checkState = true
            wave03.checkState = true
            wave04.checkState = true
        } else {
            wave01.checkState = false
            wave02.checkState = false
            wave03.checkState = false
            wave04.checkState = false
        }
    }
    
    func checkboxdata(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var datechecker = 0
        for dates in mainschedulelist {
            if selecteddate == formatter.date(from: dates.lesson_date ?? "") {
                if calendaractivity == "editing"{
                    datechecker += 1
                    wave01state = dates.wave_one ?? false
                    wave02state = dates.wave_two ?? false
                    wave03state = dates.wave_three ?? false
                    wave04state = dates.wave_four ?? false
                    if (wave01state == true && wave02state == true && wave03state == true && wave04state == true){
                        allwavestate = true
                    }
                }
            }
        }
        if (datechecker == 0){
            wave01state = false
            wave02state = false
            wave03state = false
            wave04state = false
            allwavestate = false
        }
    }
}

struct CheckboxFieldView : View {
    var titletext: String
    @Binding var checkState: Bool
    @Binding var wave01checkstate: Bool
    @Binding var wave02checkstate: Bool
    @Binding var wave03checkstate: Bool
    @Binding var wave04checkstate: Bool
    @Binding var allwavecheckstate: Bool
    var body: some View {
         Button(action:
            {
                if self.checkState == true {
                    self.checkState = false
                } else {
                    self.checkState = true
                }
                print("State : \(self.checkState)")
                
                if self.titletext == "All Waves" {
                    if self.checkState == true{
                        wave01checkstate = true
                        wave02checkstate = true
                        wave03checkstate = true
                        wave04checkstate = true
                    } else {
                        wave01checkstate = false
                        wave02checkstate = false
                        wave03checkstate = false
                        wave04checkstate = false
                    }
                } else {
                    if(wave01checkstate == true && wave02checkstate == true && wave03checkstate == true && wave04checkstate == true){
                        allwavecheckstate = true
                    } else {
                        allwavecheckstate = false
                    }
                }
                
        }) {
            HStack(alignment: .top, spacing: 10) {
                   RoundedRectangle(cornerRadius: 5)
                    .fill(self.checkState ? Color.green : Color.gray)
                    .frame(width:20, height:20, alignment: .center)
                   Text(titletext)
                    .foregroundColor(.black)
            }
        }
        .foregroundColor(Color.white)
    }
}
