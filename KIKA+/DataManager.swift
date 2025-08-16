//
//  DataManager.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import Foundation
import SwiftUI

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var userProfile: UserProfile
    @Published var applicationProgress: ApplicationProgress
    @Published var savedDocuments: [SavedDocument]
    @Published var reminders: [Reminder]
    @Published var diagnosisResults: [DiagnosisResult]
    @Published var notes: [Note]
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        // 初期データの読み込み
        self.userProfile = DataManager.loadUserProfile()
        self.applicationProgress = DataManager.loadApplicationProgress()
        self.savedDocuments = DataManager.loadSavedDocuments()
        self.reminders = DataManager.loadReminders()
        self.diagnosisResults = DataManager.loadDiagnosisResults()
        self.notes = DataManager.loadNotes()
    }
    
    // MARK: - User Profile
    func updateUserProfile(_ profile: UserProfile) {
        userProfile = profile
        saveUserProfile()
    }
    
    private func saveUserProfile() {
        if let encoded = try? JSONEncoder().encode(userProfile) {
            userDefaults.set(encoded, forKey: "userProfile")
        }
    }
    
    static func loadUserProfile() -> UserProfile {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            return profile
        }
        return UserProfile()
    }
    
    // MARK: - Application Progress
    func updateApplicationProgress(_ progress: ApplicationProgress) {
        applicationProgress = progress
        saveApplicationProgress()
    }
    
    private func saveApplicationProgress() {
        if let encoded = try? JSONEncoder().encode(applicationProgress) {
            userDefaults.set(encoded, forKey: "applicationProgress")
        }
    }
    
    static func loadApplicationProgress() -> ApplicationProgress {
        if let data = UserDefaults.standard.data(forKey: "applicationProgress"),
           let progress = try? JSONDecoder().decode(ApplicationProgress.self, from: data) {
            return progress
        }
        return ApplicationProgress()
    }
    
    // MARK: - Saved Documents
    func addSavedDocument(_ document: SavedDocument) {
        savedDocuments.append(document)
        saveSavedDocuments()
    }
    
    func updateSavedDocument(_ document: SavedDocument) {
        if let index = savedDocuments.firstIndex(where: { $0.id == document.id }) {
            savedDocuments[index] = document
            saveSavedDocuments()
        }
    }
    
    func deleteSavedDocument(_ document: SavedDocument) {
        savedDocuments.removeAll { $0.id == document.id }
        saveSavedDocuments()
    }
    
    private func saveSavedDocuments() {
        if let encoded = try? JSONEncoder().encode(savedDocuments) {
            userDefaults.set(encoded, forKey: "savedDocuments")
        }
    }
    
    static func loadSavedDocuments() -> [SavedDocument] {
        if let data = UserDefaults.standard.data(forKey: "savedDocuments"),
           let documents = try? JSONDecoder().decode([SavedDocument].self, from: data) {
            return documents
        }
        return []
    }
    
    // MARK: - Reminders
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
        saveReminders()
    }
    
    func updateReminder(_ reminder: Reminder) {
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            saveReminders()
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        reminders.removeAll { $0.id == reminder.id }
        saveReminders()
    }
    
    private func saveReminders() {
        if let encoded = try? JSONEncoder().encode(reminders) {
            userDefaults.set(encoded, forKey: "reminders")
        }
    }
    
    static func loadReminders() -> [Reminder] {
        if let data = UserDefaults.standard.data(forKey: "reminders"),
           let reminders = try? JSONDecoder().decode([Reminder].self, from: data) {
            return reminders
        }
        return sampleReminders
    }
    
    // MARK: - Diagnosis Results
    func addDiagnosisResult(_ result: DiagnosisResult) {
        diagnosisResults.append(result)
        saveDiagnosisResults()
    }
    
    private func saveDiagnosisResults() {
        if let encoded = try? JSONEncoder().encode(diagnosisResults) {
            userDefaults.set(encoded, forKey: "diagnosisResults")
        }
    }
    
    static func loadDiagnosisResults() -> [DiagnosisResult] {
        if let data = UserDefaults.standard.data(forKey: "diagnosisResults"),
           let results = try? JSONDecoder().decode([DiagnosisResult].self, from: data) {
            return results
        }
        return []
    }
    
    // MARK: - Notes
    func addNote(_ note: Note) {
        notes.append(note)
        saveNotes()
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
            saveNotes()
        }
    }
    
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        saveNotes()
    }
    
    private func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            userDefaults.set(encoded, forKey: "notes")
        }
    }
    
    static func loadNotes() -> [Note] {
        if let data = UserDefaults.standard.data(forKey: "notes"),
           let notes = try? JSONDecoder().decode([Note].self, from: data) {
            return notes
        }
        return []
    }
    
    // MARK: - Export Data
    func exportData() -> Data? {
        let exportData = ExportData(
            userProfile: userProfile,
            applicationProgress: applicationProgress,
            savedDocuments: savedDocuments,
            reminders: reminders,
            diagnosisResults: diagnosisResults,
            notes: notes
        )
        return try? JSONEncoder().encode(exportData)
    }
    
    // MARK: - Import Data
    func importData(_ data: Data) -> Bool {
        guard let importData = try? JSONDecoder().decode(ExportData.self, from: data) else {
            return false
        }
        
        userProfile = importData.userProfile
        applicationProgress = importData.applicationProgress
        savedDocuments = importData.savedDocuments
        reminders = importData.reminders
        diagnosisResults = importData.diagnosisResults
        notes = importData.notes
        
        // 全データを保存
        saveUserProfile()
        saveApplicationProgress()
        saveSavedDocuments()
        saveReminders()
        saveDiagnosisResults()
        saveNotes()
        
        return true
    }
    
    // MARK: - Clear All Data
    func clearAllData() {
        userProfile = UserProfile()
        applicationProgress = ApplicationProgress()
        savedDocuments = []
        reminders = []
        diagnosisResults = []
        notes = []
        
        // UserDefaultsから削除
        userDefaults.removeObject(forKey: "userProfile")
        userDefaults.removeObject(forKey: "applicationProgress")
        userDefaults.removeObject(forKey: "savedDocuments")
        userDefaults.removeObject(forKey: "reminders")
        userDefaults.removeObject(forKey: "diagnosisResults")
        userDefaults.removeObject(forKey: "notes")
    }
}

// MARK: - Data Models
struct UserProfile: Codable {
    var name: String = ""
    var nationality: String = ""
    var birthDate: Date = Date()
    var residenceStatus: String = ""
    var yearsInJapan: Int = 0
    var occupation: String = ""
    var familyMembers: [FamilyMember] = []
    var preferredLanguage: String = "ja"
    var email: String = ""
    var phone: String = ""
    var address: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
}

struct FamilyMember: Codable, Identifiable {
    let id = UUID()
    var name: String
    var relationship: String
    var nationality: String
    var birthDate: Date
    
    private enum CodingKeys: String, CodingKey {
        case name, relationship, nationality, birthDate
    }
}

struct ApplicationProgress: Codable {
    var currentStep: Int = 0
    var completedSteps: [Int] = []
    var startDate: Date = Date()
    var estimatedCompletionDate: Date?
    var notes: String = ""
    var documentsCollected: [String] = []
    var documentsSubmitted: [String] = []
    var interviewsCompleted: [InterviewRecord] = []
    var lastUpdated: Date = Date()
}

struct InterviewRecord: Codable, Identifiable {
    let id = UUID()
    var date: Date
    var location: String
    var interviewer: String
    var notes: String
    var status: InterviewStatus
    
    private enum CodingKeys: String, CodingKey {
        case date, location, interviewer, notes, status
    }
}

enum InterviewStatus: String, Codable, CaseIterable {
    case scheduled = "scheduled"
    case completed = "completed"
    case cancelled = "cancelled"
    case rescheduled = "rescheduled"
}

struct SavedDocument: Codable, Identifiable {
    let id = UUID()
    var name: String
    var type: DocumentType
    var status: DocumentStatus
    var filePath: String?
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    var dueDate: Date?
    var priority: DocumentPriority
    
    private enum CodingKeys: String, CodingKey {
        case name, type, status, filePath, notes, createdAt, updatedAt, dueDate, priority
    }
}

enum DocumentType: String, Codable, CaseIterable {
    case birthCertificate = "birth_certificate"
    case marriageCertificate = "marriage_certificate"
    case divorceCertificate = "divorce_certificate"
    case passport = "passport"
    case residenceCard = "residence_card"
    case taxCertificate = "tax_certificate"
    case employmentCertificate = "employment_certificate"
    case bankStatement = "bank_statement"
    case other = "other"
}

enum DocumentStatus: String, Codable, CaseIterable {
    case notStarted = "not_started"
    case inProgress = "in_progress"
    case completed = "completed"
    case submitted = "submitted"
    case rejected = "rejected"
}


struct DiagnosisResult: Codable, Identifiable {
    let id = UUID()
    var date: Date
    var score: Int
    var eligibility: Bool
    var answers: [DiagnosisAnswer]
    var recommendations: [String]
    var notes: String
    
    private enum CodingKeys: String, CodingKey {
        case date, score, eligibility, answers, recommendations, notes
    }
}

struct DiagnosisAnswer: Codable {
    var question: String
    var answer: Bool
    var explanation: String
}

struct Note: Codable, Identifiable {
    let id = UUID()
    var title: String
    var content: String
    var category: String
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
    var isImportant: Bool
    
    private enum CodingKeys: String, CodingKey {
        case title, content, category, tags, createdAt, updatedAt, isImportant
    }
}

struct ExportData: Codable {
    let userProfile: UserProfile
    let applicationProgress: ApplicationProgress
    let savedDocuments: [SavedDocument]
    let reminders: [Reminder]
    let diagnosisResults: [DiagnosisResult]
    let notes: [Note]
    let exportDate: Date = Date()
    let appVersion: String = "1.0.0"
    
    private enum CodingKeys: String, CodingKey {
        case userProfile, applicationProgress, savedDocuments, reminders, diagnosisResults, notes
    }
}

// MARK: - Extensions for Codable
// 各ファイルで直接実装済み 

// MARK: - Reminder Models
struct Reminder: Codable, Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let dueDate: Date
    let priority: ReminderPriority
    let category: String
    var isCompleted: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case title, description, dueDate, priority, category, isCompleted
    }
}

enum ReminderPriority: String, Codable, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .orange
        case .high: return .red
        }
    }
}

// サンプルリマインダーデータ
let sampleReminders: [Reminder] = [] 