//
//  SettingsView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @StateObject private var dataManager = DataManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var showingProfileEditor = false
    @State private var showingDataExport = false
    @State private var showingDataImport = false
    @State private var showingClearDataAlert = false
    @State private var showingNotificationSettings = false
    @State private var selectedLanguage: String = LocalizationManager.Language.japanese.displayName
    @State private var notificationsEnabled = true
    @State private var reminderNotifications = true
    @State private var progressNotifications = true
    
    var languages: [String] {
        LocalizationManager.Language.allCases.map { $0.displayName }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // プロフィール設定
                    VStack(spacing: 16) {
                        HStack {
                            Text(localizationManager.localizedString(.profile))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        Button(action: {
                            showingProfileEditor = true
                        }) {
                            HStack(spacing: 16) {
                                // アバター
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.blue, .blue.opacity(0.8)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 60, height: 60)
                                    
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                // プロフィール情報
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(dataManager.userProfile.name.isEmpty ? localizationManager.localizedString(.profileNotSet) : dataManager.userProfile.name)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Text(dataManager.userProfile.nationality.isEmpty ? localizationManager.localizedString(.nationalityNotSet) : dataManager.userProfile.nationality)
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                // 編集ボタン
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(20)
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 24)
                    }
                    
                    // アプリケーション設定
                    VStack(spacing: 16) {
                        HStack {
                            Text(localizationManager.localizedString(.appSettings))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            // 言語設定
                            SettingRow(
                                icon: "globe",
                                iconColor: .green,
                                title: localizationManager.localizedString(.languageSettings),
                                action: {
                                    // 言語選択の処理
                                }
                            ) {
                                Picker(localizationManager.localizedString(.languageSelection), selection: $selectedLanguage) {
                                    ForEach(languages, id: \.self) { language in
                                        Text(language).tag(language)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onChange(of: selectedLanguage) { _, newValue in
                                    updateLanguage(newValue)
                                }
                            }
                            
                            // 通知設定
                            SettingRow(
                                icon: "bell",
                                iconColor: .orange,
                                title: localizationManager.localizedString(.notificationSettings),
                                action: {
                                    showingNotificationSettings = true
                                }
                            ) {
                                Text(localizationManager.localizedString(.configure))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // データ管理
                    VStack(spacing: 16) {
                        HStack {
                            Text(localizationManager.localizedString(.dataManagement))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            SettingRow(
                                icon: "square.and.arrow.up",
                                iconColor: .blue,
                                title: localizationManager.localizedString(.exportData),
                                action: {
                                    showingDataExport = true
                                }
                            ) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            SettingRow(
                                icon: "square.and.arrow.down",
                                iconColor: .green,
                                title: localizationManager.localizedString(.importData),
                                action: {
                                    showingDataImport = true
                                }
                            ) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            SettingRow(
                                icon: "trash",
                                iconColor: .red,
                                title: localizationManager.localizedString(.deleteAllData),
                                action: {
                                    showingClearDataAlert = true
                                }
                            ) {
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // 統計情報
                    VStack(spacing: 16) {
                        HStack {
                            Text(localizationManager.localizedString(.statistics))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(statLabels, id: \.0) { labelKey, value in
                                StatRow(
                                    title: localizationManager.localizedString(labelKey),
                                    value: value
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // アプリ情報
                    VStack(spacing: 16) {
                        HStack {
                            Text(localizationManager.localizedString(.appInfo))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            SettingRow(
                                icon: "info.circle",
                                iconColor: .gray,
                                title: localizationManager.localizedString(.version),
                                action: {}
                            ) {
                                Text(localizationManager.localizedString(.version))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            
                            SettingRow(
                                icon: "questionmark.circle",
                                iconColor: .gray,
                                title: localizationManager.localizedString(.helpSupport),
                                action: {
                                    // ヘルプページを開く
                                }
                            ) {
                                Text(localizationManager.localizedString(.open))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                            
                            SettingRow(
                                icon: "star",
                                iconColor: .yellow,
                                title: localizationManager.localizedString(.rateApp),
                                action: {
                                    // App Storeレビューページを開く
                                }
                            ) {
                                Text(localizationManager.localizedString(.rate))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.settings))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingProfileEditor) {
                ProfileEditorView()
            }
            .sheet(isPresented: $showingNotificationSettings) {
                NotificationSettingsView()
            }
            .alert(localizationManager.localizedString(.deleteAllData), isPresented: $showingClearDataAlert) {
                Button(localizationManager.localizedString(.cancel), role: .cancel) { }
                Button(localizationManager.localizedString(.delete), role: .destructive) {
                    dataManager.clearAllData()
                }
            } message: {
                Text(localizationManager.localizedString(.deleteAllDataMessage))
            }
            .onAppear {
                selectedLanguage = dataManager.userProfile.preferredLanguage
            }
        }
    }
    
    private func updateLanguage(_ language: String) {
        var profile = dataManager.userProfile
        profile.preferredLanguage = language
        dataManager.updateUserProfile(profile)
    }
    
    // 統計情報のラベルをローカライズキーで管理
    var statLabels: [(LocalizationKey, String)] {
        [
            (.diagnosisCount, "\(dataManager.diagnosisResults.count)"),
            (.savedDocumentsCount, "\(dataManager.savedDocuments.count)"),
            (.remindersCount, "\(dataManager.reminders.count)"),
            (.notesCount, "\(dataManager.notes.count)"),
            (.completedStepsCount, "\(dataManager.applicationProgress.completedSteps.count)")
        ]
    }
    
    // 在留資格の選択肢をローカライズキーで管理
    let residenceStatusKeys: [LocalizationKey] = [
        .permanentResident, .longTermResident, .spouseOfJapanese, .spouseOfPermanentResident, .other
    ]
}

struct SettingRow<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let action: () -> Void
    let content: Content
    
    init(
        icon: String,
        iconColor: Color,
        title: String,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(iconColor)
                    .frame(width: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                content
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

struct ProfileEditorView: View {
    @StateObject private var dataManager = DataManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var nationality = ""
    @State private var birthDate = Date()
    @State private var residenceStatus = ""
    @State private var yearsInJapan = 0
    @State private var occupation = ""
    @State private var email = ""
    
    var residenceQualifications: [String] {
        residenceStatusKeys.map { localizationManager.localizedString($0) }
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
                                        colors: [.blue, .blue.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Text(localizationManager.localizedString(.profile))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 32)
                    
                    // フォーム
                    VStack(spacing: 20) {
                        FormField(title: localizationManager.localizedString(.name)) {
                            TextField(localizationManager.localizedString(.enterName), text: $name)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.nationality)) {
                            TextField(localizationManager.localizedString(.enterNationality), text: $nationality)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.birthDate)) {
                            DatePicker(
                                localizationManager.localizedString(.birthDate),
                                selection: $birthDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.residenceStatus)) {
                            Picker(localizationManager.localizedString(.residenceStatus), selection: $residenceStatus) {
                                ForEach(residenceStatusKeys, id: \.self) { key in
                                    Text(localizationManager.localizedString(key)).tag(localizationManager.localizedString(key))
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.yearsInJapan)) {
                            Stepper("\(yearsInJapan)\(localizationManager.localizedString(.years))", value: $yearsInJapan, in: 0...50)
                        }
                        
                        FormField(title: localizationManager.localizedString(.occupation)) {
                            TextField(localizationManager.localizedString(.enterOccupation), text: $occupation)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                        
                        FormField(title: localizationManager.localizedString(.emailAddress)) {
                            TextField(localizationManager.localizedString(.enterEmail), text: $email)
                                .textFieldStyle(PlainTextFieldStyle())
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.profile))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(localizationManager.localizedString(.cancel)) {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(localizationManager.localizedString(.save)) {
                    saveProfile()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear {
                loadProfile()
            }
        }
    }
    
    private func loadProfile() {
        let profile = dataManager.userProfile
        name = profile.name
        nationality = profile.nationality
        birthDate = profile.birthDate
        residenceStatus = profile.residenceStatus
        yearsInJapan = profile.yearsInJapan
        occupation = profile.occupation
        email = profile.email
    }
    
    private func saveProfile() {
        var profile = dataManager.userProfile
        profile.name = name
        profile.nationality = nationality
        profile.birthDate = birthDate
        profile.residenceStatus = residenceStatus
        profile.yearsInJapan = yearsInJapan
        profile.occupation = occupation
        profile.email = email
        dataManager.updateUserProfile(profile)
    }
}

struct NotificationSettingsView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    @State private var notificationsEnabled = true
    @State private var reminderNotifications = true
    @State private var progressNotifications = true
    @State private var dailyReminders = true
    @State private var weeklyReports = true
    
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
                                        colors: [.orange, .orange.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                                .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                            
                            Image(systemName: "bell.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        Text(localizationManager.localizedString(.notificationSettings))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 32)
                    
                    // 設定項目
                    VStack(spacing: 16) {
                        ToggleRow(
                            title: localizationManager.localizedString(.notificationsEnabled),
                            isOn: $notificationsEnabled,
                            icon: "bell.fill",
                            iconColor: .blue
                        )
                        
                        ToggleRow(
                            title: localizationManager.localizedString(.reminderNotifications),
                            isOn: $reminderNotifications,
                            icon: "clock.fill",
                            iconColor: .green
                        )
                        
                        ToggleRow(
                            title: localizationManager.localizedString(.progressNotifications),
                            isOn: $progressNotifications,
                            icon: "chart.line.uptrend.xyaxis",
                            iconColor: .purple
                        )
                        
                        ToggleRow(
                            title: localizationManager.localizedString(.dailyReminders),
                            isOn: $dailyReminders,
                            icon: "calendar",
                            iconColor: .orange
                        )
                        
                        ToggleRow(
                            title: localizationManager.localizedString(.weeklyReports),
                            isOn: $weeklyReports,
                            icon: "doc.text",
                            iconColor: .red
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.notificationSettings))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.done)) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    SettingsView()
} 
// 在留資格の選択肢をローカライズキーで管理
let residenceStatusKeys: [LocalizationKey] = [
    .permanentResident, .longTermResident, .spouseOfJapanese, .spouseOfPermanentResident, .other
]
