//
//  NotificationManagerView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import UserNotifications

struct NotificationManagerView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var reminders: [Reminder] = []
    @State private var showingAddReminder = false
    @State private var selectedFilter = ""
    
    let filters: [String] = []
    
    // フィルターをローカライズキーで管理
    let filterKeys: [LocalizationKey] = [
        .all, .today, .thisWeek, .thisMonth, .expired
    ]
    
    // カテゴリをローカライズキーで管理
    let categoryKeys: [LocalizationKey] = [
        .consultation, .documentPreparation, .application, .interview, .other
    ]
    
    // 優先度をローカライズキーで管理
    let priorityKeys: [ReminderPriority] = [
        .low, .medium, .high
    ]
    
    var filteredReminders: [Reminder] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedFilter {
        case localizationManager.localizedString(.today):
            return reminders.filter { calendar.isDate($0.dueDate, inSameDayAs: now) }
        case localizationManager.localizedString(.thisWeek):
            let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let weekEnd = calendar.dateInterval(of: .weekOfYear, for: now)?.end ?? now
            return reminders.filter { $0.dueDate >= weekStart && $0.dueDate <= weekEnd }
        case localizationManager.localizedString(.thisMonth):
            let monthStart = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let monthEnd = calendar.dateInterval(of: .month, for: now)?.end ?? now
            return reminders.filter { $0.dueDate >= monthStart && $0.dueDate <= monthEnd }
        case localizationManager.localizedString(.expired):
            return reminders.filter { $0.dueDate < now && !$0.isCompleted }
        default:
            return reminders
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            VStack(spacing: 20) {
                Text(localizationManager.localizedString(.notificationDeadlineManagement))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.top, 16)
                
                // 統計情報
                HStack(spacing: 20) {
                    StatCard(
                        title: localizationManager.localizedString(.all),
                        value: "\(reminders.count)",
                        icon: "bell.fill",
                        color: .blue
                    )
                    
                    StatCard(
                        title: localizationManager.localizedString(.completed),
                        value: "\(reminders.filter { $0.isCompleted }.count)",
                        icon: "checkmark.circle.fill",
                        color: .green
                    )
                    
                    StatCard(
                        title: localizationManager.localizedString(.expired),
                        value: "\(reminders.filter { $0.dueDate < Date() && !$0.isCompleted }.count)",
                        icon: "exclamationmark.triangle.fill",
                        color: .red
                    )
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 20)
            .background(Color(.systemBackground))
            
            // フィルター
            VStack(spacing: 16) {
                Text(localizationManager.localizedString(.filter))
                    .font(.system(size: 16, weight: .semibold))
                    .padding(.horizontal, 24)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(filterKeys, id: \.self) { filterKey in
                            FilterChip(
                                title: localizationManager.localizedString(filterKey),
                                isSelected: selectedFilter == localizationManager.localizedString(filterKey),
                                action: {
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        selectedFilter = localizationManager.localizedString(filterKey)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .padding(.vertical, 16)
            .background(Color(.systemGray6))
            
            // リマインダーリスト
            if filteredReminders.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: selectedFilter == localizationManager.localizedString(.all) ? "bell.slash" : "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text(selectedFilter == localizationManager.localizedString(.all) ? localizationManager.localizedString(.noReminders) : localizationManager.localizedString(.noMatchingReminders))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    if selectedFilter == localizationManager.localizedString(.all) {
                        Button(action: {
                            showingAddReminder = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 18, weight: .medium))
                                
                                Text(localizationManager.localizedString(.addReminder))
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredReminders, id: \.id) { reminder in
                            ReminderCard(
                                reminder: reminder,
                                onToggle: {
                                    toggleReminder(reminder)
                                },
                                onDelete: {
                                    deleteReminder(reminder)
                                },
                                localizationManager: localizationManager
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle(localizationManager.localizedString(.notificationDeadlineManagement))
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            showingAddReminder = true
        }) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.blue)
        })
        .sheet(isPresented: $showingAddReminder) {
            AddReminderView(onAdd: { reminder in
                addReminder(reminder)
            }, localizationManager: localizationManager)
        }
        .onAppear {
            loadReminders()
        }
    }
    
    private func loadReminders() {
        // DataManagerからリマインダーを読み込み
        reminders = DataManager.shared.reminders
    }
    
    private func addReminder(_ reminder: Reminder) {
        DataManager.shared.addReminder(reminder)
        reminders = DataManager.shared.reminders
        scheduleNotification(for: reminder)
    }
    
    private func toggleReminder(_ reminder: Reminder) {
        var updatedReminder = reminder
        updatedReminder.isCompleted.toggle()
        DataManager.shared.updateReminder(updatedReminder)
        reminders = DataManager.shared.reminders
    }
    
    private func deleteReminder(_ reminder: Reminder) {
        DataManager.shared.deleteReminder(reminder)
        reminders = DataManager.shared.reminders
        cancelNotification(for: reminder)
    }
    
    private func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = reminder.title
        content.body = reminder.description
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.dueDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func cancelNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(color)
            }
            
            VStack(spacing: 2) {
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct ReminderCard: View {
    let reminder: Reminder
    let onToggle: () -> Void
    let onDelete: () -> Void
    @ObservedObject var localizationManager: LocalizationManager
    @State private var showingDetail = false
    
    var isOverdue: Bool {
        reminder.dueDate < Date() && !reminder.isCompleted
    }
    
    var daysUntilDue: Int {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: reminder.dueDate)
        return components.day ?? 0
    }
    
    var priorityColor: Color {
        switch reminder.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(spacing: 16) {
                // ヘッダー
                HStack(spacing: 12) {
                    // 完了チェックボックス
                    Button(action: onToggle) {
                        ZStack {
                            Circle()
                                .fill(reminder.isCompleted ? Color.green : Color(.systemGray5))
                                .frame(width: 24, height: 24)
                            
                            if reminder.isCompleted {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // タイトルとカテゴリー
                    VStack(alignment: .leading, spacing: 4) {
                        Text(reminder.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Text(reminder.category)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // 優先度バッジ
                    Text(reminder.priority.rawValue)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(priorityColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                // 説明
                if !reminder.description.isEmpty {
                    Text(reminder.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                // フッター
                HStack {
                    // 期限情報
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(reminder.dueDate, style: .date)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Text(reminder.dueDate, style: .time)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // 残り日数または期限切れ
                    if isOverdue {
                        Text(localizationManager.localizedString(.expired))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.red)
                    } else {
                        Text(localizationManager.localizedString(.daysLater).replacingOccurrences(of: "%d", with: "\(daysUntilDue)"))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(daysUntilDue <= 3 ? .orange : .secondary)
                    }
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        reminder.isCompleted ? Color.green.opacity(0.3) : 
                        isOverdue ? Color.red.opacity(0.3) : Color(.systemGray5),
                        lineWidth: reminder.isCompleted || isOverdue ? 2 : 0.5
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            ReminderDetailView(reminder: reminder, onDelete: onDelete, localizationManager: localizationManager)
        }
    }
}

struct ReminderDetailView: View {
    let reminder: Reminder
    let onDelete: () -> Void
    @ObservedObject var localizationManager: LocalizationManager
    @Environment(\.presentationMode) var presentationMode
    
    var isOverdue: Bool {
        reminder.dueDate < Date() && !reminder.isCompleted
    }
    
    var priorityColor: Color {
        switch reminder.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // ヘッダー
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [priorityColor, priorityColor.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: priorityColor.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(reminder.title)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text(reminder.category)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 32)
                    
                    // 詳細情報
                    VStack(spacing: 20) {
                        DetailRow(
                            title: localizationManager.localizedString(.deadline),
                            value: reminder.dueDate.formatted(date: .complete, time: .shortened),
                            icon: "calendar"
                        )
                        
                        DetailRow(
                            title: localizationManager.localizedString(.priority),
                            value: reminder.priority.rawValue,
                            icon: "flag.fill"
                        )
                        
                        if !reminder.description.isEmpty {
                            DetailRow(
                                title: localizationManager.localizedString(.description),
                                value: reminder.description,
                                icon: "text.alignleft"
                            )
                        }
                        
                        DetailRow(
                            title: localizationManager.localizedString(.status),
                            value: reminder.isCompleted ? localizationManager.localizedString(.completed) : (isOverdue ? localizationManager.localizedString(.overdue) : localizationManager.localizedString(.incomplete)),
                            icon: reminder.isCompleted ? "checkmark.circle.fill" : (isOverdue ? "exclamationmark.triangle.fill" : "clock")
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.reminderDetail))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(localizationManager.localizedString(.done)) {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(localizationManager.localizedString(.delete)) {
                    onDelete()
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.red)
            )
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct AddReminderView: View {
    let onAdd: (Reminder) -> Void
    @ObservedObject var localizationManager: LocalizationManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority = ReminderPriority.medium
    @State private var category = ""
    
    let categories: [String] = []
    
    // 優先度をローカライズキーで管理
    let priorityKeys: [ReminderPriority] = [
        .low, .medium, .high
    ]
    
    // カテゴリをローカライズキーで管理
    let categoryKeys: [LocalizationKey] = [
        .consultation, .documentPreparation, .application, .interview, .other
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // ヘッダー
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Text(localizationManager.localizedString(.addReminder))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 32)
                    
                    // フォーム
                    VStack(spacing: 20) {
                        FormField(title: localizationManager.localizedString(.title)) {
                            TextField(localizationManager.localizedString(.enterTitle), text: $title)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.description)) {
                            TextField(localizationManager.localizedString(.enterDescription), text: $description)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.deadline)) {
                            DatePicker(
                                localizationManager.localizedString(.deadline),
                                selection: $dueDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.priority)) {
                            Picker(localizationManager.localizedString(.priority), selection: $priority) {
                                ForEach(priorityKeys, id: \.self) { priority in
                                    Text(priority.rawValue).tag(priority)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.category)) {
                            Picker(localizationManager.localizedString(.category), selection: $category) {
                                ForEach(categoryKeys, id: \.self) { key in
                                    Text(localizationManager.localizedString(key)).tag(localizationManager.localizedString(key))
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.addReminder))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(localizationManager.localizedString(.cancel)) {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(localizationManager.localizedString(.add)) {
                    let reminder = Reminder(
                        title: title,
                        description: description,
                        dueDate: dueDate,
                        priority: priority,
                        category: category
                    )
                    onAdd(reminder)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

#Preview {
    NotificationManagerView()
} 