//
//  ContentView.swift
//  iOSApp5
//
//  Created by Eezy Mongo on 2025-11-06.
//
import SwiftUI

struct HomeView: View {
    @StateObject private var manager = AlarmManager()
    @State private var tempAlarm: Alarm? = nil
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Title
                Text("My Alarms")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                Text("Swipe to the left to delete an alarm")
                    .font(.callout)
                    
                    
                
                // List or Empty State
                if manager.alarms.isEmpty {
                    Spacer()
                    Text("No alarm created yet")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                } else {
                    List {
                        ForEach($manager.alarms.indices, id: \.self) { index in
                            NavigationLink(
                                destination: AlarmDetailView(editingAlarm: $manager.alarms[index], manager: manager)
                            ) {
                                AlarmRow(alarm: $manager.alarms[index])
                            }
                        }
                        .onDelete(perform: deleteAlarm)
                    }
                    .listStyle(.plain)
                }
                
                // Create Button
                Button(action: {
                    tempAlarm = Alarm(time: Date())
                }) {
                    Text("Create an Alarm")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 20)
                .sheet(item: $tempAlarm) { alarm in
                    NavigationStack {
                        AlarmDetailView(
                            newAlarm: alarm,
                            manager: manager,
                            dismissAction: { tempAlarm = nil }
                        )
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if let error = error { print("Notification error: \(error.localizedDescription)") }
            }
        }
    }
    
    // MARK: Delete alarm method
    private func deleteAlarm(at offsets: IndexSet) {
        for index in offsets {
            manager.removeNotification(for: manager.alarms[index])
        }
        manager.alarms.remove(atOffsets: offsets)
    }
}

// MARK: AlarmRow
struct AlarmRow: View {
    @Binding var alarm: Alarm
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "alarm")
                .foregroundColor(alarm.repeatEnabled ? .green : .orange)
                .font(.title2)
                .padding(8)
                .background(alarm.repeatEnabled ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alarm.name.isEmpty ? "Untitled Alarm" : alarm.name)
                    .font(.headline)
                Text("\(alarm.time, style: .time)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Toggle("", isOn: $alarm.repeatEnabled)
                .labelsHidden()
                .tint(alarm.repeatEnabled ? .green : .orange)
        }
        .padding(.vertical, 6)
    }
}
#Preview {
    HomeView()
}
