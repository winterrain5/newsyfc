//
//  profile.swift
//  syfc
//
//  Created by Admin on 17/8/22.
//

import SwiftUI

struct profilepage: View {
    @Binding var screenstatus: String
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var profilelist: [profileData]
    
    @State var calendarrefresh: Bool = false
    @State var notificationrefresh: Bool = false
    @State var reselectdate: Bool = false
    
    @State var name: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var course: String = ""
    
    
    var body: some View {
        VStack{
            navigationbar(screenstatus: $screenstatus, calendarrefresh: $calendarrefresh, notificationrefresh: $notificationrefresh, reselectdate: $reselectdate, titlename: "My Profile", selecteddatestring: "")
          
            Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20){
                
                if(profilelist.count != 0){
                    let phone = String(format: "%tu", profilelist[0].student?.student_id?.hp ?? 0)

                    GridRow {
                        Text("Name: ")
                        Text(profilelist[0].student?.student_id?.name ?? "")
                    }
                    GridRow {
                        Text("Email: ")
                        Text(profilelist[0].student?.student_id?.email ?? "")
                    }
                    GridRow {
                        Text("Phone: ")
                        Text(phone)
                    }
                    GridRow {
                        Text("Course: ")
                        Text(profilelist[0].course?.course_class ?? "")
                    }
                    GridRow {
                        Text("Status: ")
                        let iName = profilelist.first(where: { (Int($0.lesson?.identity_name ?? "") ?? 0) > 17 })
                        if iName != nil {
                            Text("PPL")
                        } else {
                            Text("BFC")
                        }
                        
                    }
                } else {
                    GridRow {
                        Text("Name: ")
                        Text("")
                    }
                    GridRow {
                        Text("Email: ")
                        Text("")
                    }
                    GridRow {
                        Text("Phone: ")
                        Text("")
                    }
                    GridRow {
                        Text("Course: ")
                        Text("")
                    }
                    GridRow {
                        Text("Status: ")
                        Text("")
                        
                    }
                }
                
            }
            
            ScrollView(.horizontal){
                Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 20) {
                    GridRow {
                        Text("DATE")
                            .frame(width: 100)
                        Text("TAKE OFF TIME")
                            .frame(width: 120)
                        Text("SORTIE NO.")
                            .frame(width: 100)
                        Text("SORTIE STATUS")
                            .frame(width: 125)
                        Text("DUAL HOURS")
                            .frame(width: 110)
                        Text("SOLO HOURS")
                            .frame(width: 110)
                    }
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                }
                ScrollView(.vertical) {
                   
                    Grid(alignment: .leading, horizontalSpacing: 0, verticalSpacing: 20) {
                       
                        
                        ForEach(profilelist) { profile in
                            GridRow {
                                Text(profile.instructor_flight?.date_flown ?? "")
                                    .frame(width: 100)
                                Text(profile.instructor_flight?.take_off_time ?? "")
                                    .frame(width: 120)
                                Text(profile.lesson?.identity_name ?? "")
                                    .frame(width: 100)
                                Text(profile.instructor_flight?.sortie_status ?? "")
                                    .frame(width: 125)
                                Text(String(profile.instructor_flight?.day_dual_hr ?? 0))
                                    .frame(width: 110)
                                Text(String(profile.instructor_flight?.day_pic_hr ?? 0))
                                    .frame(width: 110)
                            }
                            .padding(.horizontal, 20)
                            Divider()
                                .foregroundColor(.gray)
                                .padding(.horizontal, 20)
                            
                                
                                
                        }
                    }
                }
            }
        }
        .padding(.bottom, 40)
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    
}

