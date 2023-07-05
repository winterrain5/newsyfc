//
//  dfsnavigation.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import Foundation
import SwiftUI
import AlertToast
struct dfsnavigationbar: View {
    @Binding var screenstatus: String
    @Binding var currenttoken: String
    @Binding var currentuserid: Int
    
    var currentdfsid: Int
    
    @State var logoutbutton: Bool = false
    @State var firstpopup: Bool = false
    @State var approvedSuccess: Bool = false
    @State var approvedFailed: Bool = false
    @State var rejectpopup: Bool = false
    @State var rejectConfirmPopup: Bool = false
    
    var titlename:String = ""
    var selecteddatestring: String = ""
    
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                
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
                .alert(isPresented: $rejectConfirmPopup) { () -> Alert in
                    Alert(
                        title: Text("Reject DFS"),
                        message: Text("DFS has been Reject."),
                        dismissButton: .default(Text("Okay"), action: {
                        }))
                }
                
                            
                Spacer()
                
//                Button(action: {
//                    rejectpopup = true
//                }) {
//                    Text("Reject")
//                        .font(.title3)
//                        .bold()
//                        .foregroundColor(.white)
//                        .padding()
//                }
//                .alert(isPresented: $rejectpopup) { () -> Alert in
//                    Alert(
//                        title: Text("Reject DFS"),
//                        message: Text("Are you sure you would like to Reject this DFS?"),
//                        primaryButton: .default(Text("Yes"),
//                                                action: {
////                                                    approveDFS(dfsid: currentdfsid)
//                                                    rejectConfirmPopup = true
//                                                    rejectpopup = false
//                                                }),
//                        secondaryButton: .default(Text("No"),
//                                                  action: {
//                                                      rejectpopup = false
//                                                  })
//                    )
//                }
                
                
                Spacer()
                
                Button(action: {
                    firstpopup = true
                }) {
                    Text("Approve")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                }
                .alert(isPresented: $firstpopup) { () -> Alert in
                    Alert(
                        title: Text("Approve DFS"),
                        message: Text("Are you sure you would like to approve this DFS?"),
                        
                        primaryButton: .default(Text("Yes"),
                                                action: {
                                                    approveDFS(dfsid: currentdfsid)
                                                    firstpopup = false
                                                }),
                        secondaryButton: .default(Text("No"),action: {
                            firstpopup = false
                        })
                    )
                }
                
                
            }
            .background(Rectangle().foregroundColor(.orangecolour))
            .frame(maxWidth: .infinity)
        }.toast(isPresenting: $approvedSuccess) {
            AlertToast(displayMode: .hud, type: .complete(.green),title: "DFS has been approved")
        }.toast(isPresenting: $approvedFailed) {
            AlertToast(displayMode: .hud, type: .error(.red),title: "DFS approve failed")
        }
    }
    
    func approveDFS(dfsid: Int) {
        
        if dfsid == 0 {
            approvedFailed = true
            return
        }

        let params:[String:Any] = ["approved":true,"instructor":currentuserid]
        let body = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        
        let url = URL(string: "https://optimus.syfc.com.sg/application/mobile-approve/\(dfsid)/")
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token \(currenttoken)", forHTTPHeaderField: "Authorization")
        request.httpBody = body
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        let task = URLSession.init(configuration: config).dataTask(with: request) { data, _, error in
            guard let _ = data, error == nil else {
                print("something went wrong")
                print(error!)
                approvedFailed = true
                return
            }
            approvedSuccess = true
        }
        task.resume()
        
    }
}

