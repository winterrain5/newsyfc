//
//  notificationtab.swift
//  newsyfc
//
//  Created by Admin on 18/5/22.
//

import Foundation
import SwiftUI
import ActivityIndicatorView
struct notificationtab: View {
    @Binding var screenstatus: String
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var notificationrefresh: Bool
    
    @State var confirmaccept: Bool = false
    @State var confirmreject: Bool = false
    @State var notificationid = 0
    @State var detailtype = ""
    @State var notificationdate = ""
    @State var checkin = ""
    @State var confirmationpage = false
    @State var rejectionreason: String = ""
    @State var historydata: Bool = true
    @State var nothistorydata: Bool = false
    
    @State var chainrefresh: Bool = false
    
    @State var currentdatas:[notificationcard] = []
    @State var pastdatas:[notificationcard] = []
    @State var showLoadingIndicator:Bool = false
    var body: some View {
        
        DispatchQueue.global().async {
            showLoadingIndicator = true
            currentdata()
            pastdata()
            
            updatingstatus(status: detailtype, detailid: notificationid)
        }
        
    
        return VStack{
            if(confirmationpage == false){
                ScrollView{
                    if (screenstatus == "Notification") {
                        notificationsection(currenttoken: $currenttoken, currentuserid: $currentuserid, notificationid: $notificationid, detailtype: $detailtype, notificationdate: $notificationdate, checkin: $checkin, confirmationpage: $confirmationpage, historydata: $nothistorydata, titletext: "Pending Notification", negativetext: "No Pending Notification to Acknowledge", specificdata: currentdatas)
                    }
                    if (screenstatus == "History") {
                        notificationsection(currenttoken: $currenttoken, currentuserid: $currentuserid, notificationid: $notificationid, detailtype: $detailtype, notificationdate: $notificationdate, checkin: $checkin, confirmationpage: $confirmationpage, historydata: $historydata, titletext: "History", negativetext: "No Past Notification to Display", specificdata: pastdatas)
                    }
                    HStack {
                        Spacer()
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .default())
                             .frame(width: 40.0, height: 40.0)
                             .foregroundColor(.gray)
                        Spacer()
                    }
                }
                
            }
            else {
                notificationconfirmation(currenttoken: $currenttoken, currentuserid: $currentuserid, notificationid: $notificationid, detailtype: $detailtype, notificationdate: $notificationdate, checkin: $checkin, confirmationpage: $confirmationpage, confirmaccept: $confirmaccept, confirmreject: $confirmreject, rejectionreason: $rejectionreason, notificationrefresh: $notificationrefresh)
                    
            }
            
            
        }
        .padding(.bottom, 20)
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
        
       
      
    }
    
    func updatingstatus(status: String, detailid: Int){
        var url = URL(string: "")
        if status == "Flight" {
            url = URL(string: "https://optimus.syfc.com.sg/application/dfs-detail-update/\(detailid)/")
        } else {
            url = URL(string: "https://optimus.syfc.com.sg/application/simulator-detail-update/\(detailid)/")
        }
        print(url?.absoluteString  ?? "")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        
        var hashbody: [String: AnyHashable] = [
            "": "",
        ]
        
        if confirmaccept == true {
            print("accept true")
            hashbody = [
                "acknowledgement": true
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: hashbody, options: .fragmentsAllowed)
            
            let config = URLSessionConfiguration.default
            config.urlCache = nil
            
            let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
                showLoadingIndicator = false
                guard let data = data, error == nil else {
                    print("something went wrong")
                    print(error!)
                    return
                }
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(response)
                }
                catch {
                    print("ERROR: \(error)")
                    print(error.localizedDescription)
                }
            }
            task.resume()
            confirmaccept = false
        }
        if confirmreject == true {
            print("reject true")
            hashbody = [
                "acknowledgement": false,
                "reject_remark": rejectionreason
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: hashbody, options: .fragmentsAllowed)
            
            let config = URLSessionConfiguration.default
            config.urlCache = nil
            
            let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
                showLoadingIndicator = false
                guard let data = data, error == nil else {
                    print("something went wrong")
                    print(error!)
                    return
                }
                do {
                    let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(response)
                }
                catch {
                    
                    print("ERROR: \(error)")
                    print(error.localizedDescription)
                }
            }
            task.resume()
            confirmreject = false
        }
    }
    
    func pastdata(){
        var returnlist = [notificationcard]()
        pastdfs(){ (results) in
            for items in results{
                
                var item = items
                retrievedate(dateid: item.dfs ?? 0){ (result) in
                    item.datestamp = result
                    item.detail_type = "Flight"
                    item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), \(item.check_in?.dropLast(3) ?? "Error in Retrieving Timing")"
                    returnlist.append(item)
                }
                
            }
        }
        pastsim(){ (results) in
            for items in results{
                var item = items
                retrievedate(dateid: item.sim ?? 0){ (result) in
                    item.datestamp = result
                    item.detail_type = "Simulator"
                    if item.slot == 1 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 08:30"
                    } else if item.slot == 2 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 10:15"
                    } else if item.slot == 3 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 12:00"
                    } else if item.slot == 4 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 13:45"
                    } else if item.slot == 5 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 15:30"
                    } else if item.slot == 6 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 17:15"
                    } else {
                        item.check_in = "Lesson: Error in Retrieving Date & Timing"
                    }
                    returnlist.append(item)
                }
                
            }
        }
        
        Thread.sleep(forTimeInterval: 1)
        let ready = returnlist.sorted(by: {$0.datestamp!.compare($1.datestamp!) == .orderedDescending })
        showLoadingIndicator = false
        DispatchQueue.main.async {
            pastdatas = ready
        }
    }
    
    func currentdata(){
        var returnlist = [notificationcard]()
        currentdfs(){ (results) in
            for items in results{
                var item = items
                retrievedate(dateid: item.dfs ?? 0){ (result) in
                    item.datestamp = result
                    item.detail_type = "Flight"
                    item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), \(item.check_in?.dropLast(3) ?? "Error in Retrieving Timing")"
                    returnlist.append(item)
                }
            }
        }
        currentsim(){ (results) in
            for items in results{
                var item = items
                retrievedate(dateid: item.sim ?? 0){ (result) in
                    item.datestamp = result
                    item.detail_type = "Simulator"
                    if item.slot == 1 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 08:30"
                    } else if item.slot == 2 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 10:15"
                    } else if item.slot == 3 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 12:00"
                    } else if item.slot == 4 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 13:45"
                    } else if item.slot == 5 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 15:30"
                    } else if item.slot == 6 {
                        item.check_in = "Lesson: \(item.datestamp ?? "Error in Retrieving Date"), 17:15"
                    } else {
                        item.check_in = "Lesson: Error in Retrieving Date & Timing"
                    }
                    returnlist.append(item)
                }
            }
        }
        Thread.sleep(forTimeInterval: 1)
        let ready = returnlist.sorted(by: {$0.datestamp!.compare($1.datestamp!) == .orderedDescending })
        showLoadingIndicator = false
        DispatchQueue.main.async {
            currentdatas = ready
        }
    }
    
    func pastdfs(completion: @escaping ([notificationcard]) -> ()){
        var temparray = [notificationcard]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/dfs-detail-past/\(currentuserid)/")
        print(url?.absoluteString ?? "")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                print(error!)
                completion(temparray)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                do {
                    let currentschedule: [notificationcard] = try JSONDecoder().decode([notificationcard].self, from: data)
                    temparray = currentschedule
                    print(currentschedule)
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(temparray)
        }
        task.resume()
    }
    
    func pastsim(completion: @escaping ([notificationcard]) -> ()){
        var temparray = [notificationcard]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/simulator-detail-past/\(currentuserid)/")
        print(url?.absoluteString ?? "")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                print(error!)
                completion(temparray)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                do {
                    let currentschedule: [notificationcard] = try JSONDecoder().decode([notificationcard].self, from: data)
                    temparray = currentschedule
                    print(currentschedule)
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(temparray)
        }
        task.resume()
    }
    
    func currentdfs(completion: @escaping ([notificationcard]) -> ()){
        var temparray = [notificationcard]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/dfs-detail/\(currentuserid)/")
        print(url?.absoluteString ?? "")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                print(error!)
                completion(temparray)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                do {
                    let currentschedule: [notificationcard] = try JSONDecoder().decode([notificationcard].self, from: data)
                    temparray = currentschedule
                    print(currentschedule)
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(temparray)
        }
        task.resume()
    }
    
    func currentsim(completion: @escaping ([notificationcard]) -> ()){
        var temparray = [notificationcard]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/simulator-detail/\(currentuserid)/")
        print(url?.absoluteString ?? "")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                print(error!)
                completion(temparray)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                do {
                    let currentschedule: [notificationcard] = try JSONDecoder().decode([notificationcard].self, from: data)
                    temparray = currentschedule
                    print(currentschedule)
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(temparray)
        }
        task.resume()
    }
    
    func retrievedate(dateid: Int, completion: @escaping (String) -> ()){
        //var temparray = [retrieveddate]()
        var temparray = ""
        let url = URL(string: "https://optimus.syfc.com.sg/application/dfs-list-detail/\(dateid)/")
        print(url?.absoluteString ?? "")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        
        let config = URLSessionConfiguration.default
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                print(error!)
                completion(temparray)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                do {
                    let currentschedule: retrieveddate = try JSONDecoder().decode(retrieveddate.self, from: data)
                    temparray = currentschedule.date_generated ?? ""
                    print(currentschedule)
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(temparray)
        }
        task.resume()
    }
}

struct confirmationsheet : View {
    
    @Binding var currentuserid: Int
    @Binding var token: String
    @Binding var popup: Bool
    @Binding var notificationdate: String
    @Binding var notificationid: Int
    @Binding var attendance: Bool
    @Binding var rejection: Bool
    @State var trigger = ""
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 10){
                Text("Attendance Confirmation for \n -\(notificationdate)")
                    .font(.title2)
                    .bold()
                Text("Please confirm your Attendance")
                    .font(.title3)
                Button( action: {
                    print("Accept")
                    attendance = true
                    popup = false
                } ){
                    Text("Accept")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                Button( action: {
                    print("Reject")
                    rejection = true
                    popup = false
                    
                } ){
                    Text("Reject")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
            .padding(.top, 10)
            .background(Color.white)
            .cornerRadius(25)
            
        }
    }
}

struct acceptsheet : View {
    
    @Binding var currentuserid: Int
    @Binding var token: String
    @Binding var popup: Bool
    @Binding var notificationdate: String
    @Binding var notificationid: Int
    @Binding var confirmaccept: Bool
    @Binding var detailtype: String
    
    var body: some View {
    
        ZStack {
            VStack(spacing: 10){
                Text("Confirm Lesson Appointment")
                    .font(.title2)
                    .bold()
                Text("Are you sure you wish to confirm the booking made?")
                    .font(.title3)
                Button( action: {
                    print("Yes")
                    confirmaccept = true
                } ){
                    Text("Yes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .alert(isPresented: $confirmaccept){ () -> Alert in
                    Alert(title: Text("Booking Confirmation Successful"), message: Text("Your lesson has been successfully accepted."), dismissButton: .default(Text("Okay"), action: {
                        popup = false
                    }))
                }
                Button( action: {
                    print("No")
                    popup = false
                } ){
                    Text("No")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
            .padding(.top, 10)
            .background(Color.white)
            .cornerRadius(25)
        }
    }
}

struct rejectsheet : View {
    
    @Binding var currentuserid: Int
    @Binding var token: String
    @Binding var popup: Bool
    @Binding var notificationdate: String
    @Binding var notificationid: Int
    @Binding var confirmreject: Bool
    @Binding var detailtype: String
    
    var body: some View {
    
        ZStack {
            VStack(spacing: 10){
                Text("Reject Lesson Appointment")
                    .font(.title2)
                    .bold()
                Text("Are you sure you wish to cancel the booking made?")
                    .font(.title3)
                Button( action: {
                    print("Yes")
                    confirmreject = true
                } ){
                    Text("Yes")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
                .alert(isPresented: $confirmreject){ () -> Alert in
                    Alert(title: Text("Booking Rejection Successful"), message: Text("Your lesson has been successfully rejected."), dismissButton: .default(Text("Okay"), action: {
                        popup = false
                    }))
                }
                Button( action: {
                    print("No")
                    popup = false
                } ){
                    Text("No")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                }
            }
            .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
            .padding(.top, 10)
            .background(Color.white)
            .cornerRadius(25)
        }
    }
}
