//
//  mainpage.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import Foundation
import SwiftUI
import ActivityIndicatorView
import PromiseKit
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
                            .showClearButton($username)
                            
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
                            .showClearButton($password)
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
                                
                    
                                print("username=\(username)")
                                if(username == "fooyg" || username == "tansk" || username == "tohbh" || username == "tttwo"  || username == "ttone"){
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
                print("login_api went wrong")
                showLoadingIndicator = false
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

                    when(fulfilled: retrievedates(), holidates(), dfsApprovalList(), loadProfilePage(), registerdeviceid(deviceid: deviceToken)).done { (schedules, holidays, dfsData, profileData, _) in
                        mainschedulelist = schedules
                        mainholidaylist = holidays
                        dfslist = dfsData
                        profilelist = profileData
                        print("数据请求完毕")
                        if(username == "fooyg" || username == "tansk" || username == "tohbh" || username == "tttwo"  || username == "ttone"){
                            screenstatus = "DFS"
                        } else {
                            if (currentuserid == 0) {
                                screenstatus = "Instructor"
                            }else {
                                screenstatus = "Profile"
                            }
                        }
                    }.catch { e in
                        DispatchQueue.main.async {
                            denylogin = true
                            showLoadingIndicator = false
                        }
                        print(e.localizedDescription)
                    }
                    
                  
                    
                   
                } catch {
                    print(error.localizedDescription)
                    print("Incorrect username or password. Please try again.")
                    DispatchQueue.main.async {
                        denylogin = true
                        showLoadingIndicator = false
                    }
                }
            }
            catch {
                print("ERROR: \(error)")
            }
        }
        task.resume()
    }
    
    func retrievedates() -> Promise<[schedules]>{
        
        Promise.init { resolver in
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
                    print("retrievedates went wrong \(error!)")
                    resolver.reject(error!)
                    return
                }
                do {
                    try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    do {
                        let currentschedule: [schedules] = try JSONDecoder().decode([schedules].self, from: data)
                        retrieveddates = currentschedule
                  
                        
                    } catch {
                        print("retrievedates went wrong \(error)")
                        print(error.localizedDescription)
                    }
                }
                catch {
                    resolver.reject(error)
                    print("retrievedates went wrong \(error)")
                }
                resolver.fulfill(retrieveddates)
            }
            task.resume()
        }
    
        
    }
    
    func holidates() -> Promise<[holidays]>{
        Promise.init { resolver in
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
                    print("holidates went wrong \(error!)")
                    resolver.reject(error!)
                    return
                }
                do {
                    try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    do {
                        let currentschedule: [holidays] = try JSONDecoder().decode([holidays].self, from: data)
                        retrieveddates = currentschedule
                       
                        
                    } catch {
                        resolver.reject(error)
                        print("holidates went wrong \(error)")
                    }
                } catch {
                    resolver.reject(error)
                    print("holidates went wrong \(error)")
                }
                resolver.fulfill(retrieveddates)
            }
            task.resume()
        }
        
    }
    
    func dfsApprovalList() -> Promise<[dfsData]>{
        Promise.init { resolver in
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
                    print("dfsApprovalList went wrong \(error!)")
                    resolver.reject(error!)
                    return
                }
                do {
                    try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    do {
                        let loaddfslist: [dfsData] = try JSONDecoder().decode([dfsData].self, from: data)
                        dfsapprovallist = loaddfslist
                        
                    } catch {
                        resolver.reject(error)
                        print("dfsApprovalList went wrong \(error)")
                    }
                }
                catch {
                    resolver.reject(error)
                    print("dfsApprovalList went wrong \(error)")
                }
                resolver.fulfill(dfsapprovallist)
            }
            task.resume()
        }
        
    }
    
    func loadProfilePage() -> Promise<[profileData]>{
        Promise.init { resolver in
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
                    print("loadProfilePage went wrong \(error!)")
                    resolver.reject(error!)
                    return
                }
                do {
                    try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    
                    do {
                        let loadprofilelist: [profileData] = try JSONDecoder().decode([profileData].self, from: data)
                        profilepagedata = loadprofilelist
                        
                    } catch {
                        resolver.reject(error)
                        print("loadProfilePage went wrong \(error)")
                    }
                }
                catch {
                    resolver.reject(error)
                    print("loadProfilePage went wrong \(error)")
                }
                resolver.fulfill(profilepagedata)
            }
            task.resume()
        }
        
    }
    
    func registerdeviceid(deviceid: String) -> Promise<Void>{
        Promise.init { resolver in
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
                    print("registerdeviceid went wrong \(error!)")
                    resolver.reject(error!)
                    return
                }
                
                resolver.fulfill_()
            }
            task.resume()
        }
        
       
    }
}

struct TextFieldClearButton: ViewModifier {
    @Binding var fieldText: String

    func body(content: Content) -> some View {
        content
            .overlay {
                if !fieldText.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            fieldText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(fieldText: text))
    }
}
