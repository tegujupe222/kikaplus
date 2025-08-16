//
//  TranslationSupportView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import Combine
import Foundation

struct TranslationSupportView: View {
    @State private var selectedLanguage: String = LocalizationManager.Language.english.displayName
    @State private var selectedDocument: String = LocalizationManager.shared.localizedString(.birthCertificate)
    @State private var originalText = ""
    @State private var translatedText = ""
    @State private var showingTemplate = false
    @State private var showingTranslation = false
    
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var languages: [String] {
        LocalizationManager.Language.allCases.map { $0.displayName }
    }
    
    var documents: [String] {
        [
            localizationManager.localizedString(.birthCertificate),
            localizationManager.localizedString(.marriageCertificate),
            localizationManager.localizedString(.nationalityCertificate),
            localizationManager.localizedString(.graduationCertificate),
            localizationManager.localizedString(.employmentCertificate),
            localizationManager.localizedString(.taxCertificate)
        ]
    }
    
    // FAQのローカライズキーを用意
    let faqItems: [(LocalizationKey, LocalizationKey)] = [
        (.faqQ1, .faqA1),
        (.faqQ2, .faqA2),
        (.faqQ3, .faqA3)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 言語選択
                VStack(alignment: .leading, spacing: 10) {
                    Text(localizationManager.localizedString(.selectLanguage))
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(languages, id: \.self) { language in
                                Button(action: {
                                    selectedLanguage = language
                                }) {
                                    Text(language)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedLanguage == language ? Color.blue : Color(.systemGray5))
                                        .foregroundColor(selectedLanguage == language ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 書類選択
                VStack(alignment: .leading, spacing: 10) {
                    Text(localizationManager.localizedString(.selectDocument))
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(documents, id: \.self) { document in
                                Button(action: {
                                    selectedDocument = document
                                    loadTemplate()
                                }) {
                                    Text(document)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedDocument == document ? Color.green : Color(.systemGray5))
                                        .foregroundColor(selectedDocument == document ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // 翻訳エリア
                VStack(spacing: 15) {
                    // 原文入力
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(localizationManager.localizedString(.originalText))
                                .font(.headline)
                            Spacer()
                            Button(localizationManager.localizedString(.showTemplate)) {
                                showingTemplate = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        
                        TextEditor(text: $originalText)
                            .frame(minHeight: 120)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                    }
                    
                    // 翻訳ボタン
                    Button(action: translateText) {
                        HStack {
                            Image(systemName: "arrow.right")
                            Text(localizationManager.localizedString(.translate))
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(originalText.isEmpty)
                    
                    // 翻訳結果
                    if !translatedText.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizationManager.localizedString(.translatedText))
                                .font(.headline)
                            
                            Text(translatedText)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                            
                            HStack {
                                Button(action: {
                                    copyToClipboard(translatedText)
                                }) {
                                    Text(localizationManager.localizedString(.copy))
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Button(localizationManager.localizedString(.save)) {
                                    saveTranslation()
                                }
                                .font(.caption)
                                .foregroundColor(.green)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // よくある質問
                VStack(alignment: .leading, spacing: 15) {
                    Text(localizationManager.localizedString(.faq))
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        ForEach(faqItems, id: \.0) { qKey, aKey in
                            FAQItem(
                                question: localizationManager.localizedString(qKey),
                                answer: localizationManager.localizedString(aKey)
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(localizationManager.localizedString(.translationSupportTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingTemplate) {
            TemplateView(document: selectedDocument, language: selectedLanguage)
        }
        .onAppear {
            loadTemplate()
        }
    }
    
    private func loadTemplate() {
        originalText = getTemplateText(for: selectedDocument, language: selectedLanguage)
    }
    
    private func translateText() {
        // 実際の翻訳APIを呼び出す代わりに、サンプル翻訳を表示
        translatedText = getSampleTranslation(for: selectedDocument, language: selectedLanguage)
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
    
    private func saveTranslation() {
        // 翻訳結果を保存する処理
        print("Translation result saved")
    }
    
    private func getTemplateText(for document: String, language: String) -> String {
        // 書類名をLocalizationKeyで判定
        let documentKey: LocalizationKey
        switch document {
        case localizationManager.localizedString(.birthCertificate):
            documentKey = .birthCertificate
        case localizationManager.localizedString(.marriageCertificate):
            documentKey = .marriageCertificate
        case localizationManager.localizedString(.nationalityCertificate):
            documentKey = .nationalityCertificate
        case localizationManager.localizedString(.graduationCertificate):
            documentKey = .graduationCertificate
        case localizationManager.localizedString(.employmentCertificate):
            documentKey = .employmentCertificate
        case localizationManager.localizedString(.taxCertificate):
            documentKey = .taxCertificate
        default:
            return localizationManager.localizedString(.selectDocument)
        }
        
        // 言語に応じてテンプレートを返す
        switch (documentKey, language) {
        case (.birthCertificate, _):
            return """
            CERTIFICATE OF BIRTH
            
            This is to certify that [Name] was born on [Date] at [Place] to [Father's Name] and [Mother's Name].
            
            Date of Issue: [Date]
            Issuing Authority: [Authority Name]
            """
        case (.marriageCertificate, _):
            return """
            MARRIAGE CERTIFICATE
            
            This is to certify that [Groom's Name] and [Bride's Name] were married on [Date] at [Place].
            
            Date of Issue: [Date]
            Issuing Authority: [Authority Name]
            """
        default:
            return localizationManager.localizedString(.selectDocument)
        }
    }
    
    private func getSampleTranslation(for document: String, language: String) -> String {
        // 書類名をLocalizationKeyで判定
        let documentKey: LocalizationKey
        switch document {
        case localizationManager.localizedString(.birthCertificate):
            documentKey = .birthCertificate
        case localizationManager.localizedString(.marriageCertificate):
            documentKey = .marriageCertificate
        case localizationManager.localizedString(.nationalityCertificate):
            documentKey = .nationalityCertificate
        case localizationManager.localizedString(.graduationCertificate):
            documentKey = .graduationCertificate
        case localizationManager.localizedString(.employmentCertificate):
            documentKey = .employmentCertificate
        case localizationManager.localizedString(.taxCertificate):
            documentKey = .taxCertificate
        default:
            return localizationManager.localizedString(.translatedText)
        }
        
        // 言語に応じて翻訳結果を返す
        switch (documentKey, language) {
        case (.birthCertificate, LocalizationManager.Language.english.displayName):
            return """
            出生証明書
            
            氏名：[氏名]が[日付]に[場所]で[父の氏名]と[母の氏名]の子として出生したことを証明します。
            
            発行日：[日付]
            発行機関：[機関名]
            """
        case (.marriageCertificate, LocalizationManager.Language.english.displayName):
            return """
            婚姻証明書
            
            [新郎の氏名]と[新婦の氏名]が[日付]に[場所]で婚姻したことを証明します。
            
            発行日：[日付]
            発行機関：[機関名]
            """
        default:
            return localizationManager.localizedString(.translatedText)
        }
    }
}

struct FAQItem: View {
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.leading)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct TemplateView: View {
    let document: String
    let language: String
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(document) - \(language)\(localizationManager.localizedString(.templateExample))")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(localizationManager.localizedString(.templateExample))
                            .font(.headline)
                        
                        Text(getTemplateExample(for: document, language: language))
                            .font(.subheadline)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(localizationManager.localizedString(.importantNotes))
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(localizationManager.localizedString(.accurateTranslationImportant))
                            Text(localizationManager.localizedString(.notarizationMayBeRequired))
                            Text(localizationManager.localizedString(.professionalTranslationRecommended))
                            Text(localizationManager.localizedString(.translatorSignatureRequired))
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(localizationManager.localizedString(.findProfessional))
                            .font(.headline)
                        
                        Button(action: {
                            // 専門家紹介サイトを開く
                        }) {
                            Text(localizationManager.localizedString(.findTranslationExpert))
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(localizationManager.localizedString(.templates))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.close)) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func getTemplateExample(for document: String, language: String) -> String {
        // 書類名をLocalizationKeyで判定
        let documentKey: LocalizationKey
        switch document {
        case localizationManager.localizedString(.birthCertificate):
            documentKey = .birthCertificate
        case localizationManager.localizedString(.marriageCertificate):
            documentKey = .marriageCertificate
        case localizationManager.localizedString(.nationalityCertificate):
            documentKey = .nationalityCertificate
        case localizationManager.localizedString(.graduationCertificate):
            documentKey = .graduationCertificate
        case localizationManager.localizedString(.employmentCertificate):
            documentKey = .employmentCertificate
        case localizationManager.localizedString(.taxCertificate):
            documentKey = .taxCertificate
        default:
            return localizationManager.localizedString(.templateExample)
        }
        
        // 言語に応じてテンプレート例を返す
        switch (documentKey, language) {
        case (.birthCertificate, LocalizationManager.Language.english.displayName):
            return """
            CERTIFICATE OF BIRTH
            
            This is to certify that [Full Name] was born on [Date of Birth] at [Place of Birth] to [Father's Full Name] and [Mother's Full Name].
            
            Date of Issue: [Date]
            Issuing Authority: [Authority Name]
            Official Seal: [Seal]
            
            I, [Translator Name], hereby certify that this is a true and accurate translation of the original document.
            
            Translator's Signature: [Signature]
            Date: [Date]
            """
        default:
            return localizationManager.localizedString(.templateExample)
        }
    }
}

#Preview {
    NavigationView {
        TranslationSupportView()
    }
} 