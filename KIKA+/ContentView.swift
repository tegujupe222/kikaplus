//
//  ContentView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import Combine
import Foundation
import UniformTypeIdentifiers
import AVFoundation
import MapKit
import UserNotifications
import os
import UIKit

struct ContentView: View {
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // ヘッダー
                    VStack(spacing: 16) {
                        // アプリアイコンとタイトル
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .frame(width: 80, height: 80)
                                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                Image(systemName: "flag.filled.and.flag.crossed")
                                    .font(.system(size: 36, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 6) {
                                Text(localizationManager.localizedString(.appName))
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                
                                Text(localizationManager.localizedString(.appSubtitle))
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.top, 20)
                        
                        // 言語選択（より目立つように）
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                                .font(.system(size: 18, weight: .medium))
                            
                            Picker(localizationManager.localizedString(.languageSelection), selection: $localizationManager.currentLanguage) {
                                ForEach(LocalizationManager.Language.allCases, id: \.self) { lang in
                                    HStack {
                                        Text(lang.flag)
                                        Text(lang.displayName)
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    .tag(lang)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: localizationManager.currentLanguage) { _, newLang in
                                localizationManager.setLanguage(newLang)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                showingSettings = true
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .frame(width: 48, height: 48)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        .padding(.horizontal, 20)
                    }
                    
                    // メインメニュー
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 20) {
                        NavigationLink(destination: DiagnosisView()) {
                            MenuCard(
                                title: localizationManager.localizedString(.diagnosisCheck),
                                subtitle: localizationManager.localizedString(.diagnosisSubtitle),
                                icon: "checkmark.circle.fill",
                                color: .blue,
                                gradient: LinearGradient(colors: [.blue, .blue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: StepGuideView()) {
                            MenuCard(
                                title: localizationManager.localizedString(.stepGuide),
                                subtitle: localizationManager.localizedString(.stepGuideSubtitle),
                                icon: "list.bullet",
                                color: .green,
                                gradient: LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: DocumentChecklistView()) {
                            MenuCard(
                                title: localizationManager.localizedString(.documentChecklist),
                                subtitle: localizationManager.localizedString(.documentChecklistSubtitle),
                                icon: "doc.text.fill",
                                color: .orange,
                                gradient: LinearGradient(colors: [.orange, .orange.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: TranslationSupportView()) {
                            MenuCard(
                                title: localizationManager.localizedString(.translationSupport),
                                subtitle: localizationManager.localizedString(.translationSupportSubtitle),
                                icon: "translate",
                                color: .purple,
                                gradient: LinearGradient(colors: [.purple, .purple.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: LegalOfficeSearchView()) {
                            MenuCard(
                                title: localizationManager.localizedString(.legalOfficeSearch),
                                subtitle: localizationManager.localizedString(.legalOfficeSearchSubtitle),
                                icon: "building.2.fill",
                                color: .red,
                                gradient: LinearGradient(colors: [.red, .red.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: InterviewPreparationView()) {
                            MenuCard(
                                title: localizationManager.localizedString(.interviewPreparation),
                                subtitle: localizationManager.localizedString(.interviewPreparationSubtitle),
                                icon: "person.2.fill",
                                color: .indigo,
                                gradient: LinearGradient(colors: [.indigo, .indigo.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        NavigationLink(destination: NotificationManagerView()) {
                            MenuCard(
                                title: localizationManager.localizedString(.notificationManagement),
                                subtitle: localizationManager.localizedString(.notificationManagementSubtitle),
                                icon: "bell.fill",
                                color: .pink,
                                gradient: LinearGradient(colors: [.pink, .pink.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 8)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

struct MenuCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let gradient: LinearGradient
    
    var body: some View {
        VStack(alignment: .center, spacing: 14) {
            // アイコン
            ZStack {
                Circle()
                    .fill(gradient)
                    .frame(width: 52, height: 52)
                    .shadow(color: color.opacity(0.3), radius: 6, x: 0, y: 3)
                
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // テキスト
            VStack(alignment: .center, spacing: 4) {
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .minimumScaleFactor(0.85)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // 矢印
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
            }
        }
        .padding(18)
        .frame(minHeight: 160, maxHeight: 160)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}

#Preview {
    ContentView()
}
