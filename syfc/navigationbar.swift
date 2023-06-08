//
//  navigationbar.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import Foundation
import SwiftUI

struct navigationbar: View {
    @Binding var screenstatus: String
    @Binding var calendarrefresh: Bool
    @Binding var notificationrefresh: Bool
    @Binding var reselectdate: Bool
    
    @State var logoutbutton: Bool = false
    @State var refreshbutton: Bool = false
    
    var titlename:String = ""
    var selecteddatestring: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
                Button(action: {
                    screenstatus = "Profile"
                    sendLocalNotification()
                }) {
                    if(screenstatus == "Profile"){
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.bluecolour)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Button(action: {
                    screenstatus = "Calendar"
                    sendLocalNotification()
                }) {
                    if(screenstatus == "Calendar"){
                        Image(systemName: "calendar")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.bluecolour)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "calendar")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Button(action: {
                    screenstatus = "Notification"
                    sendLocalNotification()
                }) {
                    if(screenstatus == "Notification"){
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.bluecolour)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "bell")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Button(action: {
                    screenstatus = "History"
                    sendLocalNotification()
                }) {
                    if(screenstatus == "History"){
                        Image(systemName: "bell.and.waveform")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.bluecolour)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "bell.and.waveform")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Button(action: {
                    if(screenstatus == "Calendar" || screenstatus == "Notification" || screenstatus == "History"){
                        refreshbutton = true
                        sendLocalNotification()
                    }
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                }
                .alert(isPresented: $refreshbutton) { () -> Alert in
                    Alert(
                        title: Text("Refresh Button Selected"),
                        message: Text("Are you sure you would like to refresh the current data?"),
                        primaryButton: .default(Text("Yes"),
                                                action: {
                                                    if(screenstatus == "Calendar"){
                                                        calendarrefresh.toggle()
                                                        reselectdate = true
                                                    }
                                                    if(screenstatus == "Notification"){
                                                        notificationrefresh.toggle()
                                                    }
                                                }),
                        secondaryButton: .default(Text("No")))
                }
                
                Button(action: {
                    screenstatus = "Settings"
                    sendLocalNotification()
                }) {
                    if(screenstatus == "Settings"){
                        Image(systemName: "gearshape")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.bluecolour)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.black.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                Button(action: {
                    logoutbutton = true
                }) {
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.black)
                        .padding(10)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                }
                .alert(isPresented: $logoutbutton) { () -> Alert in
                    Alert(
                        title: Text("Logout Button Selected"),
                        message: Text("Are you sure you would like to logout of your account now?"),
                        primaryButton: .default(Text("Yes"),
                                                action: {
                                                    if let appDomain = Bundle.main.bundleIdentifier {
                                                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                                                    }
                                                    screenstatus = ""
                                                    sendLocalNotification()
                                                }),
                        secondaryButton: .default(Text("No")))
                }
            }
            .padding(.horizontal)
            .padding(.top, 40)
            .padding(.bottom, 5)
            
            HStack{
                Text(titlename)
                .font(.title3)
                .bold()
                .foregroundColor(.white)
                .padding()
                            
                Spacer()
                
                Text(selecteddatestring)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Rectangle().foregroundColor(.orangecolour))
            .frame(maxWidth: .infinity)
        }
    }
    
    func sendLocalNotification() {
        NotificationCenter.default.post(name: NSNotification.Name("ScreenStatusChanged"), object: screenstatus)
    }
}

