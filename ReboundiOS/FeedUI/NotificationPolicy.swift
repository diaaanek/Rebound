//
//  NotificationPolicy.swift
//  ReboundiOS
//
//  Created by Ethan Keiser on 3/27/22.
//
import UserNotifications
import Foundation

public enum NotificationStatus {
    case notDetermined
    case authorized
    case denied
    case provisional
    case ephermal
}
public class NotificationPolicy {
   public static var authorizationStatus : NotificationStatus = .notDetermined
    

   public static func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                NotificationPolicy.authorizationStatus = .notDetermined
            case .denied:
                NotificationPolicy.authorizationStatus = .denied
            case .authorized:
                NotificationPolicy.authorizationStatus = .authorized
            case .provisional:
                NotificationPolicy.authorizationStatus = .provisional
            case .ephemeral:
                NotificationPolicy.authorizationStatus = .ephermal
            @unknown default:
                fatalError("Unknown Notification Status")
            }
        }
    }
}
