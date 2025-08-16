//
//  DocumentChecklistView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import Combine
import Foundation

struct DocumentChecklistView: View {
    @State private var selectedCountry = ""
    @State private var selectedStatus = ""
    @State private var completedDocuments: Set<String> = []
    @State private var showingDocumentDetail = false
    @State private var selectedDocument: Document?
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    let countries: [String] = []
    let statuses: [String] = []
    
    // 国名をローカライズキーで管理
    let countryKeys: [LocalizationKey] = [
        .china, .vietnam, .philippines, .nepal, .korea, .other
    ]
    // 在留資格をローカライズキーで管理
    let statusKeys: [LocalizationKey] = [
        .worker, .student, .technicalIntern, .internationalMarriage, .permanentResident
    ]
    
    // 書類データをローカライズキーで管理
    var allDocuments: [Document] {
        [
            Document(
                id: "passport",
                name: localizationManager.localizedString(.passport),
                description: localizationManager.localizedString(.passportDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.common)],
                whereToGet: localizationManager.localizedString(.passportWhereToGet),
                example: localizationManager.localizedString(.passportExample),
                notes: localizationManager.localizedString(.passportNotes),
                priority: .high
            ),
            Document(
                id: "birth_certificate",
                name: localizationManager.localizedString(.birthCertificate),
                description: localizationManager.localizedString(.birthCertificateDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.common)],
                whereToGet: localizationManager.localizedString(.birthCertificateWhereToGet),
                example: localizationManager.localizedString(.birthCertificateExample),
                notes: localizationManager.localizedString(.birthCertificateNotes),
                priority: .high
            ),
            Document(
                id: "nationality_certificate",
                name: localizationManager.localizedString(.nationalityCertificate),
                description: localizationManager.localizedString(.nationalityCertificateDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.common)],
                whereToGet: localizationManager.localizedString(.nationalityCertificateWhereToGet),
                example: localizationManager.localizedString(.nationalityCertificateExample),
                notes: localizationManager.localizedString(.nationalityCertificateNotes),
                priority: .high
            ),
            Document(
                id: "residence_card",
                name: localizationManager.localizedString(.residenceCard),
                description: localizationManager.localizedString(.residenceCardDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.common)],
                whereToGet: localizationManager.localizedString(.residenceCardWhereToGet),
                example: localizationManager.localizedString(.residenceCardExample),
                notes: localizationManager.localizedString(.residenceCardNotes),
                priority: .high
            ),
            Document(
                id: "employment_certificate",
                name: localizationManager.localizedString(.employmentCertificate),
                description: localizationManager.localizedString(.employmentCertificateDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.worker), localizationManager.localizedString(.technicalIntern)],
                whereToGet: localizationManager.localizedString(.employmentCertificateWhereToGet),
                example: localizationManager.localizedString(.employmentCertificateExample),
                notes: localizationManager.localizedString(.employmentCertificateNotes),
                priority: .medium
            ),
            Document(
                id: "income_certificate",
                name: localizationManager.localizedString(.incomeCertificate),
                description: localizationManager.localizedString(.incomeCertificateDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.worker), localizationManager.localizedString(.technicalIntern)],
                whereToGet: localizationManager.localizedString(.incomeCertificateWhereToGet),
                example: localizationManager.localizedString(.incomeCertificateExample),
                notes: localizationManager.localizedString(.incomeCertificateNotes),
                priority: .medium
            ),
            Document(
                id: "tax_certificate",
                name: localizationManager.localizedString(.taxCertificate),
                description: localizationManager.localizedString(.taxCertificateDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.common)],
                whereToGet: localizationManager.localizedString(.taxCertificateWhereToGet),
                example: localizationManager.localizedString(.taxCertificateExample),
                notes: localizationManager.localizedString(.taxCertificateNotes),
                priority: .medium
            ),
            Document(
                id: "marriage_certificate",
                name: localizationManager.localizedString(.marriageCertificate),
                description: localizationManager.localizedString(.marriageCertificateDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.internationalMarriage)],
                whereToGet: localizationManager.localizedString(.marriageCertificateWhereToGet),
                example: localizationManager.localizedString(.marriageCertificateExample),
                notes: localizationManager.localizedString(.marriageCertificateNotes),
                priority: .medium
            ),
            Document(
                id: "family_register",
                name: localizationManager.localizedString(.familyRegister),
                description: localizationManager.localizedString(.familyRegisterDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.internationalMarriage)],
                whereToGet: localizationManager.localizedString(.familyRegisterWhereToGet),
                example: localizationManager.localizedString(.familyRegisterExample),
                notes: localizationManager.localizedString(.familyRegisterNotes),
                priority: .medium
            ),
            Document(
                id: "graduation_certificate",
                name: localizationManager.localizedString(.graduationCertificate),
                description: localizationManager.localizedString(.graduationCertificateDesc),
                countries: [localizationManager.localizedString(.common)],
                statuses: [localizationManager.localizedString(.student)],
                whereToGet: localizationManager.localizedString(.graduationCertificateWhereToGet),
                example: localizationManager.localizedString(.graduationCertificateExample),
                notes: localizationManager.localizedString(.graduationCertificateNotes),
                priority: .low
            )
        ]
    }
    
    var filteredDocuments: [Document] {
        return allDocuments.filter { document in
            (document.countries.contains(selectedCountry) || document.countries.contains(localizationManager.localizedString(.common))) &&
            (document.statuses.contains(selectedStatus) || document.statuses.contains(localizationManager.localizedString(.common)))
        }
    }
    
    var completionProgress: Double {
        let total = filteredDocuments.count
        let completed = filteredDocuments.filter { completedDocuments.contains($0.id) }.count
        return total > 0 ? Double(completed) / Double(total) : 0
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            VStack(spacing: 20) {
                Text(localizationManager.localizedString(.documentChecklistTitle))
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.top, 16)
                
                // 進捗表示
                VStack(spacing: 8) {
                    HStack {
                        Text(localizationManager.localizedString(.necessaryDocumentProgress))
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text(localizationManager.localizedString(.percentageFormat, arguments: ["\(Int(completionProgress * 100))"]))
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: completionProgress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 20)
            .background(Color(.systemBackground))
            
            // フィルター
            VStack(spacing: 16) {
                // 国籍選択
                VStack(alignment: .leading, spacing: 12) {
                    Text(localizationManager.localizedString(.selectCountry))
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 24)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(countryKeys, id: \.self) { countryKey in
                                FilterChip(
                                    title: localizationManager.localizedString(countryKey),
                                    isSelected: selectedCountry == localizationManager.localizedString(countryKey),
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedCountry = localizationManager.localizedString(countryKey)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                // 在留資格選択
                VStack(alignment: .leading, spacing: 12) {
                    Text(localizationManager.localizedString(.selectStatus))
                        .font(.system(size: 16, weight: .semibold))
                        .padding(.horizontal, 24)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(statusKeys, id: \.self) { statusKey in
                                FilterChip(
                                    title: localizationManager.localizedString(statusKey),
                                    isSelected: selectedStatus == localizationManager.localizedString(statusKey),
                                    action: {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedStatus = localizationManager.localizedString(statusKey)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
            }
            .padding(.vertical, 16)
            .background(Color(.systemGray6))
            
            // 書類リスト
            if filteredDocuments.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                    
                    Text(localizationManager.localizedString(.noDocumentsFound))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(localizationManager.localizedString(.tryDifferentSearch))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGroupedBackground))
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredDocuments, id: \.id) { document in
                            DocumentCard(
                                document: document,
                                isCompleted: completedDocuments.contains(document.id),
                                onToggle: {
                                    if completedDocuments.contains(document.id) {
                                        completedDocuments.remove(document.id)
                                    } else {
                                        completedDocuments.insert(document.id)
                                    }
                                },
                                onTap: {
                                    selectedDocument = document
                                    showingDocumentDetail = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle(localizationManager.localizedString(.documentChecklistTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingDocumentDetail) {
            if let document = selectedDocument {
                DocumentDetailView(document: document)
            }
        }
    }
}

struct DocumentCard: View {
    let document: Document
    let isCompleted: Bool
    let onToggle: () -> Void
    let onTap: () -> Void
    
    var priorityColor: Color {
        switch document.priority {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // 完了チェックボックス
                Button(action: onToggle) {
                    ZStack {
                        Circle()
                            .fill(isCompleted ? Color.green : Color(.systemGray5))
                            .frame(width: 24, height: 24)
                        
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // 書類情報
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(document.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // 優先度バッジ
                        Text(document.priority.rawValue)
                            .font(.system(size: 10, weight: .bold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(priorityColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                    Text(document.description)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                // 矢印
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isCompleted ? Color.green.opacity(0.3) : Color(.systemGray5), lineWidth: isCompleted ? 2 : 0.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct DocumentDetailView: View {
    let document: Document
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
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
                            
                            Image(systemName: "doc.text.fill")
                                .font(.system(size: 32, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(document.name)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text(document.description)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 32)
                    
                    // 詳細情報
                    VStack(spacing: 20) {
                        DetailSection(
                            title: localizationManager.localizedString(.whereToGet),
                            content: document.whereToGet,
                            icon: "location.fill"
                        )
                        
                        DetailSection(
                            title: localizationManager.localizedString(.examples),
                            content: document.example,
                            icon: "doc.text"
                        )
                        
                        DetailSection(
                            title: localizationManager.localizedString(.notes),
                            content: document.notes,
                            icon: "exclamationmark.triangle.fill"
                        )
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.documentDetailTitle))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.done)) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct DetailSection: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Text(content)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    DocumentChecklistView()
} 