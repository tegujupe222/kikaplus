//
//  DiagnosisView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import Combine
import Foundation

struct DiagnosisView: View {
    @State private var currentQuestionIndex = 0
    @State private var answers: [Bool?] = Array(repeating: nil, count: 10)
    @State private var showingResult = false
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    let questions: [String] = []
    
    let questionKeys: [LocalizationKey] = [
        .diagnosisQ1, .diagnosisQ2, .diagnosisQ3, .diagnosisQ4, .diagnosisQ5, .diagnosisQ6, .diagnosisQ7, .diagnosisQ8, .diagnosisQ9, .diagnosisQ10
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            VStack(spacing: 16) {
                // プログレスバー
                VStack(spacing: 8) {
                    HStack {
                        Text(localizationManager.localizedString(.progressFormat, arguments: ["\(currentQuestionIndex + 1)", "\(questionKeys.count)"]))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text(localizationManager.localizedString(.percentageFormat, arguments: ["\(Int((Double(currentQuestionIndex + 1) / Double(questionKeys.count)) * 100))"]))
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                    
                    ProgressView(value: Double(currentQuestionIndex + 1), total: Double(questionKeys.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // 質問番号
                Text(localizationManager.localizedString(.question))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 24)
            }
            .padding(.bottom, 32)
            .background(Color(.systemBackground))
            
            // メインコンテンツ
            ScrollView {
                VStack(spacing: 32) {
                    // 質問カード
                    VStack(spacing: 24) {
                        // 質問テキスト
                        VStack(spacing: 16) {
                            Text(localizationManager.localizedString(questionKeys[currentQuestionIndex]))
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 24)
                            
                            // 質問の説明（必要に応じて）
                            if currentQuestionIndex == 2 {
                                Text(localizationManager.localizedString(.criminalRecordExplanation))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 32)
                            }
                        }
                        .padding(.vertical, 32)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal, 24)
                    }
                    
                    // 回答ボタン
                    VStack(spacing: 16) {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                answers[currentQuestionIndex] = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                nextQuestion()
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text(localizationManager.localizedString(.yes))
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [.green, .green.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                answers[currentQuestionIndex] = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                nextQuestion()
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text(localizationManager.localizedString(.no))
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                LinearGradient(
                                    colors: [.red, .red.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(16)
                            .shadow(color: .red.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    
                    // 戻るボタン（最初の質問以外で表示）
                    if currentQuestionIndex > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                currentQuestionIndex -= 1
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text(localizationManager.localizedString(.back))
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.blue)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 24)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(localizationManager.localizedString(.diagnosisTitle))
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingResult) {
            DiagnosisResultView(answers: answers, questionKeys: questionKeys)
        }
    }
    
    private func nextQuestion() {
        if currentQuestionIndex < questionKeys.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentQuestionIndex += 1
            }
        } else {
            showingResult = true
        }
    }
}

struct DiagnosisResultView: View {
    let answers: [Bool?]
    let questionKeys: [LocalizationKey]
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var eligibilityScore: Int {
        let yesAnswers = answers.compactMap { $0 }.filter { $0 }.count
        return Int((Double(yesAnswers) / Double(questionKeys.count)) * 100)
    }
    
    var eligibilityStatus: String {
        if eligibilityScore >= 80 {
            return localizationManager.localizedString(.eligible)
        } else if eligibilityScore >= 60 {
            return localizationManager.localizedString(.possibleEligibility)
        } else {
            return localizationManager.localizedString(.insufficientEligibility)
        }
    }
    
    var statusColor: Color {
        if eligibilityScore >= 80 {
            return .green
        } else if eligibilityScore >= 60 {
            return .orange
        } else {
            return .red
        }
    }
    
    var stepItems: [(String, LocalizationKey, LocalizationKey)] {
        eligibilityScore >= 80 ? [
            ("1", .diagnosisStep1Title, .diagnosisStep1Desc),
            ("2", .diagnosisStep2Title, .diagnosisStep2Desc),
            ("3", .diagnosisStep3Title, .diagnosisStep3Desc),
            ("4", .diagnosisStep4Title, .diagnosisStep4Desc)
        ] : [
            ("1", .diagnosisStepNG1Title, .diagnosisStepNG1Desc),
            ("2", .diagnosisStepNG2Title, .diagnosisStepNG2Desc),
            ("3", .diagnosisStepNG3Title, .diagnosisStepNG3Desc)
        ]
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // 結果ヘッダー
                    VStack(spacing: 24) {
                        // 結果アイコン
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [statusColor, statusColor.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .shadow(color: statusColor.opacity(0.3), radius: 12, x: 0, y: 6)
                            
                            Image(systemName: eligibilityScore >= 80 ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .font(.system(size: 48, weight: .medium))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text(localizationManager.localizedString(.result))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(.primary)
                            
                            Text(localizationManager.localizedString(.percentageFormat, arguments: ["\(eligibilityScore)"]))
                                .font(.system(size: 56, weight: .bold, design: .rounded))
                                .foregroundColor(statusColor)
                            
                            Text(eligibilityStatus)
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundColor(statusColor)
                        }
                    }
                    .padding(.top, 32)
                    
                    // 詳細結果
                    VStack(alignment: .leading, spacing: 20) {
                        Text(localizationManager.localizedString(.detailedResult))
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 12) {
                            ForEach(Array(questionKeys.enumerated()), id: \.offset) { index, questionKey in
                                HStack(spacing: 16) {
                                    // 質問番号
                                    ZStack {
                                        Circle()
                                            .fill(Color(.systemGray5))
                                            .frame(width: 32, height: 32)
                                        
                                        Text("\(index + 1)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    // 質問テキスト
                                    Text(localizationManager.localizedString(questionKey))
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    // 回答結果
                                    if let answer = answers[index] {
                                        Image(systemName: answer ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundColor(answer ? .green : .red)
                                    }
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    // 次のステップ
                    VStack(alignment: .leading, spacing: 20) {
                        Text(localizationManager.localizedString(.nextSteps))
                            .font(.system(size: 20, weight: .semibold, design: .rounded))
                            .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            ForEach(stepItems, id: \.0) { stepNumber, titleKey, descKey in
                                HStack(spacing: 16) {
                                    // ステップ番号
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [.blue, .blue.opacity(0.8)],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 40, height: 40)
                                        
                                        Text(stepNumber)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(localizationManager.localizedString(titleKey))
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.primary)
                                        
                                        Text(localizationManager.localizedString(descKey))
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.secondary)
                                            .lineLimit(3)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 24)
                                .padding(.vertical, 16)
                                .background(Color(.systemBackground))
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(localizationManager.localizedString(.result))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.done)) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

#Preview {
    DiagnosisView()
} 