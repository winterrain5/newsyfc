//
//  newsyfcApp.swift
//  newsyfc
//
//  Created by Admin on 15/5/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAnalytics
import UserNotifications

@main
struct syfcApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var currentuserid: Int = 0
    @State var currenttoken: String = ""
    @State var screenstatus: String = ""
    @State var mainschedulelist = [schedules]()
    @State var mainholidaylist = [holidays]()
    @State var dfsmainlist = [dfsData]()
    @State var profilelist = [profileData]()
    @State var rememberuser = true
    @State var FCMToken = ""
    
    init() {
        //if(UserDefaults.standard.string(forKey: "currenttoken") != nil){
          //  currenttoken = UserDefaults.standard.string(forKey: "currenttoken")!
            //currentuserid = Int(UserDefaults.standard.integer(forKey: "currentuserid")) as Int
            //screenstatus = UserDefaults.standard.string(forKey: "screenstatus") ?? ""
            //mainschedulelist = UserDefaults.standard.array(forKey: "mainschedulelist") as? [schedules] ?? [schedules]()
            //mainholidaylist = UserDefaults.standard.array(forKey: "mainholidaylist") as? [holidays] ?? [holidays]()
            
            //let decoded  = UserDefaults.standard.data(forKey: "mainschedulelist")!
            //let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [schedules]
            
            //print(decodedTeams)
            //print("done")
            //print(currentuserid)
            
        //}
       
    }
    
    var body: some Scene {
        WindowGroup {
            
            if(screenstatus == "" && UserDefaults.standard.string(forKey: "currentuserid") == nil){
                mainpage(currenttoken: $currenttoken, currentuserid: $currentuserid, screenstatus: $screenstatus, mainschedulelist: $mainschedulelist, mainholidaylist: $mainholidaylist, dfslist: $dfsmainlist, profilelist: $profilelist, deviceToken: $FCMToken)
            }
            if(screenstatus == "" && UserDefaults.standard.string(forKey: "currentuserid") != nil && rememberuser == true){
                calendarpage(currenttoken: $currenttoken, currentuserid: $currentuserid, screenstatus: $screenstatus, mainschedulelist: $mainschedulelist, mainholidaylist: $mainholidaylist)
            }
            if(screenstatus == "Calendar"){
                calendarpage(currenttoken: $currenttoken, currentuserid: $currentuserid, screenstatus: $screenstatus, mainschedulelist: $mainschedulelist, mainholidaylist: $mainholidaylist)
            }
            if(screenstatus == "Notification"){
                notificationpage(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid)
            }
            if(screenstatus == "History"){
                notificationpage(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid)
            }
            if(screenstatus == "Settings"){
                settingspage(screenstatus: $screenstatus)
            }
            if(screenstatus == "DFS"){
                dfspage(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid, dfslist: $dfsmainlist)
            }
            if(screenstatus == "Profile"){
                profilepage(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid, profilelist: $profilelist)
            }
            if(screenstatus == "Instructor"){
                instructorpage(screenstatus: $screenstatus, currenttoken: $currenttoken, currentuserid: $currentuserid)
            }
        }
    }
}

extension UIColor {
    convenience init (hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.dropFirst())
        self.init(red: .init(strtoul(String(chars[0...1]),nil,16))/255,
                  green: .init(strtoul(String(chars[2...3]),nil,16))/255,
                  blue: .init(strtoul(String(chars[4...5]),nil,16))/255,
                  alpha: alpha)
    }
}

extension Color {
    static let orangecolour = Color(UIColor(hexaString: "#DF412C"))
    static let bluecolour = Color(UIColor(hexaString: "#16588D"))
}

struct Users: Codable {
    var token: String!
    var user_id: Int!
    var username: String!
    var password: String!
    var student: Int!
    var non_field_errors: String!
}

class schedules: NSObject, NSCoding, Codable {
    func encode(with coder: NSCoder) {
        coder.encode(lesson_date, forKey: "lesson_date")
        coder.encode(student_available_id, forKey: "student_available_id")
        coder.encode(student_id, forKey: "student_id")
        coder.encode(wave_one, forKey: "wave_one")
        coder.encode(wave_two, forKey: "wave_two")
        coder.encode(wave_three, forKey: "wave_three")
        coder.encode(wave_four, forKey: "wave_four")
    }
    
    required convenience init?(coder: NSCoder) {
        self.init()
        lesson_date = coder.decodeObject(forKey: "lesson_date") as? String
        student_available_id = coder.decodeObject(forKey: "student_available_id") as? Int
        student_id = coder.decodeObject(forKey: "student_id") as? Int
        wave_one = coder.decodeObject(forKey: "wave_one") as? Bool
        wave_two = coder.decodeObject(forKey: "wave_two") as? Bool
        wave_three = coder.decodeObject(forKey: "wave_three") as? Bool
        wave_four = coder.decodeObject(forKey: "wave_four") as? Bool
        
    }
    
    var lesson_date: String?
    var student_available_id: Int?
    var student_id: Int?
    var wave_one: Bool?
    var wave_two: Bool?
    var wave_three: Bool?
    var wave_four: Bool?
}

struct notificationcard: Codable {
    var detail_id: Int?
    var detail_type: String?
    var acknowledgement: Bool?
    var check_in: String?
    var wave: Int?
    var slot: Int?
    var datestamp: String?
    var dfs: Int?
    var sim: Int?
}

struct retrieveddate: Codable {
    var date_generated: String?
}

struct holidays: Codable {
    var holiday_date: String?
    var holiday_name: String?
}

class AppDelegate: NSObject, UIApplicationDelegate {
    var currenttokendelegate = ""
    var currentuseriddelegate = 0
    var screenstatusdelegate = ""
    var mainschedulelistdelegate = [schedules]()
    var mainholidaylistdelegate = [holidays]()
    var FCMTokendelegate = ""
    
    let gcmMessageIDKey = "gcm.message_id"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
            FirebaseApp.configure()

//            Messaging.messaging().delegate = self

            if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self

              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            } else {
              let settings: UIUserNotificationSettings =
              UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            }

            application.registerForRemoteNotifications()
            return true
        }

        func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                         fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

          if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
          }

          print(userInfo)

          completionHandler(UIBackgroundFetchResult.newData)
        }
}

//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//
//      let deviceToken:[String: String] = ["token": fcmToken ?? ""]
//        print("Device token: ", deviceToken)
//        FCMTokendelegate = fcmToken!
//        // This token can be used for testing notifications on FCM
//    }
//}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
    }

    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.banner, .badge, .sound]])
  }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo

    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID from userNotificationCenter didReceive: \(messageID)")
    }

    print(userInfo)

    completionHandler()
  }
}

struct dfsData: Codable, Identifiable {
    var id: Int? { detail_order }
    var detail_order: Int?
    var wave: Int?
    var check_in: String?
    var aircraft: aircraftClass?
    var instructor: instructorClass?
    var secondary_instructor: secondinstructorClass?
    var student: studentClass?
    var pax: String?
    var lesson: lessonClass?
    var total_hr: Float?
    var course: courseClass?
    var fxo: fxoClass?
    var remarks: String?
    var acknowledgement: String?
    var dfs: Int?
}

struct aircraftClass: Codable {
    var aircraft_name: String?
}

struct instructorClass: Codable {
    var callsign: String?
    var instructor_name: String?
}

struct secondinstructorClass: Codable {
    var instructor_name: String?
}

struct studentClass: Codable {
    var ops_name: String?
}

struct lessonClass: Codable {
    var identity_name: String?
}

struct fxoClass: Codable {
    var instructor_name: String?
}

struct courseClass: Codable {
    var course_class: String?
}

struct profileData: Codable, Identifiable {
    var id: Int? {detail_id}
    var detail_id: Int?
    var instructor_flight: instructorFlightClass?
    var lesson: lessonClass?
    var instructor: instructorClass?
    var course: courseClass?
    var student: studentDetails?
}

struct studentDetails: Codable {
    var student_id: studentProfile?
}

struct studentProfile: Codable {
    var name: String?
    var email: String?
    var hp: Int?
}

struct instructorFlightClass: Codable {
    var date_flown: String?
    var take_off_time: String?
    var landing_time: String?
    var sortie_status: String?
    var day_dual_hr: Double?
    var day_pic_hr: Double?
}
