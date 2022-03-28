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
    

    public static func getNotificationSettings(completion: ((NotificationStatus)->())? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                NotificationPolicy.authorizationStatus = .notDetermined
                completion?(.notDetermined)
            case .denied:
                NotificationPolicy.authorizationStatus = .denied
                completion?(.denied)
            case .authorized:
                NotificationPolicy.authorizationStatus = .authorized
                completion?(.authorized)
            case .provisional:
                NotificationPolicy.authorizationStatus = .provisional
                completion?(.provisional)
            case .ephemeral:
                NotificationPolicy.authorizationStatus = .ephermal
                completion?(.ephermal)
            @unknown default:
                fatalError("Unknown Notification Status")
            }
        }
    }
}
