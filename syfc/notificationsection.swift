//
//  notificationsection.swift
//  newsyfc
//
//  Created by Admin on 19/5/22.
//

import Foundation
import SwiftUI

struct notificationsection: View {
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    @Binding var notificationid: Int
    @Binding var detailtype: String
    @Binding var notificationdate: String
    @Binding var checkin: String
    @Binding var confirmationpage: Bool
    @Binding var historydata: Bool
    
    var titletext: String = ""
    var negativetext: String = ""
    var specificdata: [notificationcard] = []
    
    var body: some View {
        VStack{
            HStack{
                Text(titletext)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                            
                Spacer()
            }
            .background(Rectangle().foregroundColor(.bluecolour))
            .frame(maxWidth: .infinity)
            
            if (specificdata.count > 0) {
                ForEach(0...(specificdata.count - 1), id: \.self){ i in
                    Button(
                        action: {
                            if(historydata == false){ //supposed to be false
                                if(specificdata[i].acknowledgement == nil){ // supposed to be == nill
                                    notificationdate = specificdata[i].datestamp!
                                    notificationid = specificdata[i].detail_id!
                                    detailtype = specificdata[i].detail_type!
                                    checkin = specificdata[i].check_in!
                                    confirmationpage = true
                                }
                                else {
                                    self.disabled(true)
                                    self.animation(nil)
                                }
                            }
                            else {
                                self.disabled(true)
                                self.animation(nil)
                            }
                            
                        }
                    ){
                        if(specificdata[i].detail_type == "Flight"){
                            HStack(spacing: 30){
                                if(specificdata[i].acknowledgement == true){
                                    Image(systemName: "airplane")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.green)
                                } else if (specificdata[i].acknowledgement == false){
                                    Image(systemName: "airplane")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "airplane")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                                VStack(spacing: 20){
                                    HStack{
                                        Text(specificdata[i].detail_type ?? "Error")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    HStack{
                                        Text(specificdata[i].check_in ?? "Error")
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                        } else {
                            HStack(spacing: 30){
                                if(specificdata[i].acknowledgement == true){
                                    Image(systemName: "desktopcomputer")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.green)
                                } else if (specificdata[i].acknowledgement == false){
                                    Image(systemName: "desktopcomputer")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "desktopcomputer")
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                                VStack(spacing: 20){
                                    HStack{
                                        Text(specificdata[i].detail_type ?? "Error")
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    HStack{
                                        Text(specificdata[i].check_in ?? "Error")
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15.0)
                            .foregroundColor(.white)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0.0, y: 0.0)
                    )
                    .padding(.horizontal)
                }
            } else {
                Text(negativetext)
                    .foregroundColor(.black)
                    .bold()
            }
        }
        .ignoresSafeArea(.keyboard)
    }
}
