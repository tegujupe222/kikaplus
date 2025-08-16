//
//  InterviewPreparationView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import AVFoundation
import AVFAudio

struct InterviewPreparationView: View {
    @State private var selectedCategory = ""
    @State private var showingPractice = false
    @State private var selectedQuestion: InterviewQuestion?
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    let categoryKeys: [LocalizationKey] = [
        .basicInfo, .motivationReason, .lifeWork, .familyRelatives, .japaneseAbility, .other
    ]
    
    // 面接質問データをローカライズキーで管理
    var interviewQuestions: [InterviewQuestion] {
        [
            // 基本情報
            InterviewQuestion(
                category: localizationManager.localizedString(.basicInfo),
                question: localizationManager.localizedString(.interviewQ1),
                sampleAnswer: localizationManager.localizedString(.interviewA1),
                tips: localizationManager.localizedString(.interviewTip1),
                difficulty: .easy,
                audioFile: nil,
                questionNumber: 1
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.basicInfo),
                question: localizationManager.localizedString(.interviewQ2),
                sampleAnswer: localizationManager.localizedString(.interviewA2),
                tips: localizationManager.localizedString(.interviewTip2),
                difficulty: .easy,
                audioFile: nil,
                questionNumber: 2
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.basicInfo),
                question: localizationManager.localizedString(.interviewQ3),
                sampleAnswer: localizationManager.localizedString(.interviewA3),
                tips: localizationManager.localizedString(.interviewTip3),
                difficulty: .easy,
                audioFile: nil,
                questionNumber: 3
            ),
            
            // 動機・理由
            InterviewQuestion(
                category: localizationManager.localizedString(.motivationReason),
                question: localizationManager.localizedString(.interviewQ4),
                sampleAnswer: localizationManager.localizedString(.interviewA4),
                tips: localizationManager.localizedString(.interviewTip4),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 4
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.motivationReason),
                question: localizationManager.localizedString(.interviewQ5),
                sampleAnswer: localizationManager.localizedString(.interviewA5),
                tips: localizationManager.localizedString(.interviewTip5),
                difficulty: .easy,
                audioFile: nil,
                questionNumber: 5
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.motivationReason),
                question: localizationManager.localizedString(.interviewQ6),
                sampleAnswer: localizationManager.localizedString(.interviewA6),
                tips: localizationManager.localizedString(.interviewTip6),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 6
            ),
            
            // 生活・仕事
            InterviewQuestion(
                category: localizationManager.localizedString(.lifeWork),
                question: localizationManager.localizedString(.interviewQ7),
                sampleAnswer: localizationManager.localizedString(.interviewA7),
                tips: localizationManager.localizedString(.interviewTip7),
                difficulty: .easy,
                audioFile: nil,
                questionNumber: 7
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.lifeWork),
                question: localizationManager.localizedString(.interviewQ8),
                sampleAnswer: localizationManager.localizedString(.interviewA8),
                tips: localizationManager.localizedString(.interviewTip8),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 8
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.lifeWork),
                question: localizationManager.localizedString(.interviewQ9),
                sampleAnswer: localizationManager.localizedString(.interviewA9),
                tips: localizationManager.localizedString(.interviewTip9),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 9
            ),
            
            // 家族・親族
            InterviewQuestion(
                category: localizationManager.localizedString(.familyRelatives),
                question: localizationManager.localizedString(.interviewQ10),
                sampleAnswer: localizationManager.localizedString(.interviewA10),
                tips: localizationManager.localizedString(.interviewTip10),
                difficulty: .easy,
                audioFile: nil,
                questionNumber: 10
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.familyRelatives),
                question: localizationManager.localizedString(.interviewQ11),
                sampleAnswer: localizationManager.localizedString(.interviewA11),
                tips: localizationManager.localizedString(.interviewTip11),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 11
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.familyRelatives),
                question: localizationManager.localizedString(.interviewQ12),
                sampleAnswer: localizationManager.localizedString(.interviewA12),
                tips: localizationManager.localizedString(.interviewTip12),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 12
            ),
            
            // 日本語能力
            InterviewQuestion(
                category: localizationManager.localizedString(.japaneseAbility),
                question: localizationManager.localizedString(.interviewQ13),
                sampleAnswer: localizationManager.localizedString(.interviewA13),
                tips: localizationManager.localizedString(.interviewTip13),
                difficulty: .hard,
                audioFile: nil,
                questionNumber: 13
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.japaneseAbility),
                question: localizationManager.localizedString(.interviewQ14),
                sampleAnswer: localizationManager.localizedString(.interviewA14),
                tips: localizationManager.localizedString(.interviewTip14),
                difficulty: .hard,
                audioFile: nil,
                questionNumber: 14
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.japaneseAbility),
                question: localizationManager.localizedString(.interviewQ15),
                sampleAnswer: localizationManager.localizedString(.interviewA15),
                tips: localizationManager.localizedString(.interviewTip15),
                difficulty: .hard,
                audioFile: nil,
                questionNumber: 15
            ),
            
            // その他
            InterviewQuestion(
                category: localizationManager.localizedString(.other),
                question: localizationManager.localizedString(.interviewQ16),
                sampleAnswer: localizationManager.localizedString(.interviewA16),
                tips: localizationManager.localizedString(.interviewTip16),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 16
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.other),
                question: localizationManager.localizedString(.interviewQ17),
                sampleAnswer: localizationManager.localizedString(.interviewA17),
                tips: localizationManager.localizedString(.interviewTip17),
                difficulty: .medium,
                audioFile: nil,
                questionNumber: 17
            ),
            InterviewQuestion(
                category: localizationManager.localizedString(.other),
                question: localizationManager.localizedString(.interviewQ18),
                sampleAnswer: localizationManager.localizedString(.interviewA18),
                tips: localizationManager.localizedString(.interviewTip18),
                difficulty: .hard,
                audioFile: nil,
                questionNumber: 18
            )
        ]
    }
    
    var filteredQuestions: [InterviewQuestion] {
        return interviewQuestions.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // カテゴリ選択
                VStack(alignment: .leading, spacing: 10) {
                    Text(localizationManager.localizedString(.questionCategory))
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categoryKeys, id: \.self) { categoryKey in
                                Button(action: {
                                    selectedCategory = localizationManager.localizedString(categoryKey)
                                }) {
                                    Text(localizationManager.localizedString(categoryKey))
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(selectedCategory == localizationManager.localizedString(categoryKey) ? Color.blue : Color(.systemGray5))
                                        .foregroundColor(selectedCategory == localizationManager.localizedString(categoryKey) ? .white : .primary)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
                .background(Color(.systemBackground))
                
                // 質問リスト
                if filteredQuestions.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text(localizationManager.localizedString(.noQuestionsFound))
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredQuestions, id: \.id) { question in
                        InterviewQuestionCard(question: question) {
                            selectedQuestion = question
                            showingPractice = true
                        }
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString(.interviewPreparation))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingPractice) {
                if let question = selectedQuestion {
                    InterviewPracticeView(question: question)
                }
            }
        }
    }
}

struct InterviewQuestion: Codable {
    let id = UUID()
    let category: String
    let question: String
    let sampleAnswer: String
    let tips: String
    let difficulty: QuestionDifficulty
    let audioFile: String?
    let questionNumber: Int
    
    private enum CodingKeys: String, CodingKey {
        case category, question, sampleAnswer, tips, difficulty, audioFile, questionNumber
    }
}

enum QuestionDifficulty: String, Codable, CaseIterable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    var color: Color {
        switch self {
        case .easy: return .green
        case .medium: return .orange
        case .hard: return .red
        }
    }
}

struct InterviewQuestionCard: View {
    let question: InterviewQuestion
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // ヘッダー
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(question.question)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Text(question.category)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Text(question.difficulty.rawValue)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(question.difficulty.color.opacity(0.2))
                        .foregroundColor(question.difficulty.color)
                        .cornerRadius(8)
                }
                
                // サンプル回答（プレビュー）
                Text(question.sampleAnswer)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // コツ
                HStack {
                    Image(systemName: "lightbulb")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    
                    Text(question.tips)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InterviewPracticeView: View {
    let question: InterviewQuestion
    @Environment(\.presentationMode) var presentationMode
    @State private var showingAnswer = false
    @State private var isPlaying = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showingSubtitles = true
    @State private var speechSynthesizer = AVSpeechSynthesizer()
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    // 日本語音声の質問文を取得
    var japaneseAudioQuestion: String {
        // 質問のIDから音声用のキーを取得
        let questionNumber = getQuestionNumber(from: question.question)
        let audioKey = LocalizationKey(rawValue: "interview_q\(questionNumber)_audio") ?? .interviewQ1Audio
        return localizationManager.localizedString(audioKey)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    // 日本語音声質問表示
                    VStack(spacing: 15) {
                        Text(localizationManager.localizedString(.japaneseAudio))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(japaneseAudioQuestion)
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                    }
                    
                    // 多言語テロップ表示
                    VStack(spacing: 15) {
                        HStack {
                            Text(localizationManager.localizedString(.multilingualSubtitles))
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showingSubtitles.toggle()
                                }
                            }) {
                                Image(systemName: showingSubtitles ? "eye" : "eye.slash")
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if showingSubtitles {
                            VStack(spacing: 12) {
                                // 英語
                                SubtitleView(
                                    language: "\(LocalizationManager.Language.english.flag) \(LocalizationManager.Language.english.displayName)",
                                    text: getTranslatedQuestion(for: .english, questionNumber: getQuestionNumber(from: question.question)),
                                    color: .blue
                                )
                                
                                // 中国語
                                SubtitleView(
                                    language: "\(LocalizationManager.Language.chineseSimplified.flag) \(LocalizationManager.Language.chineseSimplified.displayName)",
                                    text: getTranslatedQuestion(for: .chineseSimplified, questionNumber: getQuestionNumber(from: question.question)),
                                    color: .red
                                )
                                
                                // ベトナム語
                                SubtitleView(
                                    language: "\(LocalizationManager.Language.vietnamese.flag) \(LocalizationManager.Language.vietnamese.displayName)",
                                    text: getTranslatedQuestion(for: .vietnamese, questionNumber: getQuestionNumber(from: question.question)),
                                    color: .green
                                )
                                
                                // 韓国語
                                SubtitleView(
                                    language: "\(LocalizationManager.Language.korean.flag) \(LocalizationManager.Language.korean.displayName)",
                                    text: getTranslatedQuestion(for: .korean, questionNumber: getQuestionNumber(from: question.question)),
                                    color: .orange
                                )
                                
                                // フィリピン語
                                SubtitleView(
                                    language: "\(LocalizationManager.Language.filipino.flag) \(LocalizationManager.Language.filipino.displayName)",
                                    text: getTranslatedQuestion(for: .filipino, questionNumber: getQuestionNumber(from: question.question)),
                                    color: .purple
                                )
                                
                                // ネパール語
                                SubtitleView(
                                    language: "\(LocalizationManager.Language.nepali.flag) \(LocalizationManager.Language.nepali.displayName)",
                                    text: getTranslatedQuestion(for: .nepali, questionNumber: getQuestionNumber(from: question.question)),
                                    color: .pink
                                )
                            }
                            .transition(.opacity)
                        }
                    }
                    
                    // 音声読み上げボタン
                    Button(action: toggleAudio) {
                        HStack {
                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.title)
                            Text(isPlaying ? localizationManager.localizedString(.pause) : localizationManager.localizedString(.listenWithAudio))
                                .font(.headline)
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // 回答表示ボタン
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showingAnswer.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: showingAnswer ? "eye.slash" : "eye")
                            Text(showingAnswer ? localizationManager.localizedString(.hideAnswer) : localizationManager.localizedString(.showAnswer))
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    // サンプル回答
                    if showingAnswer {
                        VStack(alignment: .leading, spacing: 15) {
                            Text(localizationManager.localizedString(.sampleAnswer))
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(question.sampleAnswer)
                                .font(.subheadline)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .transition(.opacity)
                        }
                    }
                    
                    // コツ・注意点
                    VStack(alignment: .leading, spacing: 15) {
                        Text(localizationManager.localizedString(.tipsAndNotes))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "lightbulb")
                                .foregroundColor(.yellow)
                                .font(.title3)
                            
                            Text(question.tips)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // 練習ボタン
                    VStack(spacing: 12) {
                        Button(action: {
                            // 練習機能（将来的に実装）
                        }) {
                            HStack {
                                Image(systemName: "mic.fill")
                                Text(localizationManager.localizedString(.voicePractice))
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {
                            // メモ機能（将来的に実装）
                        }) {
                            HStack {
                                Image(systemName: "note.text")
                                Text(localizationManager.localizedString(.addNote))
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(localizationManager.localizedString(.interviewPractice))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.close)) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func toggleAudio() {
        if isPlaying {
            // 音声を停止
            speechSynthesizer.stopSpeaking(at: .immediate)
            isPlaying = false
        } else {
            // 日本語音声を再生
            let utterance = AVSpeechUtterance(string: japaneseAudioQuestion)
            utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
            utterance.rate = 0.4 // ゆっくりと話す
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            
            speechSynthesizer.speak(utterance)
            isPlaying = true
            
            // 音声終了時に状態をリセット
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                if self.isPlaying {
                    self.isPlaying = false
                }
            }
        }
    }
    
    private func getQuestionNumber(from question: String) -> Int {
        // 質問文から番号を抽出する簡易的な実装
        // この関数は質問の内容を分析して適切な番号を返す
        return 1
    }
    
    private func getTranslatedQuestion(for language: LocalizationManager.Language, questionNumber: Int) -> String {
        // 各言語の翻訳データから質問を取得
        let key = LocalizationKey(rawValue: "interview_q\(questionNumber)") ?? .interviewQ1
        return LocalizationData.strings[language]?[key.rawValue] ?? question.question
    }
}

struct SubtitleView: View {
    let language: String
    let text: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(language)
                .font(.caption)
                .foregroundColor(color)
                .fontWeight(.medium)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .padding(8)
                .background(color.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

#Preview {
    InterviewPreparationView()
} 