//
//  AlarmManager.swift
//  iOSApp5
//
//  Created by Eezy Mongo on 2025-11-06.
//

import Foundation
import UserNotifications

class AlarmManager: ObservableObject {
    @Published var alarms: [Alarm] = [] {
        didSet { saveAlarms() }
    }
    
    private let key = "alarms"
    
    init() { loadAlarms() }
    
    // MARK: Save & Load
    private func saveAlarms() {
        if let data = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func loadAlarms() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([Alarm].self, from: data) {
            alarms = decoded
        }
    }
    
    // MARK: Notifications
    func scheduleNotification(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        removeNotification(for: alarm)
        
        let content = UNMutableNotificationContent()
        content.title = alarm.name.isEmpty ? "Alarm" : alarm.name
        content.body = "⏰ Your alarm is ringing!"
        content.sound = UNNotificationSound.default
        
        let triggerDate = Calendar.current.dateComponents([.hour, .minute, .day, .month, .year], from: alarm.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: alarm.repeatEnabled)
        
        let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    func removeNotification(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
    }
}
