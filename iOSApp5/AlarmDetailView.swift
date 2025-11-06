//
//  AlarmDetailView.swift
//  iOSApp5
//
//  Created by Eezy Mongo on 2025-11-06.
//

import SwiftUI

struct AlarmDetailView: View {
    @State private var alarm: Alarm
    @ObservedObject var manager: AlarmManager
    var dismissAction: (() -> Void)? = nil
    var isEditing: Bool
    
    let ringtones = ["Default", "Beep", "Classic", "Digital"]
    
    // Init for creating new alarm
    init(newAlarm: Alarm, manager: AlarmManager, dismissAction: (() -> Void)? = nil) {
        _alarm = State(initialValue: newAlarm)
        self.manager = manager
        self.dismissAction = dismissAction
        self.isEditing = false
    }
    
    // Init for editing existing alarm
    init(editingAlarm: Binding<Alarm>, manager: AlarmManager) {
        _alarm = State(initialValue: editingAlarm.wrappedValue)
        self.manager = manager
        self.dismissAction = nil
        self.isEditing = true
    }
    
    var body: some View {
        Form {
            Section(header: Text("Alarm Info")) {
                TextField("Alarm Name", text: $alarm.name)
                DatePicker("Time", selection: $alarm.time, displayedComponents: [.hourAndMinute, .date])
                Toggle("Repeat", isOn: $alarm.repeatEnabled)
            }
            
            Section(header: Text("Ringtone")) {
                Picker("Select Ringtone", selection: $alarm.ringtone) {
                    ForEach(ringtones, id: \.self) { tone in
                        Text(tone)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .navigationTitle(isEditing ? "Edit Alarm" : "Set Alarm")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    if !isEditing {
                        manager.alarms.append(alarm)
                    }
                    manager.scheduleNotification(for: alarm)
                    dismissAction?()
                }
            }
        }
    }
}
