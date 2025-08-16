//
//  StepGuideView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import Combine
import Foundation

struct StepGuideView: View {
    @State private var currentStep = 0
    @State private var completedSteps: Set<Int> = []
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var steps: [Step] {
        [
            Step(
                id: 0,
                title: localizationManager.localizedString(.step1Title),
                description: localizationManager.localizedString(.step1Description),
                details: [
                    localizationManager.localizedString(.step1Detail1),
                    localizationManager.localizedString(.step1Detail2),
                    localizationManager.localizedString(.step1Detail3),
                    localizationManager.localizedString(.step1Detail4)
                ],
                estimatedTime: "2-3 weeks",
                requiredDocuments: [
                    localizationManager.localizedString(.step1RequiredDoc1),
                    localizationManager.localizedString(.step1RequiredDoc2)
                ],
                tips: localizationManager.localizedString(.step1Tips)
            ),
            Step(
                id: 1,
                title: localizationManager.localizedString(.step2Title),
                description: localizationManager.localizedString(.step2Description),
                details: [
                    localizationManager.localizedString(.step2Detail1),
                    localizationManager.localizedString(.step2Detail2),
                    localizationManager.localizedString(.step2Detail3)
                ],
                estimatedTime: "1-2 weeks",
                requiredDocuments: [
                    localizationManager.localizedString(.step2RequiredDoc1),
                    localizationManager.localizedString(.step2RequiredDoc2)
                ],
                tips: localizationManager.localizedString(.step2Tips)
            ),
            Step(
                id: 2,
                title: localizationManager.localizedString(.step3Title),
                description: localizationManager.localizedString(.step3Description),
                details: [
                    localizationManager.localizedString(.step3Detail1),
                    localizationManager.localizedString(.step3Detail2),
                    localizationManager.localizedString(.step3Detail3)
                ],
                estimatedTime: "1 day",
                requiredDocuments: [
                    localizationManager.localizedString(.step3RequiredDoc1),
                    localizationManager.localizedString(.step3RequiredDoc2)
                ],
                tips: localizationManager.localizedString(.step3Tips)
            ),
            Step(
                id: 3,
                title: localizationManager.localizedString(.step4Title),
                description: localizationManager.localizedString(.step4Description),
                details: [
                    localizationManager.localizedString(.step4Detail1),
                    localizationManager.localizedString(.step4Detail2),
                    localizationManager.localizedString(.step4Detail3)
                ],
                estimatedTime: "3-6 months",
                requiredDocuments: [
                    localizationManager.localizedString(.step4RequiredDoc1),
                    localizationManager.localizedString(.step4RequiredDoc2)
                ],
                tips: localizationManager.localizedString(.step4Tips)
            ),
            Step(
                id: 4,
                title: localizationManager.localizedString(.step5Title),
                description: localizationManager.localizedString(.step5Description),
                details: [
                    localizationManager.localizedString(.step5Detail1),
                    localizationManager.localizedString(.step5Detail2),
                    localizationManager.localizedString(.step5Detail3)
                ],
                estimatedTime: "1-2 weeks",
                requiredDocuments: [
                    localizationManager.localizedString(.step5RequiredDoc1),
                    localizationManager.localizedString(.step5RequiredDoc2)
                ],
                tips: localizationManager.localizedString(.step5Tips)
            )
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 進捗バー
                VStack(spacing: 10) {
                    HStack {
                        Text(localizationManager.localizedString(.progressStatus))
                            .font(.headline)
                        Spacer()
                        Text("\(completedSteps.count)/\(steps.count)\(localizationManager.localizedString(.stepCompleted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: Double(completedSteps.count), total: Double(steps.count))
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
                .padding(.horizontal)
                
                // ステップ一覧
                ForEach(steps, id: \.id) { step in
                    StepCard(
                        step: step,
                        isCompleted: completedSteps.contains(step.id),
                        isCurrent: currentStep == step.id
                    ) {
                        if completedSteps.contains(step.id) {
                            completedSteps.remove(step.id)
                        } else {
                            completedSteps.insert(step.id)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(localizationManager.localizedString(.stepGuideTitle))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Step {
    let id: Int
    let title: String
    let description: String
    let details: [String]
    let estimatedTime: String
    let requiredDocuments: [String]
    let tips: String
}

struct StepCard: View {
    let step: Step
    let isCompleted: Bool
    let isCurrent: Bool
    let onToggle: () -> Void
    
    @State private var isExpanded = false
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            // ステップヘッダー
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    // ステップ番号
                    ZStack {
                        Circle()
                            .fill(isCompleted ? Color.green : (isCurrent ? Color.blue : Color.gray))
                            .frame(width: 40, height: 40)
                        
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        } else {
                            Text("\(step.id + 1)")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(step.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(step.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    // 完了ボタン
                    Button(action: onToggle) {
                        Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isCompleted ? .green : .gray)
                            .font(.title2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // 展開ボタン
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .buttonStyle(PlainButtonStyle())
            
            // 詳細内容
            if isExpanded {
                VStack(alignment: .leading, spacing: 15) {
                    // 詳細手順
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.localizedString(.detailedSteps))
                            .font(.headline)
                            .padding(.top)
                        
                        ForEach(step.details, id: \.self) { detail in
                            HStack(alignment: .top, spacing: 8) {
                                Text(localizationManager.localizedString(.bulletPoint))
                                    .foregroundColor(.blue)
                                Text(detail)
                                    .font(.subheadline)
                            }
                        }
                    }
                    
                    // 所要時間
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.orange)
                        Text("\(localizationManager.localizedString(.estimatedTime)): \(step.estimatedTime)")
                            .font(.caption)
                        Spacer()
                    }
                    
                    // 必要書類
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.localizedString(.requiredDocuments))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        ForEach(step.requiredDocuments, id: \.self) { document in
                            HStack {
                                Image(systemName: "doc.text")
                                    .foregroundColor(.blue)
                                Text(document)
                                    .font(.caption)
                                Spacer()
                            }
                        }
                    }
                    
                    // コツ・注意点
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.localizedString(.tips))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        HStack(alignment: .top) {
                            Image(systemName: "lightbulb")
                                .foregroundColor(.yellow)
                            Text(step.tips)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        StepGuideView()
    }
} 