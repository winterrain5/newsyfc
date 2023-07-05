//
//  dfspage.swift
//  syfc
//
//  Created by Admin on 17/8/22.
//

import SwiftUI

struct dfspage: View {
    @Binding var screenstatus: String
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var dfslist: [dfsData]
    
    @State var calendarrefresh: Bool = false
    @State var notificationrefresh: Bool = false
    @State var reselectdate: Bool = false
    
    
    var body: some View {
        
        VStack{
            dfsnavigationbar(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid, currentdfsid: dfslist.first?.dfs ?? 0, titlename: "DFS Approval Page")
            
            ScrollView(.horizontal){
                ScrollView(.vertical) {
                    Grid(alignment: .leading, horizontalSpacing: 20, verticalSpacing: 20) {
                        
                        GridRow {
                            Text("#")
                            Text("ETD")
                            Text("A/C REG")
                            Text("C/S")
                            Text("PILOT")
                            Text("CREW")
                            Text("SORTIE")
                            Text("DURN")
                            Text("CSE NO.")
                            Text("PLANNING REMARKS")
                        }
                        .foregroundColor(.gray)
                        .padding(.horizontal,16)
                        
                        ForEach(dfslist) { dfs in
                            GridRow {
                                Text(String(dfs.detail_order ?? 0))
                                Text(dfs.check_in ?? "")
                                Text(dfs.aircraft?.aircraft_name ?? "")
                                
                                if(dfs.instructor?.instructor_name == nil && dfs.student?.ops_name != nil){
                                    Text("9V-Y" + (dfs.aircraft?.aircraft_name ?? ""))
                                }
                                else if (dfs.instructor?.instructor_name != nil && dfs.student?.ops_name == nil && dfs.secondary_instructor?.instructor_name == nil && dfs.pax == nil){
                                    Text("9V-Y" + (dfs.aircraft?.aircraft_name ?? ""))
                                }
                                else if (dfs.instructor?.instructor_name != nil && dfs.student?.ops_name == nil && dfs.secondary_instructor?.instructor_name == nil && dfs.pax == ""){
                                    Text("9V-Y" + (dfs.aircraft?.aircraft_name ?? ""))
                                }
                                else {
                                    Text(dfs.instructor?.callsign ?? "")
                                }
                                
                                if(dfs.instructor?.instructor_name == nil && dfs.student?.ops_name != nil){
                                    Text(dfs.student?.ops_name ?? "")
                                }
                                else {
                                    Text(dfs.instructor?.instructor_name ?? "")
                                }
                                
                                if (dfs.instructor?.instructor_name == nil && dfs.student?.ops_name != nil){
                                    Text("SOLO")
                                }
                                else if (dfs.instructor?.instructor_name != nil && dfs.student?.ops_name == nil && dfs.secondary_instructor?.instructor_name == nil && dfs.pax == nil){
                                    Text("SOLO")
                                }
                                else if (dfs.instructor?.instructor_name != nil && dfs.student?.ops_name == nil && dfs.secondary_instructor?.instructor_name == nil && dfs.pax == ""){
                                    Text("SOLO")
                                }
                                else if (dfs.instructor?.instructor_name != nil && dfs.secondary_instructor?.instructor_name != nil) {
                                    Text(dfs.secondary_instructor?.instructor_name ?? "")
                                }
                                else if (dfs.instructor?.instructor_name != nil && dfs.pax != nil && dfs.pax != "") {
                                    Text(dfs.pax ?? "")
                                }
                                else {
                                    Text(dfs.student?.ops_name ?? "")
                                }
                                
                                
                                
                                Text(dfs.lesson?.identity_name ?? "")
                                Text(String(dfs.total_hr ?? 0))
                                Text(dfs.course?.course_class ?? "")
                                Text(dfs.remarks ?? "")
                                //Text(dfs.acknowledgement ?? "")
                            }
                            .padding(.horizontal,16)
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

