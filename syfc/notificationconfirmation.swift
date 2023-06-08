//
//  notificationconfirmation.swift
//  newsyfc
//
//  Created by Admin on 19/5/22.
//

import Foundation
import SwiftUI

struct notificationconfirmation: View {
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var notificationid: Int
    @Binding var detailtype: String
    @Binding var notificationdate: String
    @Binding var checkin: String
    @Binding var confirmationpage: Bool
    @Binding var confirmaccept: Bool
    @Binding var confirmreject: Bool
    @Binding var rejectionreason: String
    @Binding var notificationrefresh: Bool
    
    @State var acceptbutton: Bool = false
    @State var rejectbutton: Bool = false
    
    var body: some View {
        VStack(spacing:10){
            HStack{
                Spacer()
                Button(
                    action:{
                        confirmaccept = false
                        confirmreject = false
                        confirmationpage = false
                    }
                ){
                    Text("Back")
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15.0)
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0.0, y: 0.0)
                )
                .padding(.horizontal)
            }
            
            VStack{
                if(detailtype == "Flight"){
                    HStack(spacing: 30){
                        Image(systemName: "airplane")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        VStack(spacing: 20){
                            HStack{
                                Text(detailtype)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            HStack{
                                Text(checkin)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15.0)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0.0, y: 0.0)
                    )
                    .padding(.horizontal)
                }
                else {
                    HStack(spacing: 30){
                        Image(systemName: "desktopcomputer")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                        VStack(spacing: 20){
                            HStack{
                                Text(detailtype)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            HStack{
                                Text(checkin)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15.0)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0.0, y: 0.0)
                    )
                    .padding(.horizontal)
                }
            }
            
            VStack{
                Text("Would you like to confirm this booking?")
                    .bold()
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                Button(
                    action:{
                        acceptbutton = true
                    }
                ){
                    Text("Confirm")
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.bluecolour)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
                .alert(isPresented: $acceptbutton) { () -> Alert in
                    Alert(
                        title: Text("Booking Confirmation Successful"),
                        message: Text("Your lesson has been successfully accepted."),
                        dismissButton: .default(Text("Okay"),
                                                action: {
                                                    confirmaccept = true
                                                    confirmreject = false
                                                    confirmationpage = false
                                                    notificationrefresh.toggle()
                                                }))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15.0)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0.0, y: 0.0)
            )
            .padding(.horizontal)
            
            VStack{
                Text("Are you sure you would like to reject this booking?\n\nPlease provide us with a reason for rejection below: ")
                    .bold()
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                
                TextField("Reason: ", text: $rejectionreason)
                    .padding()
                    .foregroundColor(.black)
                
                Divider()
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Button(
                    action:{
                        rejectbutton = true
                    }
                ){
                    Text("Reject")
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.bluecolour)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
                .alert(isPresented: $rejectbutton) { () -> Alert in
                    Alert(
                        title: Text("Booking Rejection Successful"),
                        message: Text("Your lesson has been successfully rejected."),
                        dismissButton: .default(Text("Okay"),
                                                action: {
                                                    confirmreject = true
                                                    confirmaccept = false
                                                    confirmationpage = false
                                                    notificationrefresh.toggle()
                                                }))
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15.0)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0.0, y: 0.0)
            )
            .padding(.horizontal)
        }
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .edgesIgnoringSafeArea(.top)
        .edgesIgnoringSafeArea(.bottom)
    }
}
