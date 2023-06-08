//
//  mainpage.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import Foundation
import SwiftUI
import ActivityIndicatorView
//import
struct mainpage: View {
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var screenstatus: String
    @Binding var mainschedulelist: [schedules]
    @Binding var mainholidaylist: [holidays]
    @Binding var dfslist: [dfsData]
    @Binding var profilelist: [profileData]
    @Binding var deviceToken: String
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var test: String = ""
    @State var login: Bool = false
    @State var denylogin: Bool = false
    @State var showLoadingIndicator: Bool = false
    
    @StateObject private var keyboardHandler = keyboardhandler()
    
    var body: some View {
        GeometryReader { geometry in
            
            ScrollView{
                VStack{
                    VStack{
                        Image("mainpicture")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .scaleEffect(x: 1.2, y: 1.2)
                        Spacer()
                        Image("banner")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                        Spacer()
                    }
                    
                    HStack{
                        Text("username: ")
                            .foregroundColor(.gray)
                            .bold()
                        
                        TextField("username", text: $username)
                            .foregroundColor(.black)
                            
                    }
                  
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Divider()
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    HStack {
                        Text("password: ")
                            .foregroundColor(.gray)
                            .bold()
                        
                        SecureField("password", text: $password)
                            .foregroundColor(.black)
                            .alert(isPresented: $denylogin) { () -> Alert in
                                Alert(
                                    title: Text("Login Unsuccessful"),
                                    message: Text("Please make sure that you have entered the correct username and password."),
                                    dismissButton: .default(Text("Okay")))
                            }
                    }
                    .padding(.horizontal, 20)
                    
                    Divider()
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    
                    Button(
                        action: {
                            fetchdata(username: username, password: password)
                        }
                    ){
                        Text("LOGIN")
                            .padding(10)
                            .frame(maxWidth: .infinity)
                    }
                    .background(Color.bluecolour)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .alert(isPresented: $login) { () -> Alert in
                        Alert(
                            title: Text("Login Successful"),
                            message: Text("Welcome " + username),
                            dismissButton: .default(Text("Okay"), action: {
                                
                                //
                                //UserDefaults.standard.set(mainschedulelist, forKey: "mainschedulelist")
                                //let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: mainschedulelist)
                                //UserDefaults.standard.set(encodedData, forKey: "mainschedulelist")
                                //let encodedData2: Data = NSKeyedArchiver.archivedData(withRootObject: mainholidaylist)
                                //UserDefaults.standard.set(encodedData2, forKey: "mainholidaylist")
                                //[NSUserDefaults standardUserDefaults] synchronize
                                //UserDefaults.standard.synchronize()
                                print("username=\(username)")
                                if(username == "fooyg" || username == "tansk" || username == "tohbh" || username == "tttwo" ){
                                    screenstatus = "DFS"
                                } else {
                                    if (currentuserid == 0) {
                                        screenstatus = "Instructor"
                                    }else {
                                        screenstatus = "Profile"
                                    }
                                }
                            }))
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                //.padding(.vertical, 20)
                //.ignoresSafeArea(.keyboard)
                .background(Color.white)
                //.edgesIgnoringSafeArea(.bottom)
                //.padding(.bottom, keyboardHandler.keyboardHeight)
                //.animation(.default)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
            
                 
        }
        HStack {
            Spacer()
            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .default())
                 .frame(width: 40.0, height: 40.0)
                 .foregroundColor(.gray)
            Spacer()
        }
       
    }
    
    func fetchdata(username: String, password: String){
        print("starting function")
        showLoadingIndicator = true
        if username == "" || password == "" {
            print("Please enter your username and password to proceed.")
            denylogin = true
        }
        
        guard let url = URL(string: "https://optimus.syfc.com.sg/application/login_api") else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let hashbody: [String: AnyHashable] = [
            "username": username,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: hashbody, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                print("something went wrong")
                return
            }
            
            do {
                
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(response)")
                do {
                    let currentuser = try JSONDecoder().decode(Users.self, from: data)
                    print(currentuser.token!)
                    print("Login Successful")
                    currenttoken = currentuser.token!
                    currentuserid = currentuser.student!
//                    UserDefaults.standard.set(currenttoken, forKey: "currenttoken")
//                    UserDefaults.standard.set(currentuserid, forKey: "currentuserid")
                    //UserDefaults.standard.set("Calendar", forKey: "screenstatus")
                    
                    let datesgroup = DispatchGroup()
                    datesgroup.enter()
                    retrievedates(){ (result) in
                        mainschedulelist = result
                        datesgroup.leave()
                    }
                    datesgroup.wait()
                    
                    let holidaygroup = DispatchGroup()
                    holidaygroup.enter()
                    holidates(){ (result) in
                        mainholidaylist = result
                        holidaygroup.leave()
                    }
                    holidaygroup.wait()
                    
                    let dfsgroup = DispatchGroup()
                    dfsgroup.enter()
                    dfsApprovalList(){ (result) in
                        dfslist = result
                        dfsgroup.leave()
                    }
                    dfsgroup.wait()
                    
                    let profilegroup = DispatchGroup()
                    profilegroup.enter()
                    loadProfilePage(){ (result) in
                        profilelist = result
                        profilegroup.leave()
                    }
                    profilegroup.wait()
                    
                    registerdeviceid(deviceid: deviceToken)
                    
                    login = true
                    showLoadingIndicator = false
                } catch {
                    print(error.localizedDescription)
                    print("Incorrect username or password. Please try again.")
                    denylogin = true
                    showLoadingIndicator = false
                }
            }
            catch {
                print("ERROR: \(error)")
                showLoadingIndicator = false
            }
        }
        task.resume()
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
                showLoadingIndicator = false
                print("something went wrong")
                print(error!)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                do {
                    let currentschedule: [schedules] = try JSONDecoder().decode([schedules].self, from: data)
                    retrieveddates = currentschedule
                    //UserDefaults.standard.set(retrieveddates, forKey: "mainschedulelist")
                    //let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: retrieveddates)
                    //UserDefaults.standard.set(encodedData, forKey: "mainschedulelist")
                    
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
    
    func holidates(completion: @escaping ([holidays]) -> ()){
        var retrieveddates = [holidays]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/singapore-holiday/")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                showLoadingIndicator = false
                print("something went wrong")
                print(error!)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                do {
                    let currentschedule: [holidays] = try JSONDecoder().decode([holidays].self, from: data)
                    retrieveddates = currentschedule
                    //UserDefaults.standard.set(retrieveddates, forKey: "mainholidaylist")
                    //let encodedData2: Data = NSKeyedArchiver.archivedData(withRootObject: retrieveddates)
                    //UserDefaults.standard.set(encodedData2, forKey: "mainholidaylist")
                    
                    
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            } catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(retrieveddates)
        }
        task.resume()
    }
    
    func dfsApprovalList(completion: @escaping ([dfsData]) -> ()){
        var dfsapprovallist = [dfsData]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/dfs-detail-list/")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                showLoadingIndicator = false
                print("something went wrong")
                print(error!)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                do {
                    let loaddfslist: [dfsData] = try JSONDecoder().decode([dfsData].self, from: data)
                    dfsapprovallist = loaddfslist
                    
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(dfsapprovallist)
        }
        task.resume()
    }
    
    func loadProfilePage(completion: @escaping ([profileData]) -> ()){
        var profilepagedata = [profileData]()
        let url = URL(string: "https://optimus.syfc.com.sg/application/profile-dfs-detail/\(currentuserid)/" )
        //let url = URL(string: "https://optimus.syfc.com.sg/application/profile-dfs-detail/210/" )
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                showLoadingIndicator = false
                print("something went wrong")
                print(error!)
                return
            }
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
                do {
                    let loadprofilelist: [profileData] = try JSONDecoder().decode([profileData].self, from: data)
                    profilepagedata = loadprofilelist
                    
                } catch {
                    print(error)
                    print(error.localizedDescription)
                }
            }
            catch {
                print("ERROR: \(error)")
                print(error.localizedDescription)
            }
            completion(profilepagedata)
        }
        task.resume()
    }
    
    func registerdeviceid(deviceid: String){
        
        guard let url = URL(string: "https://optimus.syfc.com.sg/application/student-detail-update/\($currentuserid)") else {
            print("url error")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        
        let hashbody: [String: AnyHashable] = [
            "device_id": deviceid,
            "device_type": "iOS"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: hashbody, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                showLoadingIndicator = false
                print("something went wrong")
                return
            }
            
            do {
                try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("device id successful")
            }
            catch {
                print("ERROR: \(error)")
            }
        }
        task.resume()
    }
}
