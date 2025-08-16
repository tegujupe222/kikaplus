import SwiftUI

// MARK: - Common Form Components

struct FormField<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            content
                .padding(16)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Common UI Components

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Data Models

struct Document: Identifiable, Codable {
    let id: String
    var name: String
    var description: String
    var countries: [String]
    var statuses: [String]
    var whereToGet: String
    var example: String
    var notes: String
    var priority: DocumentPriority
    var category: DocumentCategory
    var isRequired: Bool
    var isCompleted: Bool
    var dueDate: Date?
    
    init(id: String, name: String, description: String, countries: [String], statuses: [String], whereToGet: String, example: String, notes: String, priority: DocumentPriority, category: DocumentCategory = .other, isRequired: Bool = true, isCompleted: Bool = false, dueDate: Date? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.countries = countries
        self.statuses = statuses
        self.whereToGet = whereToGet
        self.example = example
        self.notes = notes
        self.priority = priority
        self.category = category
        self.isRequired = isRequired
        self.isCompleted = isCompleted
        self.dueDate = dueDate
    }
}

enum DocumentCategory: String, CaseIterable, Codable {
    case personal = "personal"
    case financial = "financial"
    case legal = "legal"
    case medical = "medical"
    case employment = "employment"
    case other = "other"
    
    var localizedName: String {
        return LocalizationManager.shared.localizedString(LocalizationKey(rawValue: self.rawValue) ?? .other)
    }
}

enum DocumentPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var localizedName: String {
        return LocalizationManager.shared.localizedString(LocalizationKey(rawValue: self.rawValue) ?? .other)
    }
} 