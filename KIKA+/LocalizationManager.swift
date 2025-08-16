//
//  LocalizationManager.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    @Published var currentLanguage: Language = .japanese
    
    enum Language: String, CaseIterable {
        case japanese = "ja"
        case english = "en"
        case chineseSimplified = "zh-Hans"
        case chineseTraditional = "zh-Hant"
        case vietnamese = "vi"
        case korean = "ko"
        case filipino = "fil"
        case nepali = "ne"
        
        var displayName: String {
            switch self {
            case .japanese: return "日本語"
            case .english: return "English"
            case .chineseSimplified: return "中文（简体）"
            case .chineseTraditional: return "中文（繁體）"
            case .vietnamese: return "Tiếng Việt"
            case .korean: return "한국어"
            case .filipino: return "Filipino"
            case .nepali: return "नेपाली"
            }
        }
        
        var flag: String {
            switch self {
            case .japanese: return "🇯🇵"
            case .english: return "🇺🇸"
            case .chineseSimplified: return "🇨🇳"
            case .chineseTraditional: return "🇹🇼"
            case .vietnamese: return "🇻🇳"
            case .korean: return "🇰🇷"
            case .filipino: return "🇵🇭"
            case .nepali: return "🇳🇵"
            }
        }
    }
    
    private init() {
        // 保存された言語設定を読み込み
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = Language(rawValue: savedLanguage) {
            currentLanguage = language
        } else {
            // デフォルトは日本語
            currentLanguage = .japanese
        }
    }
    
    func setLanguage(_ language: Language) {
        currentLanguage = language
        UserDefaults.standard.set(language.rawValue, forKey: "selectedLanguage")
        
        // DataManagerのユーザープロフィールも更新
        var profile = DataManager.shared.userProfile
        profile.preferredLanguage = language.displayName
        DataManager.shared.updateUserProfile(profile)
    }
    
    func localizedString(_ key: LocalizationKey) -> String {
        let result = LocalizationData.strings[currentLanguage]?[key.rawValue] ?? key.rawValue
        return result
    }
}

enum LocalizationKey: String, CaseIterable, RawRepresentable {
    // 共通
    case appName = "app_name"
    case appSubtitle = "app_subtitle"
    case languageSelection = "language_selection"
    case settings = "settings"
    case cancel = "cancel"
    case save = "save"
    case delete = "delete"
    case edit = "edit"
    case close = "close"
    case next = "next"
    case back = "back"
    case done = "done"
    case loading = "loading"
    case error = "error"
    case success = "success"
    case yes = "yes"
    case no = "no"
    
    // TranslationSupportView用
    case selectLanguage = "select_language"
    case selectDocument = "select_document"
    case originalText = "original_text"
    case translate = "translate"
    case translatedText = "translated_text"
    case copy = "copy"
    case faq = "faq"
    case translationSupportTitle = "translation_support_title"
    case templates = "templates"
    case showTemplate = "show_template"
    
    // メインメニュー
    case diagnosisCheck = "diagnosis_check"
    case diagnosisSubtitle = "diagnosis_subtitle"
    case stepGuide = "step_guide"
    case stepGuideSubtitle = "step_guide_subtitle"
    case documentChecklist = "document_checklist"
    case documentChecklistSubtitle = "document_checklist_subtitle"
    case translationSupport = "translation_support"
    case translationSupportSubtitle = "translation_support_subtitle"
    case legalOfficeSearch = "legal_office_search"
    case legalOfficeSearchSubtitle = "legal_office_search_subtitle"
    case interviewPreparation = "interview_preparation"
    case interviewPreparationSubtitle = "interview_preparation_subtitle"
    case notificationManagement = "notification_management"
    case notificationManagementSubtitle = "notification_management_subtitle"
    
    // DiagnosisView用
    case question = "question"
    case diagnosisTitle = "diagnosis_title"
    case eligible = "eligible"
    case possibleEligibility = "possible_eligibility"
    case insufficientEligibility = "insufficient_eligibility"
    case result = "result"
    case eligibilityScore = "eligibility_score"
    case detailedResult = "detailed_result"
    case nextSteps = "next_steps"
    
    // DocumentChecklistView用
    case documentChecklistTitle = "document_checklist_title"
    case documentDetailTitle = "document_detail_title"
    case whereToGet = "where_to_get"
    case examples = "examples"
    case notes = "notes"
    case correspondingCountryStatus = "corresponding_country_status"
    case correspondingCountry = "corresponding_country"
    case correspondingStatus = "corresponding_status"
    case selectCountry = "select_country"
    case selectStatus = "select_status"
    case necessaryDocumentProgress = "necessary_document_progress"
    case completed = "completed"
    
    // StepGuideView用
    case stepGuideTitle = "step_guide_title"
    case estimatedTime = "estimated_time"
    case requiredDocuments = "required_documents"
    case tips = "tips"
    
    // その他の画面用
    case progressStatus = "progress_status"
    case stepCompleted = "step_completed"
    case detailedSteps = "detailed_steps"
    case filter = "filter"
    case addReminder = "add_reminder"
    case expired = "expired"
    case daysRemaining = "days_remaining"
    case basicInfo = "basic_info"
    case deadline = "deadline"
    case description = "description"
    case resetNotification = "reset_notification"
    case addToCalendar = "add_to_calendar"
    case prefecture = "prefecture"
    case noLegalOfficeFound = "no_legal_office_found"
    case tryDifferentSearch = "try_different_search"
    case consultationDate = "consultation_date"
    case callPhone = "call_phone"
    case openWebsite = "open_website"
    case openInMap = "open_in_map"
    case questionCategory = "question_category"
    case noQuestionsFound = "no_questions_found"
    case sampleAnswer = "sample_answer"
    case tipsAndNotes = "tips_and_notes"
    case voicePractice = "voice_practice"
    case addNote = "add_note"
    case profile = "profile"
    case appSettings = "app_settings"
    case languageSettings = "language_settings"
    case notificationSettings = "notification_settings"
    case dataManagement = "data_management"
    case exportData = "export_data"
    case importData = "import_data"
    case deleteAllData = "delete_all_data"
    case statistics = "statistics"
    case appInfo = "app_info"
    case version = "version"
    case helpSupport = "help_support"
    case rateApp = "rate_app"
    case deleteDataWarning = "delete_data_warning"
    case residenceStatus = "residence_status"
    case occupationContact = "occupation_contact"
    case reminderTime = "reminder_time"
    case notificationExamples = "notification_examples"
    case notificationExamplesFooter = "notification_examples_footer"
    case documentDeadline3Days = "document_deadline_3_days"
    case interviewReminder1Day = "interview_reminder_1_day"
    case weeklyProgressReport = "weekly_progress_report"
    case newStepGuide = "new_step_guide"
    case templateExample = "template_example"
    case importantNotes = "important_notes"
    case accurateTranslationImportant = "accurate_translation_important"
    case notarizationMayBeRequired = "notarization_may_be_required"
    case professionalTranslationRecommended = "professional_translation_recommended"
    case translatorSignatureRequired = "translator_signature_required"
    case findProfessional = "find_professional"
    case findTranslationExpert = "find_translation_expert"
    
    // NotificationManagerView用
    case noReminders = "no_reminders"
    case noMatchingReminders = "no_matching_reminders"
    case notificationDeadlineManagement = "notification_deadline_management"
    case add = "add"
    case reminderDetail = "reminder_detail"
    case addCalendar = "add_calendar"
    case notificationsEnabled = "notifications_enabled"
    case reminderNotifications = "reminder_notifications"
    case progressNotifications = "progress_notifications"
    case dailyReminders = "daily_reminders"
    case weeklyReports = "weekly_reports"
    case consultation = "consultation"
    case documentPreparation = "document_preparation"
    case application = "application"
    case interview = "interview"
    
    // DiagnosisView用
    case diagnosisQ1 = "diagnosis_q1"
    case diagnosisQ2 = "diagnosis_q2"
    case diagnosisQ3 = "diagnosis_q3"
    case diagnosisQ4 = "diagnosis_q4"
    case diagnosisQ5 = "diagnosis_q5"
    case diagnosisQ6 = "diagnosis_q6"
    case diagnosisQ7 = "diagnosis_q7"
    case diagnosisQ8 = "diagnosis_q8"
    case diagnosisQ9 = "diagnosis_q9"
    case diagnosisQ10 = "diagnosis_q10"
    case diagnosisStep1Title = "diagnosis_step1_title"
    case diagnosisStep1Desc = "diagnosis_step1_desc"
    case diagnosisStep2Title = "diagnosis_step2_title"
    case diagnosisStep2Desc = "diagnosis_step2_desc"
    case diagnosisStep3Title = "diagnosis_step3_title"
    case diagnosisStep3Desc = "diagnosis_step3_desc"
    case diagnosisStep4Title = "diagnosis_step4_title"
    case diagnosisStep4Desc = "diagnosis_step4_desc"
    case diagnosisStepNG1Title = "diagnosis_step_ng1_title"
    case diagnosisStepNG1Desc = "diagnosis_step_ng1_desc"
    case diagnosisStepNG2Title = "diagnosis_step_ng2_title"
    case diagnosisStepNG2Desc = "diagnosis_step_ng2_desc"
    case diagnosisStepNG3Title = "diagnosis_step_ng3_title"
    case diagnosisStepNG3Desc = "diagnosis_step_ng3_desc"
    
    // LegalOfficeSearchView用
    case searchLegalOffice = "search_legal_office"
    case address = "address"
    case phoneNumber = "phone_number"
    case fax = "fax"
    case email = "email"
    case website = "website"
    case businessHours = "business_hours"
    case consultationDays = "consultation_days"
    case callOffice = "call_office"
    case openInMaps = "open_in_maps"
    
    // SettingsView/ProfileEditorView用
    case profileNotSet = "profile_not_set"
    case nationalityNotSet = "nationality_not_set"
    case diagnosisCount = "diagnosis_count"
    case savedDocumentsCount = "saved_documents_count"
    case remindersCount = "reminders_count"
    case notesCount = "notes_count"
    case completedStepsCount = "completed_steps_count"
    case rate = "rate"
    case deleteAllDataMessage = "delete_all_data_message"
    case name = "name"
    case nationality = "nationality"
    case birthDate = "birth_date"
    case residenceQualification = "residence_qualification"
    case yearsInJapan = "years_in_japan"
    case years = "years"
    case occupation = "occupation"
    case emailAddress = "email_address"
    case permanentResident = "permanent_resident"
    case longTermResident = "long_term_resident"
    case spouseOfJapanese = "spouse_of_japanese"
    case spouseOfPermanentResident = "spouse_of_permanent_resident"
    case other = "other"
    
    // NotificationManagerView用
    case all = "all"
    case today = "today"
    case thisWeek = "this_week"
    case thisMonth = "this_month"
    case priority = "priority"
    case category = "category"
    case title = "title"
    case deadlineDateTime = "deadline_date_time"
    case sampleReminder1Title = "sample_reminder1_title"
    case sampleReminder1Desc = "sample_reminder1_desc"
    case sampleReminder2Title = "sample_reminder2_title"
    case sampleReminder2Desc = "sample_reminder2_desc"
    case sampleReminder3Title = "sample_reminder3_title"
    case sampleReminder3Desc = "sample_reminder3_desc"
    case sampleReminder4Title = "sample_reminder4_title"
    case sampleReminder4Desc = "sample_reminder4_desc"
    case sampleReminder5Title = "sample_reminder5_title"
    case sampleReminder5Desc = "sample_reminder5_desc"
    
    // その他の未翻訳箇所
    case noDocumentsFound = "no_documents_found"
    case criminalRecordExplanation = "criminal_record_explanation"
    case daysLater = "days_later"
    case configure = "configure"
    case open = "open"
    case enterTitle = "enter_title"
    case enterDescription = "enter_description"
    case enterName = "enter_name"
    case enterNationality = "enter_nationality"
    case enterOccupation = "enter_occupation"
    case enterEmail = "enter_email"
    case status = "status"
    case incomplete = "incomplete"
    case overdue = "overdue"
    
    // DocumentCategory用
    case personal = "personal"
    case financial = "financial"
    case legal = "legal"
    case medical = "medical"
    case employment = "employment"
    
    // DocumentPriority用
    case low = "low"
    case medium = "medium"
    case high = "high"
    

    case bankStatement = "bank_statement"
    
    // 法務局関連
    case sapporoLegalOffice = "sapporo_legal_office"
    case hakodateLegalOffice = "hakodate_legal_office"
    case asahikawaLegalOffice = "asahikawa_legal_office"
    case aomoriLegalOffice = "aomori_legal_office"
    case moriokaLegalOffice = "morioka_legal_office"
    case sendaiLegalOffice = "sendai_legal_office"
    case akitaLegalOffice = "akita_legal_office"
    case yamagataLegalOffice = "yamagata_legal_office"
    case fukushimaLegalOffice = "fukushima_legal_office"
    case tokyoLegalOffice = "tokyo_legal_office"
    case tokyoShinjukuOffice = "tokyo_shinjuku_office"
    case tokyoTachikawaOffice = "tokyo_tachikawa_office"
    case yokohamaLegalOffice = "yokohama_legal_office"
    case kawasakiLegalOffice = "kawasaki_legal_office"
    case saitamaLegalOffice = "saitama_legal_office"
    
    // 都道府県名
    case hokkaido = "hokkaido"
    case aomori = "aomori"
    case iwate = "iwate"
    case miyagi = "miyagi"
    case akita = "akita"
    case yamagata = "yamagata"
    case fukushima = "fukushima"
    case tokyo = "tokyo"
    case kanagawa = "kanagawa"
    case saitama = "saitama"
    
    // 法務局サービス
    case naturalizationConsultation = "naturalization_consultation"
    case nationalityConsultation = "nationality_consultation"
    case familyRegisterConsultation = "family_register_consultation"
    case registrationConsultation = "registration_consultation"
    
    // InterviewPreparationView用
    case motivationReason = "motivation_reason"
    case lifeWork = "life_work"
    case familyRelatives = "family_relatives"
    case japaneseAbility = "japanese_ability"
    case pause = "pause"
    case listenWithAudio = "listen_with_audio"
    case hideAnswer = "hide_answer"
    case showAnswer = "show_answer"
    case interviewPractice = "interview_practice"
    case interviewQ1 = "interview_q1"
    case interviewA1 = "interview_a1"
    case interviewTip1 = "interview_tip1"
    case interviewQ2 = "interview_q2"
    case interviewA2 = "interview_a2"
    case interviewTip2 = "interview_tip2"
    case interviewQ3 = "interview_q3"
    case interviewA3 = "interview_a3"
    case interviewTip3 = "interview_tip3"
    case interviewQ4 = "interview_q4"
    case interviewA4 = "interview_a4"
    case interviewTip4 = "interview_tip4"
    case interviewQ5 = "interview_q5"
    case interviewA5 = "interview_a5"
    case interviewTip5 = "interview_tip5"
    case interviewQ6 = "interview_q6"
    case interviewA6 = "interview_a6"
    case interviewTip6 = "interview_tip6"
    case interviewQ7 = "interview_q7"
    case interviewA7 = "interview_a7"
    case interviewTip7 = "interview_tip7"
    case interviewQ8 = "interview_q8"
    case interviewA8 = "interview_a8"
    case interviewTip8 = "interview_tip8"
    case interviewQ9 = "interview_q9"
    case interviewA9 = "interview_a9"
    case interviewTip9 = "interview_tip9"
    case interviewQ10 = "interview_q10"
    case interviewA10 = "interview_a10"
    case interviewTip10 = "interview_tip10"
    case interviewQ11 = "interview_q11"
    case interviewA11 = "interview_a11"
    case interviewTip11 = "interview_tip11"
    case interviewQ12 = "interview_q12"
    case interviewA12 = "interview_a12"
    case interviewTip12 = "interview_tip12"
    case interviewQ13 = "interview_q13"
    case interviewA13 = "interview_a13"
    case interviewTip13 = "interview_tip13"
    case interviewQ14 = "interview_q14"
    case interviewA14 = "interview_a14"
    case interviewTip14 = "interview_tip14"
    case interviewQ15 = "interview_q15"
    case interviewA15 = "interview_a15"
    case interviewTip15 = "interview_tip15"
    case interviewQ16 = "interview_q16"
    case interviewA16 = "interview_a16"
    case interviewTip16 = "interview_tip16"
    case interviewQ17 = "interview_q17"
    case interviewA17 = "interview_a17"
    case interviewTip17 = "interview_tip17"
    case interviewQ18 = "interview_q18"
    case interviewA18 = "interview_a18"
    case interviewTip18 = "interview_tip18"
    
    // 日本語音声用
    case interviewQ1Audio = "interview_q1_audio"
    case interviewQ2Audio = "interview_q2_audio"
    case interviewQ3Audio = "interview_q3_audio"
    case interviewQ4Audio = "interview_q4_audio"
    case interviewQ5Audio = "interview_q5_audio"
    case interviewQ6Audio = "interview_q6_audio"
    case interviewQ7Audio = "interview_q7_audio"
    case interviewQ8Audio = "interview_q8_audio"
    case interviewQ9Audio = "interview_q9_audio"
    case interviewQ10Audio = "interview_q10_audio"
    case interviewQ11Audio = "interview_q11_audio"
    case interviewQ12Audio = "interview_q12_audio"
    case interviewQ13Audio = "interview_q13_audio"
    case interviewQ14Audio = "interview_q14_audio"
    case interviewQ15Audio = "interview_q15_audio"
    case interviewQ16Audio = "interview_q16_audio"
    case interviewQ17Audio = "interview_q17_audio"
    case interviewQ18Audio = "interview_q18_audio"
    
    // InterviewPreparationView用
    case japaneseAudio = "japanese_audio"
    case multilingualSubtitles = "multilingual_subtitles"
    
    // DocumentChecklistView用
    case china = "china"
    case vietnam = "vietnam"
    case philippines = "philippines"
    case nepal = "nepal"
    case korea = "korea"
    case worker = "worker"
    case student = "student"
    case technicalIntern = "technical_intern"
    case internationalMarriage = "international_marriage"
    case common = "common"
    case passport = "passport"
    case passportDesc = "passport_desc"
    case passportWhereToGet = "passport_where_to_get"
    case passportExample = "passport_example"
    case passportNotes = "passport_notes"
    case birthCertificate = "birth_certificate"
    case birthCertificateDesc = "birth_certificate_desc"
    case birthCertificateWhereToGet = "birth_certificate_where_to_get"
    case birthCertificateExample = "birth_certificate_example"
    case birthCertificateNotes = "birth_certificate_notes"
    case nationalityCertificate = "nationality_certificate"
    case nationalityCertificateDesc = "nationality_certificate_desc"
    case nationalityCertificateWhereToGet = "nationality_certificate_where_to_get"
    case nationalityCertificateExample = "nationality_certificate_example"
    case nationalityCertificateNotes = "nationality_certificate_notes"
    case residenceCard = "residence_card"
    case residenceCardDesc = "residence_card_desc"
    case residenceCardWhereToGet = "residence_card_where_to_get"
    case residenceCardExample = "residence_card_example"
    case residenceCardNotes = "residence_card_notes"
    case employmentCertificate = "employment_certificate"
    case employmentCertificateDesc = "employment_certificate_desc"
    case employmentCertificateWhereToGet = "employment_certificate_where_to_get"
    case employmentCertificateExample = "employment_certificate_example"
    case employmentCertificateNotes = "employment_certificate_notes"
    case incomeCertificate = "income_certificate"
    case incomeCertificateDesc = "income_certificate_desc"
    case incomeCertificateWhereToGet = "income_certificate_where_to_get"
    case incomeCertificateExample = "income_certificate_example"
    case incomeCertificateNotes = "income_certificate_notes"
    case taxCertificate = "tax_certificate"
    case taxCertificateDesc = "tax_certificate_desc"
    case taxCertificateWhereToGet = "tax_certificate_where_to_get"
    case taxCertificateExample = "tax_certificate_example"
    case taxCertificateNotes = "tax_certificate_notes"
    case marriageCertificate = "marriage_certificate"
    case marriageCertificateDesc = "marriage_certificate_desc"
    case marriageCertificateWhereToGet = "marriage_certificate_where_to_get"
    case marriageCertificateExample = "marriage_certificate_example"
    case marriageCertificateNotes = "marriage_certificate_notes"
    case familyRegister = "family_register"
    case familyRegisterDesc = "family_register_desc"
    case familyRegisterWhereToGet = "family_register_where_to_get"
    case familyRegisterExample = "family_register_example"
    case familyRegisterNotes = "family_register_notes"
    case graduationCertificate = "graduation_certificate"
    case graduationCertificateDesc = "graduation_certificate_desc"
    case graduationCertificateWhereToGet = "graduation_certificate_where_to_get"
    case graduationCertificateExample = "graduation_certificate_example"
    case graduationCertificateNotes = "graduation_certificate_notes"
    
    // TranslationSupportView用
    case faqQ1 = "faq_q1"
    case faqA1 = "faq_a1"
    case faqQ2 = "faq_q2"
    case faqA2 = "faq_a2"
    case faqQ3 = "faq_q3"
    case faqA3 = "faq_a3"
    
    func localizedString(for language: LocalizationManager.Language) -> String {
        return LocalizationData.strings[language]?[self.rawValue] ?? self.rawValue
    }
}

struct LocalizationData {
    static let strings: [LocalizationManager.Language: [String: String]] = [
        .japanese: [
            "app_name": "KIKA+",
            "app_subtitle": "帰化申請サポートアプリ",
            "language_selection": "言語選択",
            "settings": "設定",
            "cancel": "キャンセル",
            "save": "保存",
            "delete": "削除",
            "edit": "編集",
            "close": "閉じる",
            "next": "次へ",
            "back": "戻る",
            "done": "完了",
            "loading": "読み込み中...",
            "error": "エラー",
            "success": "成功",
            "yes": "はい",
            "no": "いいえ",
            
            // メインメニュー
            "diagnosis_check": "適性診断",
            "diagnosis_subtitle": "帰化申請の適性をチェック",
            "step_guide": "ステップガイド",
            "step_guide_subtitle": "申請手順の詳細ガイド",
            "document_checklist": "書類チェックリスト",
            "document_checklist_subtitle": "必要な書類の確認",
            "translation_support": "翻訳サポート",
            "translation_support_subtitle": "書類の翻訳支援",
            "legal_office_search": "法務局検索",
            "legal_office_search_subtitle": "最寄りの法務局を検索",
            "interview_preparation": "面接準備",
            "interview_preparation_subtitle": "面接の準備と練習",
            "notification_management": "通知管理",
            "notification_management_subtitle": "期限や予定の管理",
            
            // 診断関連
            "diagnosis_title": "帰化申請適性診断",
            "question": "質問",
            "eligible": "申請可能",
            "possible_eligibility": "申請可能性あり",
            "insufficient_eligibility": "申請条件不十分",
            "result": "結果",
            "eligibility_score": "適性スコア",
            "detailed_result": "詳細結果",
            "next_steps": "次のステップ",
            
            // 書類チェックリスト
            "document_checklist_title": "書類チェックリスト",
            "document_detail_title": "書類詳細",
            "where_to_get": "取得方法",
            "examples": "例",
            "notes": "注意事項",
            "corresponding_country_status": "対応国・在留資格",
            "corresponding_country": "対応国",
            "corresponding_status": "在留資格",
            "select_country": "国を選択",
            "select_status": "在留資格を選択",
            "necessary_document_progress": "必要書類進捗",
            "completed": "完了",
            
            // ステップガイド
            "step_guide_title": "ステップガイド",
            "estimated_time": "推定時間",
            "required_documents": "必要書類",
            "tips": "コツ",
            
            // その他
            "progress_status": "進捗状況",
            "step_completed": "ステップ完了",
            "detailed_steps": "詳細ステップ",
            "filter": "フィルター",
            "add_reminder": "リマインダー追加",
            "expired": "期限切れ",
            "days_remaining": "残り日数",
            "basic_info": "基本情報",
            "deadline": "期限",
            "description": "説明",
            "reset_notification": "通知リセット",
            "add_to_calendar": "カレンダーに追加",
            "prefecture": "都道府県",
            "no_legal_office_found": "法務局が見つかりません",
            "try_different_search": "別の条件で検索してください",
            "consultation_date": "相談日",
            "call_phone": "電話をかける",
            "open_website": "ウェブサイトを開く",
            "open_in_map": "地図で開く",
            "question_category": "質問カテゴリー",
            "no_questions_found": "質問が見つかりません",
            "sample_answer": "サンプル回答",
            "tips_and_notes": "コツと注意事項",
            "voice_practice": "音声練習",
            "add_note": "メモ追加",
            "profile": "プロフィール",
            "app_settings": "アプリ設定",
            "language_settings": "言語設定",
            "notification_settings": "通知設定",
            "data_management": "データ管理",
            "export_data": "データエクスポート",
            "import_data": "データインポート",
            "delete_all_data": "全データ削除",
            "statistics": "統計",
            "app_info": "アプリ情報",
            "version": "バージョン",
            "help_support": "ヘルプ・サポート",
            "rate_app": "アプリを評価",
            "delete_data_warning": "データ削除の警告",
            "residence_status": "在留資格",
            "occupation_contact": "職業・連絡先",
            "reminder_time": "リマインダー時間",
            "notification_examples": "通知例",
            "notification_examples_footer": "通知例の説明",
            "document_deadline_3_days": "書類期限3日前",
            "interview_reminder_1_day": "面接前日リマインダー",
            "weekly_progress_report": "週次進捗レポート",
            "new_step_guide": "新しいステップガイド",
            "template_example": "テンプレート例",
            "important_notes": "重要な注意事項",
            "accurate_translation_important": "正確な翻訳が重要",
            "notarization_may_be_required": "公証が必要な場合があります",
            "professional_translation_recommended": "専門翻訳を推奨",
            "translator_signature_required": "翻訳者署名が必要",
            "find_professional": "専門家を探す",
            "find_translation_expert": "翻訳専門家を探す",
            
            // 翻訳サポート
            "translation_support_title": "翻訳サポート",
            "select_language": "言語選択",
            "select_document": "書類選択",
            "original_text": "原文",
            "show_template": "テンプレート表示",
            "translate": "翻訳",
            "faq": "よくある質問",
            
            // 通知管理
            "no_reminders": "リマインダーがありません",
            "no_matching_reminders": "該当するリマインダーがありません",
            "notification_deadline_management": "通知・期限管理",
            "add": "追加",
            "reminder_detail": "リマインダー詳細",
            "add_calendar": "カレンダーに追加",
            "consultation": "相談",
            "document_preparation": "書類準備",
            "application": "申請",
            "interview": "面接",
            
            // 診断質問
            "diagnosis_q1": "日本に5年以上継続して住んでいますか？",
            "diagnosis_q2": "20歳以上で、本国法によっても成年の能力を有していますか？",
            "diagnosis_q3": "素行が善良ですか？",
            "diagnosis_q4": "自己又は生計を一にする配偶者その他の親族の資産又は技能によって生計を営むことができるか？",
            "diagnosis_q5": "国籍を有せず、又は日本の国籍の取得によってその国籍を失うべきですか？",
            "diagnosis_q6": "日本国憲法施行の日以後において、日本国憲法又はその下に成立した政府を暴力で破壊することを企て、若しくは主張し、又はこれを企て、若しくは主張する政党その他の団体を結成し、若しくはこれに加入したことがありますか？",
            "diagnosis_q7": "現在、日本に在留していますか？",
            "diagnosis_q8": "帰化申請に必要な書類を準備できますか？",
            "diagnosis_q9": "日本語の読み書きができますか？",
            "diagnosis_q10": "帰化申請の手続きを理解していますか？",
            
            // 法務局検索
            "search_legal_office": "法務局検索",
            "address": "住所",
            "phone_number": "電話番号",
            "fax": "FAX",
            "email": "メールアドレス",
            "website": "ウェブサイト",
            "business_hours": "営業時間",
            "consultation_days": "相談日",
            "call_office": "法務局に電話",
            "open_in_maps": "地図で開く",
            
            // 設定・プロフィール
            "profile_not_set": "プロフィール未設定",
            "nationality_not_set": "国籍未設定",
            "diagnosis_count": "診断回数",
            "saved_documents_count": "保存書類数",
            "reminders_count": "リマインダー数",
            "notes_count": "メモ数",
            "completed_steps_count": "完了ステップ数",
            "rate": "評価",
            "delete_all_data_message": "全データを削除しますか？この操作は取り消せません。",
            "name": "名前",
            "nationality": "国籍",
            "birth_date": "生年月日",
            "residence_qualification": "在留資格",
            "years_in_japan": "在日期間",
            "years": "年",
            "occupation": "職業",
            "email_address": "メールアドレス",
            "permanent_resident": "永住者",
            "long_term_resident": "定住者",
            
            // 難易度用
            "easy": "初級",
            "medium": "中級",
            "hard": "上級",
            
            // ステータス用
            "scheduled": "予約済み",
            "cancelled": "キャンセル",
            "rescheduled": "再予約",
            "not_started": "未着手",
            "in_progress": "準備中",
            "submitted": "提出済み",
            "rejected": "却下",
            
            // 書類タイプ用
            "birth_certificate": "出生証明書",
            "marriage_certificate": "結婚証明書",
            "divorce_certificate": "離婚証明書",
            "passport": "パスポート",
            "residence_card": "在留カード",
            "tax_certificate": "納税証明書",
            "employment_certificate": "在職証明書",
            "bank_statement": "預金残高証明書",
            
            // 法務局関連
            "sapporo_legal_office": "札幌法務局",
            "hakodate_legal_office": "函館地方法務局",
            "asahikawa_legal_office": "旭川地方法務局",
            "aomori_legal_office": "青森地方法務局",
            "morioka_legal_office": "盛岡地方法務局",
            "sendai_legal_office": "仙台法務局",
            "akita_legal_office": "秋田地方法務局",
            "yamagata_legal_office": "山形地方法務局",
            "fukushima_legal_office": "福島地方法務局",
            "tokyo_legal_office": "東京法務局",
            "tokyo_shinjuku_office": "東京法務局新宿出張所",
            "tokyo_tachikawa_office": "東京法務局立川出張所",
            "yokohama_legal_office": "横浜地方法務局",
            "kawasaki_legal_office": "川崎地方法務局",
            "saitama_legal_office": "さいたま地方法務局",
            
            // 都道府県名
            "hokkaido": "北海道",
            "aomori": "青森県",
            "iwate": "岩手県",
            "miyagi": "宮城県",
            "akita": "秋田県",
            "yamagata": "山形県",
            "fukushima": "福島県",
            "tokyo": "東京都",
            "kanagawa": "神奈川県",
            "saitama": "埼玉県",
            
            // 法務局サービス
            "naturalization_consultation": "帰化相談",
            "nationality_consultation": "国籍相談",
            "family_register_consultation": "戸籍相談",
            "registration_consultation": "登記相談",
            
            "spouse_of_japanese": "日本人の配偶者等",
            "spouse_of_permanent_resident": "永住者の配偶者等",
            "other": "その他",
            
            // 通知管理
            "all": "すべて",
            "today": "今日",
            "this_week": "今週",
            "this_month": "今月",
            "priority": "優先度",
            "category": "カテゴリー",
            "title": "タイトル",
            "deadline_date_time": "期限日時",
            
            // 面接準備
            "motivation_reason": "動機・理由",
            "life_work": "生活・仕事",
            "family_relatives": "家族・親族",
            "japanese_ability": "日本語能力",
            "pause": "一時停止",
            "listen_with_audio": "音声で聞く",
            "hide_answer": "回答を隠す",
            "show_answer": "回答を表示",
            "interview_practice": "面接練習",
            
            // 書類チェックリスト
            "china": "中国",
            "vietnam": "ベトナム",
            "philippines": "フィリピン",
            "nepal": "ネパール",
            "korea": "韓国",
            "worker": "労働者",
            "student": "学生",
            "technical_intern": "技能実習生",
            "international_marriage": "国際結婚",
            "common": "共通",
            "passport_desc": "有効期限が残っているパスポート",
            "passport_where_to_get": "本国の大使館・領事館",
            "passport_example": "パスポートの例",
            "passport_notes": "有効期限が切れている場合は更新が必要",
            "birth_certificate_desc": "本国で発行された出生証明書",
            "birth_certificate_where_to_get": "出生証明書の取得方法",
            "birth_certificate_example": "出生証明書の例",
            "birth_certificate_notes": "出生証明書の注意事項",
            "nationality_certificate": "国籍証明書",
            "nationality_certificate_desc": "本国で発行された国籍証明書",
            "nationality_certificate_where_to_get": "国籍証明書の取得方法",
            "nationality_certificate_example": "国籍証明書の例",
            "nationality_certificate_notes": "国籍証明書の注意事項",
            "residence_card_desc": "在留カードの説明",
            "residence_card_where_to_get": "在留カードの取得方法",
            "residence_card_example": "在留カードの例",
            "residence_card_notes": "在留カードの注意事項",
            "employment_certificate_desc": "雇用証明書の説明",
            "employment_certificate_where_to_get": "雇用証明書の取得方法",
            "employment_certificate_example": "雇用証明書の例",
            "employment_certificate_notes": "雇用証明書の注意事項",
            "income_certificate": "所得証明書",
            "income_certificate_desc": "所得証明書の説明",
            "income_certificate_where_to_get": "所得証明書の取得方法",
            "income_certificate_example": "所得証明書の例",
            "income_certificate_notes": "所得証明書の注意事項",
            "tax_certificate_desc": "納税証明書の説明",
            "tax_certificate_where_to_get": "納税証明書の取得方法",
            "tax_certificate_example": "納税証明書の例",
            "tax_certificate_notes": "納税証明書の注意事項",
            "marriage_certificate_desc": "婚姻証明書の説明",
            "marriage_certificate_where_to_get": "婚姻証明書の取得方法",
            "marriage_certificate_example": "婚姻証明書の例",
            "marriage_certificate_notes": "婚姻証明書の注意事項",
            "family_register": "家族登録証明書",
            "family_register_desc": "家族登録証明書の説明",
            "family_register_where_to_get": "家族登録証明書の取得方法",
            "family_register_example": "家族登録証明書の例",
            "family_register_notes": "家族登録証明書の注意事項",
            "graduation_certificate": "卒業証明書",
            "graduation_certificate_desc": "卒業証明書の説明",
            "graduation_certificate_where_to_get": "卒業証明書の取得方法",
            "graduation_certificate_example": "卒業証明書の例",
            "graduation_certificate_notes": "卒業証明書の注意事項",
            
            // FAQ
            "faq_q1": "翻訳は必要ですか？",
            "faq_a1": "はい、外国語で書かれた書類は日本語翻訳が必要です。",
            "faq_q2": "翻訳者の署名は必要ですか？",
            "faq_a2": "はい、翻訳者による署名と印鑑が必要です。",
            "faq_q3": "公証は必要ですか？",
            "faq_a3": "場合によっては公証が必要になることがあります。",
            
            // 面接関連（日本語音声用）
            "interview_q1_audio": "お名前を教えてください。",
            "interview_q2_audio": "お生まれはどちらですか？",
            "interview_q3_audio": "いつ日本に来ましたか？",
            "interview_q4_audio": "なぜ帰化を希望するのですか？",
            "interview_q5_audio": "日本が好きな理由は何ですか？",
            "interview_q6_audio": "帰化後も日本に住み続けますか？",
            "interview_q7_audio": "現在の職業は何ですか？",
            "interview_q8_audio": "仕事は順調ですか？",
            "interview_q9_audio": "収入は安定していますか？",
            "interview_q10_audio": "家族は何人ですか？",
            "interview_q11_audio": "家族は日本に住んでいますか？",
            "interview_q12_audio": "家族との関係は良好ですか？",
            "interview_q13_audio": "日本語はどの程度できますか？",
            "interview_q14_audio": "日本語の勉強は続けていますか？",
            "interview_q15_audio": "日本の法律は理解していますか？",
            "interview_q16_audio": "税金はきちんと払っていますか？",
            "interview_q17_audio": "犯罪歴はありますか？",
            "interview_q18_audio": "他に質問はありますか？",
            
            // 面接関連
            "interview_q1": "お名前を教えてください。",
            "interview_a1": "私の名前は[名前]です。",
            "interview_tip1": "はっきりと、ゆっくりと話してください。",
            "interview_q2": "お生まれはどちらですか？",
            "interview_a2": "私は[国名]で生まれました。",
            "interview_tip2": "出身地を正確に伝えてください。",
            "interview_q3": "いつ日本に来ましたか？",
            "interview_a3": "私は[年]に日本に来ました。",
            

            
            // DocumentCategory用
            "personal": "個人情報",
            "financial": "財務書類",
            "legal": "法的書類",
            "medical": "医療書類",
            "employment": "雇用関連",
            
            // DocumentPriority用
            "low": "低",
            "high": "高",
            

            

            

            

            
            "interview_tip3": "来日した年を正確に覚えておいてください。",
            "interview_q4": "なぜ帰化を希望するのですか？",
            "interview_a4": "日本で永続的に生活したいからです。",
            "interview_tip4": "自分の言葉で理由を説明してください。",
            "interview_q5": "日本が好きな理由は何ですか？",
            "interview_a5": "日本の文化と人々が好きだからです。",
            "interview_tip5": "具体的な理由を挙げてください。",
            "interview_q6": "帰化後も日本に住み続けますか？",
            "interview_a6": "はい、日本に住み続けます。",
            "interview_tip6": "確実に日本に住み続ける意思を示してください。",
            "interview_q7": "現在の職業は何ですか？",
            "interview_a7": "私は[職業]です。",
            "interview_tip7": "現在の職業を正確に伝えてください。",
            "interview_q8": "仕事は順調ですか？",
            "interview_a8": "はい、順調です。",
            "interview_tip8": "安定した職業であることを示してください。",
            "interview_q9": "収入は安定していますか？",
            "interview_a9": "はい、安定しています。",
            "interview_tip9": "経済的に安定していることを示してください。",
            "interview_q10": "家族は何人ですか？",
            "interview_a10": "私の家族は[人数]人です。",
            "interview_tip10": "家族構成を正確に伝えてください。",
            "interview_q11": "家族は日本に住んでいますか？",
            "interview_a11": "はい、家族は日本に住んでいます。",
            "interview_tip11": "家族の状況を正確に伝えてください。",
            "interview_q12": "家族との関係は良好ですか？",
            "interview_a12": "はい、良好です。",
            "interview_tip12": "家族との関係が良好であることを示してください。",
            "interview_q13": "日本語はどの程度できますか？",
            "interview_a13": "日常会話は問題ありません。",
            "interview_tip13": "日本語能力を適切に評価してください。",
            "interview_q14": "日本語の勉強は続けていますか？",
            "interview_a14": "はい、継続して勉強しています。",
            "interview_tip14": "日本語学習への意欲を示してください。",
            "interview_q15": "日本の法律は理解していますか？",
            "interview_a15": "基本的な法律は理解しています。",
            "interview_tip15": "日本の法律への理解を示してください。",
            "interview_q16": "税金はきちんと払っていますか？",
            "interview_a16": "はい、きちんと払っています。",
            "interview_tip16": "納税義務を果たしていることを示してください。",
            "interview_q17": "犯罪歴はありますか？",
            "interview_a17": "いいえ、ありません。",
            "interview_tip17": "素行が善良であることを示してください。",
            "interview_q18": "他に質問はありますか？",
            "interview_a18": "特にありません。",
            "interview_tip18": "簡潔に答えてください。",
            
            // InterviewPreparationView用
            "japanese_audio": "日本語音声",
            "multilingual_subtitles": "多言語テロップ",
            
            // 通知設定
            "notifications_enabled": "通知を有効にする",
            "reminder_notifications": "リマインダー通知",
            "progress_notifications": "進捗通知",
            "daily_reminders": "日次リマインダー",
            "weekly_reports": "週次レポート",
            
            // 翻訳サポート
            "diagnosis_step_ng1_title": "所需文件缺失",
            "diagnosis_step_ng1_desc": "请确保已准备好所有申请所需的文件。",
            "diagnosis_step_ng2_title": "在留期间不足",
            "diagnosis_step_ng2_desc": "申请需要一定的在留期间。请确认是否符合条件。",
            "diagnosis_step_ng3_title": "其他要求未达成",
            "diagnosis_step_ng3_desc": "请再次确认其他申请要求。"
        ],
        .english: [
            "app_name": "KIKA+",
            "app_subtitle": "Naturalization Application Support App",
            "language_selection": "Language Selection",
            "settings": "Settings",
            "cancel": "Cancel",
            "save": "Save",
            "delete": "Delete",
            "edit": "Edit",
            "close": "Close",
            "next": "Next",
            "back": "Back",
            "done": "Done",
            "loading": "Loading...",
            "error": "Error",
            "success": "Success",
            "yes": "Yes",
            "no": "No",
            "name": "Name",
            "nationality": "Nationality",
            "birth_date": "Birth Date",
            
            // Main Menu
            "diagnosis_check": "Eligibility Check",
            "diagnosis_subtitle": "Check naturalization eligibility",
            "step_guide": "Step Guide",
            "step_guide_subtitle": "Detailed application process guide",
            "document_checklist": "Document Checklist",
            "document_checklist_subtitle": "Check required documents",
            "translation_support": "Translation Support",
            "translation_support_subtitle": "Document translation assistance",
            "legal_office_search": "Legal Office Search",
            "legal_office_search_subtitle": "Search for nearest legal office",
            "interview_preparation": "Interview Preparation",
            "interview_preparation_subtitle": "Prepare and practice for interviews",
            "notification_management": "Notification Management",
            "notification_management_subtitle": "Manage deadlines and schedules",
            
            // Diagnosis questions
            "diagnosis_q1": "Have you lived in Japan continuously for more than 5 years?",
            "diagnosis_q2": "Are you 20 years or older and have the capacity to be an adult under your home country's law?",
            "diagnosis_q3": "Are you of good conduct?",
            "diagnosis_q4": "Can you make a living from your own assets or skills, or those of your spouse or other relatives who share your livelihood?",
            "diagnosis_q5": "Do you have no nationality, or should you lose your nationality by acquiring Japanese nationality?",
            "diagnosis_q6": "After the enforcement date of the Japanese Constitution, have you ever planned, advocated, organized, or joined a political party or other organization that planned or advocated the destruction of the Japanese Constitution or the government established under it by force?",
            "diagnosis_q7": "Are you currently residing in Japan?",
            "diagnosis_q8": "Can you prepare the documents required for naturalization application?",
            "diagnosis_q9": "Can you read and write Japanese?",
            "diagnosis_q10": "Do you understand the naturalization application procedure?",
            
            // Common UI elements
            "question": "Question",
            "diagnosis_title": "Naturalization Eligibility Diagnosis",
            "eligible": "Eligible",
            "possible_eligibility": "Possibly Eligible",
            "insufficient_eligibility": "Insufficient Eligibility",
            "result": "Result",
            "eligibility_score": "Eligibility Score",
            "detailed_result": "Detailed Result",
            "next_steps": "Next Steps",
            
            // Interview questions
            "interview_q1": "What is your name?",
            "interview_a1": "My name is [Name].",
            "interview_tip1": "Speak clearly and slowly.",
            "interview_q2": "Where were you born?",
            "interview_a2": "I was born in [Country].",
            "interview_tip2": "Tell your birthplace accurately.",
            "interview_q3": "When did you come to Japan?",
            "interview_a3": "I came to Japan in [Year].",
            "interview_tip3": "Remember the year you came to Japan accurately.",
            "interview_q4": "Why do you want to naturalize?",
            "interview_a4": "Because I want to live permanently in Japan.",
            "interview_tip4": "Explain the reason in your own words.",
            "interview_q5": "What do you like about Japan?",
            "interview_a5": "I like Japanese culture and people.",
            "interview_tip5": "Give specific reasons.",
            "interview_q6": "Will you continue to live in Japan after naturalization?",
            "interview_a6": "Yes, I will continue to live in Japan.",
            "interview_tip6": "Show your intention to continue living in Japan.",
            "interview_q7": "What is your current occupation?",
            "interview_a7": "I am a [Occupation].",
            "interview_tip7": "Tell your current occupation accurately.",
            "interview_q8": "Is your work going well?",
            "interview_a8": "Yes, it's going well.",
            "interview_tip8": "Show that you have a stable occupation.",
            "interview_q9": "Is your income stable?",
            "interview_a9": "Yes, it's stable.",
            "interview_tip9": "Show that you are economically stable.",
            "interview_q10": "How many family members do you have?",
            "interview_a10": "I have [Number] family members.",
            "interview_tip10": "Tell your family composition accurately.",
            "interview_q11": "Do your family members live in Japan?",
            "interview_a11": "Yes, my family lives in Japan.",
            "interview_tip11": "Tell your family situation accurately.",
            "interview_q12": "Do you have a good relationship with your family?",
            "interview_a12": "Yes, it's good.",
            "interview_tip12": "Show that you have a good relationship with your family.",
            "interview_q13": "How well can you speak Japanese?",
            "interview_a13": "I can handle daily conversation without problems.",
            "interview_tip13": "Evaluate your Japanese ability appropriately.",
            "interview_q14": "Are you continuing to study Japanese?",
            "interview_a14": "Yes, I continue to study.",
            "interview_tip14": "Show your motivation for learning Japanese.",
            "interview_q15": "Do you understand Japanese laws?",
            "interview_a15": "I understand basic laws.",
            "interview_tip15": "Show your understanding of Japanese laws.",
            "interview_q16": "Do you pay taxes properly?",
            "interview_a16": "Yes, I pay them properly.",
            "interview_tip16": "Show that you fulfill your tax obligations.",
            "interview_q17": "Do you have any criminal record?",
            "interview_a17": "No, I don't.",
            "interview_tip17": "Show that you are of good conduct.",
            "interview_q18": "Do you have any other questions?",
            "interview_a18": "Not particularly.",
            "interview_tip18": "Answer concisely.",
            
            // Translation Support
            "translation_support_title": "Translation Support",
            "select_language": "Select Language",
            "select_document": "Select Document",
            "original_text": "Original Text",
            "show_template": "Show Template",
            "translate": "Translate",
            "faq": "FAQ",
            "faq_q1": "Is translation required?",
            "faq_q2": "Is notarization required?",
            "faq_q3": "Should I request professional translation?",
            
            // InterviewPreparationView用
            "japanese_audio": "Japanese Audio",
            "multilingual_subtitles": "Multilingual Subtitles",
            "listen_with_audio": "Listen with Audio",
            
            // その他の未翻訳箇所
            "no_documents_found": "No documents found",
            "try_different_search": "Try different search criteria",
            "criminal_record_explanation": "No criminal record, paying taxes, no traffic violations, etc.",
            "expired": "Expired",
            "days_later": "%d days later",
            "configure": "Configure",
            "open": "Open",
            "enter_title": "Enter title",
            "enter_description": "Enter description (optional)",
            "enter_name": "Enter name",
            "enter_nationality": "Enter nationality",
            "enter_occupation": "Enter occupation",
            "enter_email": "Enter email address",
            "status": "Status",
            "incomplete": "Incomplete",
            "overdue": "Overdue",
            
            // DocumentCategory用
            "personal": "Personal Information",
            "financial": "Financial Documents",
            "legal": "Legal Documents",
            "medical": "Medical Documents",
            "employment": "Employment Related",
            
            // DocumentPriority用
            "low": "Low",
            "medium": "Medium",
            "high": "High",
            
            // フィルター用
            "all": "All",
            "today": "Today",
            "this_week": "This Week",
            "this_month": "This Month",
            
            // カテゴリー用
            "consultation": "Consultation",
            "document_preparation": "Document Preparation",
            "application": "Application",
            "interview": "Interview",
            
            // 国名用
            "china": "China",
            "vietnam": "Vietnam",
            "philippines": "Philippines",
            "nepal": "Nepal",
            "korea": "Korea",
            "common": "Common",
            
            // 在留資格用
            "worker": "Worker",
            "student": "Student",
            "technical_intern": "Technical Intern",
            "international_marriage": "International Marriage",
            "permanent_resident": "Permanent Resident",
            
            // 法務局関連
            "sapporo_legal_office": "Sapporo Legal Affairs Bureau",
            "hakodate_legal_office": "Hakodate District Legal Affairs Bureau",
            "asahikawa_legal_office": "Asahikawa District Legal Affairs Bureau",
            "aomori_legal_office": "Aomori District Legal Affairs Bureau",
            "morioka_legal_office": "Morioka District Legal Affairs Bureau",
            "sendai_legal_office": "Sendai Legal Affairs Bureau",
            "akita_legal_office": "Akita District Legal Affairs Bureau",
            "yamagata_legal_office": "Yamagata District Legal Affairs Bureau",
            "fukushima_legal_office": "Fukushima District Legal Affairs Bureau",
            "tokyo_legal_office": "Tokyo Legal Affairs Bureau",
            "tokyo_shinjuku_office": "Tokyo Legal Affairs Bureau Shinjuku Branch",
            "tokyo_tachikawa_office": "Tokyo Legal Affairs Bureau Tachikawa Branch",
            "yokohama_legal_office": "Yokohama District Legal Affairs Bureau",
            "kawasaki_legal_office": "Kawasaki District Legal Affairs Bureau",
            "saitama_legal_office": "Saitama District Legal Affairs Bureau",
            
            // 都道府県名
            "hokkaido": "Hokkaido",
            "aomori": "Aomori Prefecture",
            "iwate": "Iwate Prefecture",
            "miyagi": "Miyagi Prefecture",
            "akita": "Akita Prefecture",
            "yamagata": "Yamagata Prefecture",
            "fukushima": "Fukushima Prefecture",
            "tokyo": "Tokyo",
            "kanagawa": "Kanagawa Prefecture",
            "saitama": "Saitama Prefecture",
            
            // 法務局サービス
            "naturalization_consultation": "Naturalization Consultation",
            "nationality_consultation": "Nationality Consultation",
            "family_register_consultation": "Family Register Consultation",
            "registration_consultation": "Registration Consultation"
        ],
        .chineseSimplified: [
            "app_name": "KIKA+",
            "app_subtitle": "归化申请支持应用",
            "language_selection": "语言选择",
            "settings": "设置",
            "cancel": "取消",
            "save": "保存",
            "delete": "删除",
            "edit": "编辑",
            "close": "关闭",
            "next": "下一步",
            "back": "返回",
            "done": "完成",
            "loading": "加载中...",
            "error": "错误",
            "success": "成功",
            "yes": "是",
            "no": "否",
            "name": "姓名",
            "nationality": "国籍",
            "birth_date": "出生日期",
            
            // Main Menu
            "diagnosis_check": "资格检查",
            "diagnosis_subtitle": "检查归化申请资格",
            "step_guide": "步骤指南",
            "step_guide_subtitle": "详细申请流程指南",
            "document_checklist": "文件清单",
            "document_checklist_subtitle": "检查所需文件",
            "translation_support": "翻译支持",
            "translation_support_subtitle": "文件翻译协助",
            "legal_office_search": "法务局搜索",
            "legal_office_search_subtitle": "搜索最近的法务局",
            "interview_preparation": "面试准备",
            "interview_preparation_subtitle": "准备和练习面试",
            "notification_management": "通知管理",
            "notification_management_subtitle": "管理截止日期和日程",
            
            // Diagnosis questions
            "diagnosis_q1": "您在日本连续居住超过5年了吗？",
            "diagnosis_q2": "您是否20岁以上，并且根据本国法律具有成年能力？",
            "diagnosis_q3": "您的品行是否良好？",
            "diagnosis_q4": "您是否能够依靠自己或共同生活的配偶或其他亲属的资产或技能维持生计？",
            "diagnosis_q5": "您是否没有国籍，或者应该因取得日本国籍而失去原国籍？",
            "diagnosis_q6": "在日本宪法实施日之后，您是否曾经计划、主张、组织或加入计划或主张用暴力破坏日本宪法或在其下成立的政府的政党或其他组织？",
            "diagnosis_q7": "您目前是否在日本居住？",
            "diagnosis_q8": "您是否能够准备归化申请所需的文件？",
            "diagnosis_q9": "您是否能够读写日语？",
            "diagnosis_q10": "您是否理解归化申请程序？",
            
            // Common UI elements
            "question": "问题",
            "diagnosis_title": "归化资格诊断",
            "eligible": "符合资格",
            "possible_eligibility": "可能符合资格",
            "insufficient_eligibility": "资格不足",
            "result": "结果",
            "eligibility_score": "资格评分",
            "detailed_result": "详细结果",
            "next_steps": "下一步",
            
            // Interview questions
            "interview_q1": "请问您的姓名？",
            "interview_a1": "我的名字是[姓名]。",
            "interview_tip1": "请清楚、缓慢地说话。",
            "interview_q2": "您出生在哪里？",
            "interview_a2": "我出生在[国家]。",
            "interview_tip2": "请准确告知出生地。",
            "interview_q3": "您什么时候来到日本？",
            "interview_a3": "我在[年份]来到日本。",
            "interview_tip3": "请准确记住来日本的年份。",
            "interview_q4": "您为什么希望归化？",
            "interview_a4": "因为我想在日本永久生活。",
            "interview_tip4": "请用自己的话说明理由。",
            "interview_q5": "您喜欢日本的什么？",
            "interview_a5": "我喜欢日本的文化和人民。",
            "interview_tip5": "请举出具体的理由。",
            "interview_q6": "归化后您会继续在日本居住吗？",
            "interview_a6": "是的，我会继续在日本居住。",
            "interview_tip6": "请表明继续在日本居住的意愿。",
            "interview_q7": "您现在的职业是什么？",
            "interview_a7": "我是[职业]。",
            "interview_tip7": "请准确告知现在的职业。",
            "interview_q8": "工作顺利吗？",
            "interview_a8": "是的，很顺利。",
            "interview_tip8": "请表明有稳定的职业。",
            "interview_q9": "收入稳定吗？",
            "interview_a9": "是的，很稳定。",
            "interview_tip9": "请表明经济稳定。",
            "interview_q10": "您有几个家庭成员？",
            "interview_a10": "我有[人数]个家庭成员。",
            "interview_tip10": "请准确告知家庭构成。",
            "interview_q11": "您的家人在日本居住吗？",
            "interview_a11": "是的，我的家人在日本居住。",
            "interview_tip11": "请准确告知家庭状况。",
            "interview_q12": "您与家人的关系良好吗？",
            "interview_a12": "是的，很好。",
            "interview_tip12": "请表明与家人关系良好。",
            "interview_q13": "您的日语程度如何？",
            "interview_a13": "日常会话没有问题。",
            "interview_tip13": "请适当评价日语能力。",
            "interview_q14": "您还在继续学习日语吗？",
            "interview_a14": "是的，我继续学习。",
            "interview_tip14": "请表明学习日语的意愿。",
            "interview_q15": "您理解日本的法律吗？",
            "interview_a15": "我理解基本的法律。",
            "interview_tip15": "请表明对日本法律的理解。",
            "interview_q16": "您按时缴纳税金吗？",
            "interview_a16": "是的，我按时缴纳。",
            "interview_tip16": "请表明履行纳税义务。",
            "interview_q17": "您有犯罪记录吗？",
            "interview_a17": "没有。",
            "interview_tip17": "请表明品行善良。",
            "interview_q18": "您还有其他问题吗？",
            "interview_a18": "没有特别的问题。",
            "interview_tip18": "请简洁回答。",
            
            // Translation Support
            "translation_support_title": "翻译支持",
            "select_language": "选择语言",
            "select_document": "选择文件",
            "original_text": "原文",
            "show_template": "显示模板",
            "translate": "翻译",
            "faq": "常见问题",
            "faq_q1": "需要翻译吗？",
            "faq_q2": "需要公证吗？",
            "faq_q3": "应该请求专业翻译吗？",
            
            // InterviewPreparationView用
            "japanese_audio": "日语音频",
            "multilingual_subtitles": "多语言字幕",
            "listen_with_audio": "听音频",
            
            // その他の未翻訳箇所
            "no_documents_found": "未找到相应文件",
            "try_different_search": "请尝试其他搜索条件",
            "criminal_record_explanation": "无犯罪记录、按时纳税、无交通违规等",
            "expired": "已过期",
            "days_later": "%d天后",
            "configure": "配置",
            "open": "打开",
            "enter_title": "输入标题",
            "enter_description": "输入描述（可选）",
            "enter_name": "输入姓名",
            "enter_nationality": "输入国籍",
            "enter_occupation": "输入职业",
            "enter_email": "输入邮箱地址",
            "status": "状态",
            "incomplete": "未完成",
            "overdue": "逾期",
            
            // DocumentCategory用
            "personal": "个人信息",
            "financial": "财务文件",
            "legal": "法律文件",
            "medical": "医疗文件",
            "employment": "就业相关",
            
            // DocumentPriority用
            "low": "低",
            "medium": "中",
            "high": "高",
            
            // フィルター用
            "all": "全部",
            "today": "今天",
            "this_week": "本周",
            "this_month": "本月",
            
            // カテゴリー用
            "consultation": "咨询",
            "document_preparation": "文件准备",
            "application": "申请",
            "interview": "面试",
            
            // 国名用
            "china": "中国",
            "vietnam": "越南",
            "philippines": "菲律宾",
            "nepal": "尼泊尔",
            "korea": "韩国",
            "common": "通用",
            
            // 在留資格用
            "worker": "工作者",
            "student": "学生",
            "technical_intern": "技能实习生",
            "international_marriage": "国际婚姻",
            "permanent_resident": "永久居民",
            
            // 法務局関連
            "sapporo_legal_office": "札幌法务局",
            "hakodate_legal_office": "函馆地方法务局",
            "asahikawa_legal_office": "旭川地方法务局",
            "aomori_legal_office": "青森地方法务局",
            "morioka_legal_office": "盛冈地方法务局",
            "sendai_legal_office": "仙台法务局",
            "akita_legal_office": "秋田地方法务局",
            "yamagata_legal_office": "山形地方法务局",
            "fukushima_legal_office": "福岛地方法务局",
            "tokyo_legal_office": "东京法务局",
            "tokyo_shinjuku_office": "东京法务局新宿分所",
            "tokyo_tachikawa_office": "东京法务局立川分所",
            "yokohama_legal_office": "横滨地方法务局",
            "kawasaki_legal_office": "川崎地方法务局",
            "saitama_legal_office": "埼玉地方法务局",
            
            // 都道府県名
            "hokkaido": "北海道",
            "aomori": "青森县",
            "iwate": "岩手县",
            "miyagi": "宫城县",
            "akita": "秋田县",
            "yamagata": "山形县",
            "fukushima": "福岛县",
            "tokyo": "东京都",
            "kanagawa": "神奈川县",
            "saitama": "埼玉县",
            
            // 法務局サービス
            "naturalization_consultation": "归化咨询",
            "nationality_consultation": "国籍咨询",
            "family_register_consultation": "户籍咨询",
            "registration_consultation": "登记咨询"
        ],
        .chineseTraditional: [
            "app_name": "KIKA+",
            "app_subtitle": "歸化申請支援應用程式",
            "language_selection": "語言選擇",
            "settings": "設定",
            "cancel": "取消",
            "save": "儲存",
            "delete": "刪除",
            "edit": "編輯",
            "close": "關閉",
            "next": "下一步",
            "back": "返回",
            "done": "完成",
            "loading": "載入中...",
            "error": "錯誤",
            "success": "成功",
            "yes": "是",
            "no": "否",
            "name": "姓名",
            "nationality": "國籍",
            "birth_date": "出生日期",
            
            // 主選單
            "diagnosis_check": "資格檢查",
            "diagnosis_subtitle": "檢查歸化申請資格",
            "step_guide": "步驟指南",
            "step_guide_subtitle": "申請程序的詳細指南",
            "document_checklist": "文件檢查清單",
            "document_checklist_subtitle": "檢查必要文件",
            "translation_support": "翻譯支援",
            "translation_support_subtitle": "文件翻譯協助",
            "legal_office_search": "法務局搜尋",
            "legal_office_search_subtitle": "搜尋最近的法務局",
            "interview_preparation": "面試準備",
            "interview_preparation_subtitle": "準備和練習面試",
            "notification_management": "通知管理",
            "notification_management_subtitle": "管理期限和行程",
            
            // 診斷問題
            "diagnosis_q1": "您在日本連續居住超過5年了嗎？",
            "diagnosis_q2": "您是否年滿20歲，並且根據您本國法律具有成年能力？",
            "diagnosis_q3": "您的品行良好嗎？",
            "diagnosis_q4": "您能否依靠自己的資產或技能，或者依靠與您共同生活的配偶或其他親屬的資產或技能維持生計？",
            "diagnosis_q5": "您是否沒有國籍，或者應該在取得日本國籍時失去您的國籍？",
            "diagnosis_q6": "在日本憲法實施日期之後，您是否曾經計劃、主張、組織或加入計劃或主張以暴力破壞日本憲法或在其下建立的政府的政黨或其他組織？",
            "diagnosis_q7": "您目前是否居住在日本？",
            "diagnosis_q8": "您能否準備歸化申請所需的文件？",
            "diagnosis_q9": "您能否讀寫日語？",
            "diagnosis_q10": "您是否了解歸化申請程序？",
            
            // 常見UI元素
            "question": "問題",
            "diagnosis_title": "歸化資格診斷",
            "eligible": "符合資格",
            "possible_eligibility": "可能符合資格",
            "insufficient_eligibility": "資格不足",
            "result": "結果",
            "eligibility_score": "資格分數",
            "detailed_result": "詳細結果",
            "next_steps": "下一步驟",
            
            // 面試問題
            "interview_q1": "您的姓名是什麼？",
            "interview_a1": "我的姓名是[姓名]。",
            "interview_tip1": "請清楚且緩慢地說話。",
            "interview_q2": "您出生在哪裡？",
            "interview_a2": "我出生在[國家]。",
            "interview_tip2": "請準確說出您的出生地。",
            "interview_q3": "您什麼時候來到日本？",
            "interview_a3": "我在[年份]來到日本。",
            "interview_tip3": "請準確記住您來到日本的年份。",
            "interview_q4": "您為什麼想要歸化？",
            "interview_a4": "因為我想要永久居住在日本。",
            "interview_tip4": "請用自己的話解釋原因。",
            "interview_q5": "您喜歡日本的什麼？",
            "interview_a5": "我喜歡日本的文化和人民。",
            "interview_tip5": "請給出具體的理由。",
            "interview_q6": "歸化後您會繼續居住在日本嗎？",
            "interview_a6": "是的，我會繼續居住在日本。",
            "interview_tip6": "請表現出繼續居住日本的意願。",
            "interview_q7": "您目前的職業是什麼？",
            "interview_a7": "我是[職業]。",
            "interview_tip7": "請準確說出您目前的職業。",
            "interview_q8": "您的工作順利嗎？",
            "interview_a8": "是的，很順利。",
            "interview_tip8": "請表現出您有穩定的職業。",
            "interview_q9": "您的收入穩定嗎？",
            "interview_a9": "是的，很穩定。",
            "interview_tip9": "請表現出您在經濟上穩定。",
            "interview_q10": "您有多少家庭成員？",
            "interview_a10": "我有[數量]個家庭成員。",
            "interview_tip10": "請準確說出您的家庭構成。",
            "interview_q11": "您的家庭成員居住在日本嗎？",
            "interview_a11": "是的，我的家庭居住在日本。",
            "interview_tip11": "請準確說出您的家庭情況。",
            "interview_q12": "您與家人的關係良好嗎？",
            "interview_a12": "是的，很好。",
            "interview_tip12": "請表現出您與家人關係良好。",
            
            // Translation Support
            "translation_support_title": "翻譯支援",
            "select_language": "選擇語言",
            "select_document": "選擇文件",
            "original_text": "原文",
            "show_template": "顯示範本",
            "translate": "翻譯",
            "faq": "常見問題",
            "faq_q1": "需要翻譯嗎？",
            "faq_q2": "需要公證嗎？",
            "faq_q3": "應該請求專業翻譯嗎？",
            
            // 文件檢查清單
            "document_checklist_title": "文件檢查清單",
            "document_detail_title": "文件詳細",
            "where_to_get": "取得方法",
            "examples": "範例",
            "notes": "注意事項",
            "corresponding_country_status": "對應國家・居留資格",
            "corresponding_country": "對應國家",
            "corresponding_status": "居留資格",
            "select_country": "選擇國家",
            "select_status": "選擇居留資格",
            "necessary_document_progress": "必要文件進度",
            "completed": "完成",
            
            // 步驟指南
            "step_guide_title": "步驟指南",
            "estimated_time": "預估時間",
            "required_documents": "必要文件",
            "tips": "技巧",
            
            // 其他
            "progress_status": "進度狀況",
            "step_completed": "步驟完成",
            "detailed_steps": "詳細步驟",
            "filter": "篩選",
            "add_reminder": "新增提醒",
            "expired": "已過期",
            "days_remaining": "剩餘天數",
            "basic_info": "基本資訊",
            "deadline": "期限",
            "description": "說明",
            "reset_notification": "重設通知",
            "add_to_calendar": "新增到行事曆",
            "prefecture": "都道府縣",
            "no_legal_office_found": "找不到法務局",
            "try_different_search": "請嘗試其他搜尋條件",
            "consultation_date": "諮詢日期",
            "call_phone": "撥打電話",
            "open_website": "開啟網站",
            "open_in_map": "在地圖中開啟",
            "question_category": "問題類別",
            "no_questions_found": "找不到問題",
            "sample_answer": "範例回答",
            "tips_and_notes": "技巧和注意事項",
            "voice_practice": "語音練習",
            "profile": "個人資料",
            "app_settings": "應用程式設定",
            "language_settings": "語言設定",
            "notification_settings": "通知設定",
            "data_management": "資料管理",
            "export_data": "匯出資料",
            "import_data": "匯入資料",
            "delete_all_data": "刪除所有資料",
            "statistics": "統計",
            "diagnosis_count": "診斷次數",
            "saved_documents_count": "已儲存文件數",
            "profile_not_set": "個人資料未設定",
            "nationality_not_set": "國籍未設定",
            "configure": "設定",
            "no_matching_reminders": "沒有符合的提醒",
            "notification_deadline_management": "通知・期限管理",
            "search_legal_office": "搜尋法務局"
        ],
        .vietnamese: [
            "app_name": "KIKA+",
            "app_subtitle": "Ứng dụng hỗ trợ đăng ký nhập tịch",
            "language_selection": "Chọn ngôn ngữ",
            "settings": "Cài đặt",
            "cancel": "Hủy",
            "save": "Lưu",
            "delete": "Xóa",
            "edit": "Chỉnh sửa",
            "close": "Đóng",
            "next": "Tiếp theo",
            "back": "Quay lại",
            "done": "Hoàn thành",
            "loading": "Đang tải...",
            "error": "Lỗi",
            "success": "Thành công",
            "yes": "Có",
            "no": "Không",
            "name": "Tên",
            "nationality": "Quốc tịch",
            "birth_date": "Ngày sinh",
            
            // Main Menu
            "diagnosis_check": "Kiểm tra đủ điều kiện",
            "diagnosis_subtitle": "Kiểm tra điều kiện đăng ký nhập tịch",
            "step_guide": "Hướng dẫn từng bước",
            "step_guide_subtitle": "Hướng dẫn chi tiết quy trình đăng ký",
            "document_checklist": "Danh sách tài liệu",
            "document_checklist_subtitle": "Kiểm tra tài liệu cần thiết",
            "translation_support": "Hỗ trợ dịch thuật",
            "translation_support_subtitle": "Hỗ trợ dịch tài liệu",
            "legal_office_search": "Tìm kiếm văn phòng pháp lý",
            "legal_office_search_subtitle": "Tìm văn phòng pháp lý gần nhất",
            "interview_preparation": "Chuẩn bị phỏng vấn",
            "interview_preparation_subtitle": "Chuẩn bị và luyện tập phỏng vấn",
            "notification_management": "Quản lý thông báo",
            "notification_management_subtitle": "Quản lý thời hạn và lịch trình",
            
            // Diagnosis questions
            "diagnosis_q1": "Bạn đã sống liên tục ở Nhật Bản hơn 5 năm chưa?",
            "diagnosis_q2": "Bạn có từ 20 tuổi trở lên và có năng lực trưởng thành theo luật nước mình không?",
            "diagnosis_q3": "Bạn có hạnh kiểm tốt không?",
            "diagnosis_q4": "Bạn có thể sinh sống bằng tài sản hoặc kỹ năng của mình, hoặc của vợ/chồng hoặc người thân khác cùng sinh hoạt không?",
            "diagnosis_q5": "Bạn có không có quốc tịch, hoặc sẽ mất quốc tịch khi có được quốc tịch Nhật Bản không?",
            "diagnosis_q6": "Sau ngày Hiến pháp Nhật Bản có hiệu lực, bạn có từng lập kế hoạch, chủ trương, tổ chức hoặc tham gia đảng phái hoặc tổ chức khác lập kế hoạch hoặc chủ trương phá hoại Hiến pháp Nhật Bản hoặc chính phủ được thành lập dưới nó bằng bạo lực không?",
            "diagnosis_q7": "Bạn hiện tại có đang cư trú ở Nhật Bản không?",
            "diagnosis_q8": "Bạn có thể chuẩn bị các tài liệu cần thiết cho đơn xin nhập tịch không?",
            "diagnosis_q9": "Bạn có thể đọc và viết tiếng Nhật không?",
            "diagnosis_q10": "Bạn có hiểu thủ tục xin nhập tịch không?",
            
            // Common UI elements
            "question": "Câu hỏi",
            "diagnosis_title": "Chẩn đoán đủ điều kiện nhập tịch",
            "eligible": "Đủ điều kiện",
            "possible_eligibility": "Có thể đủ điều kiện",
            "insufficient_eligibility": "Không đủ điều kiện",
            "result": "Kết quả",
            "eligibility_score": "Điểm đủ điều kiện",
            "detailed_result": "Kết quả chi tiết",
            "next_steps": "Các bước tiếp theo",
            
            // Interview questions
            "interview_q1": "Tên của bạn là gì?",
            "interview_a1": "Tên tôi là [Tên].",
            "interview_tip1": "Hãy nói rõ ràng và chậm rãi.",
            "interview_q2": "Bạn sinh ra ở đâu?",
            "interview_a2": "Tôi sinh ra ở [Quốc gia].",
            "interview_tip2": "Hãy nói chính xác nơi sinh.",
            "interview_q3": "Bạn đến Nhật Bản khi nào?",
            "interview_a3": "Tôi đến Nhật Bản vào năm [Năm].",
            "interview_tip3": "Hãy nhớ chính xác năm bạn đến Nhật Bản.",
            "interview_q4": "Tại sao bạn muốn nhập tịch?",
            "interview_a4": "Vì tôi muốn sống lâu dài ở Nhật Bản.",
            "interview_tip4": "Hãy giải thích lý do bằng lời của mình.",
            "interview_q5": "Bạn thích gì về Nhật Bản?",
            "interview_a5": "Tôi thích văn hóa và con người Nhật Bản.",
            "interview_tip5": "Hãy đưa ra lý do cụ thể.",
            "interview_q6": "Bạn có tiếp tục sống ở Nhật Bản sau khi nhập tịch không?",
            "interview_a6": "Vâng, tôi sẽ tiếp tục sống ở Nhật Bản.",
            "interview_tip6": "Hãy thể hiện ý định tiếp tục sống ở Nhật Bản.",
            "interview_q7": "Nghề nghiệp hiện tại của bạn là gì?",
            "interview_a7": "Tôi là [Nghề nghiệp].",
            "interview_tip7": "Hãy nói chính xác nghề nghiệp hiện tại.",
            "interview_q8": "Công việc có thuận lợi không?",
            "interview_a8": "Vâng, rất thuận lợi.",
            "interview_tip8": "Hãy thể hiện có nghề nghiệp ổn định.",
            "interview_q9": "Thu nhập có ổn định không?",
            "interview_a9": "Vâng, rất ổn định.",
            "interview_tip9": "Hãy thể hiện ổn định về kinh tế.",
            "interview_q10": "Bạn có bao nhiêu thành viên gia đình?",
            "interview_a10": "Tôi có [Số] thành viên gia đình.",
            "interview_tip10": "Hãy nói chính xác cấu trúc gia đình.",
            "interview_q11": "Thành viên gia đình có sống ở Nhật Bản không?",
            "interview_a11": "Vâng, gia đình tôi sống ở Nhật Bản.",
            "interview_tip11": "Hãy nói chính xác tình hình gia đình.",
            "interview_q12": "Mối quan hệ với gia đình có tốt không?",
            "interview_a12": "Vâng, rất tốt.",
            "interview_tip12": "Hãy thể hiện mối quan hệ tốt với gia đình.",
            "interview_q13": "Bạn nói tiếng Nhật như thế nào?",
            "interview_a13": "Tôi có thể giao tiếp hàng ngày mà không gặp vấn đề.",
            "interview_tip13": "Hãy đánh giá khả năng tiếng Nhật một cách phù hợp.",
            "interview_q14": "Bạn có tiếp tục học tiếng Nhật không?",
            "interview_a14": "Vâng, tôi tiếp tục học.",
            "interview_tip14": "Hãy thể hiện động lực học tiếng Nhật.",
            "interview_q15": "Bạn có hiểu luật pháp Nhật Bản không?",
            "interview_a15": "Tôi hiểu các luật cơ bản.",
            "interview_tip15": "Hãy thể hiện sự hiểu biết về luật pháp Nhật Bản.",
            "interview_q16": "Bạn có đóng thuế đúng không?",
            "interview_a16": "Vâng, tôi đóng thuế đúng.",
            "interview_tip16": "Hãy thể hiện thực hiện nghĩa vụ thuế.",
            "interview_q17": "Bạn có tiền án tiền sự không?",
            "interview_a17": "Không, tôi không có.",
            "interview_tip17": "Hãy thể hiện hạnh kiểm tốt.",
            "interview_q18": "Bạn có câu hỏi nào khác không?",
            "interview_a18": "Không có gì đặc biệt.",
            "interview_tip18": "Hãy trả lời ngắn gọn.",
            
            // Translation Support
            "translation_support_title": "Hỗ trợ dịch thuật",
            "select_language": "Chọn ngôn ngữ",
            "select_document": "Chọn tài liệu",
            "original_text": "Văn bản gốc",
            "show_template": "Hiển thị mẫu",
            "translate": "Dịch",
            "faq": "Câu hỏi thường gặp",
            "faq_q1": "Có cần dịch thuật không?",
            "faq_q2": "Có cần công chứng không?",
            "faq_q3": "Có nên yêu cầu dịch thuật chuyên nghiệp không?",
            
            // InterviewPreparationView用
            "japanese_audio": "Âm thanh tiếng Nhật",
            "multilingual_subtitles": "Phụ đề đa ngôn ngữ",
            "listen_with_audio": "Nghe với âm thanh",
            
            // その他の未翻訳箇所
            "no_documents_found": "Không tìm thấy tài liệu phù hợp",
            "try_different_search": "Thử tìm kiếm với tiêu chí khác",
            "criminal_record_explanation": "Không có tiền án tiền sự, đóng thuế, không vi phạm giao thông, v.v.",
            "expired": "Hết hạn",
            "days_later": "%d ngày sau",
            "configure": "Cấu hình",
            "open": "Mở",
            "enter_title": "Nhập tiêu đề",
            "enter_description": "Nhập mô tả (tùy chọn)",
            "enter_name": "Nhập tên",
            "enter_nationality": "Nhập quốc tịch",
            "enter_occupation": "Nhập nghề nghiệp",
            "enter_email": "Nhập địa chỉ email",
            "status": "Trạng thái",
            "incomplete": "Chưa hoàn thành",
            "overdue": "Quá hạn",
            
            // DocumentCategory用
            "personal": "Thông tin cá nhân",
            "financial": "Tài liệu tài chính",
            "legal": "Tài liệu pháp lý",
            "medical": "Tài liệu y tế",
            "employment": "Liên quan đến việc làm",
            
            // DocumentPriority用
            "low": "Thấp",
            "medium": "Trung bình",
            "high": "Cao",
            
            // フィルター用
            "all": "Tất cả",
            "today": "Hôm nay",
            "this_week": "Tuần này",
            "this_month": "Tháng này",
            
            // カテゴリー用
            "consultation": "Tư vấn",
            "document_preparation": "Chuẩn bị tài liệu",
            "application": "Đơn xin",
            "interview": "Phỏng vấn",
            
            // 国名用
            "china": "Trung Quốc",
            "vietnam": "Việt Nam",
            "philippines": "Philippines",
            "nepal": "Nepal",
            "korea": "Hàn Quốc",
            "common": "Chung",
            
            // 在留資格用
            "worker": "Người lao động",
            "student": "Sinh viên",
            "technical_intern": "Thực tập sinh kỹ thuật",
            "international_marriage": "Hôn nhân quốc tế",
            "permanent_resident": "Thường trú nhân",
            
            // 法務局関連
            "sapporo_legal_office": "Cục Pháp chế Sapporo",
            "hakodate_legal_office": "Cục Pháp chế Quận Hakodate",
            "asahikawa_legal_office": "Cục Pháp chế Quận Asahikawa",
            "aomori_legal_office": "Cục Pháp chế Quận Aomori",
            "morioka_legal_office": "Cục Pháp chế Quận Morioka",
            "sendai_legal_office": "Cục Pháp chế Sendai",
            "akita_legal_office": "Cục Pháp chế Quận Akita",
            "yamagata_legal_office": "Cục Pháp chế Quận Yamagata",
            "fukushima_legal_office": "Cục Pháp chế Quận Fukushima",
            "tokyo_legal_office": "Cục Pháp chế Tokyo",
            "tokyo_shinjuku_office": "Chi nhánh Shinjuku Cục Pháp chế Tokyo",
            "tokyo_tachikawa_office": "Chi nhánh Tachikawa Cục Pháp chế Tokyo",
            "yokohama_legal_office": "Cục Pháp chế Quận Yokohama",
            "kawasaki_legal_office": "Cục Pháp chế Quận Kawasaki",
            "saitama_legal_office": "Cục Pháp chế Quận Saitama",
            
            // 都道府県名
            "hokkaido": "Hokkaido",
            "aomori": "Tỉnh Aomori",
            "iwate": "Tỉnh Iwate",
            "miyagi": "Tỉnh Miyagi",
            "akita": "Tỉnh Akita",
            "yamagata": "Tỉnh Yamagata",
            "fukushima": "Tỉnh Fukushima",
            "tokyo": "Tokyo",
            "kanagawa": "Tỉnh Kanagawa",
            "saitama": "Tỉnh Saitama",
            
            // 法務局サービス
            "naturalization_consultation": "Tư vấn nhập tịch",
            "nationality_consultation": "Tư vấn quốc tịch",
            "family_register_consultation": "Tư vấn hộ tịch",
            "registration_consultation": "Tư vấn đăng ký"
        ],
        .korean: [
            "app_name": "KIKA+",
            "app_subtitle": "귀화 신청 지원 앱",
            "language_selection": "언어 선택",
            "settings": "설정",
            "cancel": "취소",
            "save": "저장",
            "delete": "삭제",
            "edit": "편집",
            "close": "닫기",
            "next": "다음",
            "back": "뒤로",
            "done": "완료",
            "loading": "로딩 중...",
            "error": "오류",
            "success": "성공",
            "yes": "예",
            "no": "아니오",
            "name": "이름",
            "nationality": "국적",
            "birth_date": "생년월일",
            
            // Main Menu
            "diagnosis_check": "자격 진단",
            "diagnosis_subtitle": "귀화 신청 자격 확인",
            "step_guide": "단계별 가이드",
            "step_guide_subtitle": "신청 절차 상세 가이드",
            "document_checklist": "서류 체크리스트",
            "document_checklist_subtitle": "필요 서류 확인",
            "translation_support": "번역 지원",
            "translation_support_subtitle": "서류 번역 지원",
            "legal_office_search": "법무국 검색",
            "legal_office_search_subtitle": "가까운 법무국 검색",
            "interview_preparation": "면접 준비",
            "interview_preparation_subtitle": "면접 준비 및 연습",
            "notification_management": "알림 관리",
            "notification_management_subtitle": "기한 및 일정 관리",
            
            // Diagnosis questions
            "diagnosis_q1": "일본에서 5년 이상 연속으로 거주하고 계십니까?",
            "diagnosis_q2": "20세 이상이며, 본국 법에 따라 성년 능력을 가지고 계십니까?",
            "diagnosis_q3": "품행이 선량하십니까?",
            "diagnosis_q4": "자신 또는 생계를 같이하는 배우자나 다른 친족의 자산이나 기능으로 생계를 영위할 수 있습니까?",
            "diagnosis_q5": "국적이 없거나, 일본 국적 취득으로 인해 그 국적을 잃어야 합니까?",
            "diagnosis_q6": "일본국 헌법 시행일 이후, 일본국 헌법이나 그 아래 성립된 정부를 폭력으로 파괴하려는 계획이나 주장을 하거나, 이를 계획하거나 주장하는 정당이나 다른 단체를 결성하거나 가입한 적이 있습니까?",
            "diagnosis_q7": "현재 일본에 체류하고 계십니까?",
            "diagnosis_q8": "귀화 신청에 필요한 서류를 준비할 수 있습니까?",
            "diagnosis_q9": "일본어 읽기와 쓰기를 할 수 있습니까?",
            "diagnosis_q10": "귀화 신청 절차를 이해하고 계십니까?",
            
            // Common UI elements
            "question": "질문",
            "diagnosis_title": "귀화 자격 진단",
            "eligible": "자격 있음",
            "possible_eligibility": "자격 가능성 있음",
            "insufficient_eligibility": "자격 부족",
            "result": "결과",
            "eligibility_score": "자격 점수",
            "detailed_result": "상세 결과",
            "next_steps": "다음 단계",
            
            // Interview questions
            "interview_q1": "이름이 무엇입니까?",
            "interview_a1": "제 이름은 [이름]입니다.",
            "interview_tip1": "명확하고 천천히 말하세요.",
            "interview_q2": "어디서 태어났습니까?",
            "interview_a2": "저는 [국가]에서 태어났습니다.",
            "interview_tip2": "출생지를 정확히 말하세요.",
            "interview_q3": "언제 일본에 왔습니까?",
            "interview_a3": "저는 [년도]에 일본에 왔습니다.",
            "interview_tip3": "일본에 온 년도를 정확히 기억하세요.",
            "interview_q4": "왜 귀화를 원하십니까?",
            "interview_a4": "일본에서 영구적으로 살고 싶기 때문입니다.",
            "interview_tip4": "자신의 말로 이유를 설명하세요.",
            "interview_q5": "일본의 무엇을 좋아하십니까?",
            "interview_a5": "일본 문화와 사람들을 좋아합니다.",
            "interview_tip5": "구체적인 이유를 들어보세요.",
            "interview_q6": "귀화 후에도 일본에 계속 살겠습니까?",
            "interview_a6": "네, 일본에 계속 살겠습니다.",
            "interview_tip6": "일본에 계속 살겠다는 의지를 보여주세요.",
            "interview_q7": "현재 직업이 무엇입니까?",
            "interview_a7": "저는 [직업]입니다.",
            "interview_tip7": "현재 직업을 정확히 말하세요.",
            "interview_q8": "일이 순조롭습니까?",
            "interview_a8": "네, 순조롭습니다.",
            "interview_tip8": "안정적인 직업임을 보여주세요.",
            "interview_q9": "수입이 안정적입니까?",
            "interview_a9": "네, 안정적입니다.",
            "interview_tip9": "경제적으로 안정적임을 보여주세요.",
            "interview_q10": "가족은 몇 명입니까?",
            "interview_a10": "제 가족은 [명수]명입니다.",
            "interview_tip10": "가족 구성을 정확히 말하세요.",
            "interview_q11": "가족이 일본에 살고 있습니까?",
            "interview_a11": "네, 가족이 일본에 살고 있습니다.",
            "interview_tip11": "가족 상황을 정확히 말하세요.",
            "interview_q12": "가족과의 관계가 좋습니까?",
            "interview_a12": "네, 좋습니다.",
            "interview_tip12": "가족과의 관계가 좋음을 보여주세요.",
            "interview_q13": "일본어는 어느 정도 할 수 있습니까?",
            "interview_a13": "일상 회화는 문제없습니다.",
            "interview_tip13": "일본어 능력을 적절히 평가하세요.",
            "interview_q14": "일본어 공부를 계속하고 있습니까?",
            "interview_a14": "네, 계속 공부하고 있습니다.",
            "interview_tip14": "일본어 학습에 대한 의지를 보여주세요.",
            "interview_q15": "일본 법률을 이해하고 있습니까?",
            "interview_a15": "기본적인 법률은 이해하고 있습니다.",
            "interview_tip15": "일본 법률에 대한 이해를 보여주세요.",
            "interview_q16": "세금을 제대로 내고 있습니까?",
            "interview_a16": "네, 제대로 내고 있습니다.",
            "interview_tip16": "납세 의무를 이행하고 있음을 보여주세요.",
            "interview_q17": "범죄 경력이 있습니까?",
            "interview_a17": "아니요, 없습니다.",
            "interview_tip17": "품행이 선량함을 보여주세요.",
            "interview_q18": "다른 질문이 있습니까?",
            "interview_a18": "특별히 없습니다.",
            "interview_tip18": "간결하게 답하세요.",
            
            // Translation Support
            "translation_support_title": "번역 지원",
            "select_language": "언어 선택",
            "select_document": "문서 선택",
            "original_text": "원문",
            "show_template": "템플릿 표시",
            "translate": "번역",
            "faq": "자주 묻는 질문",
            "faq_q1": "번역이 필요한가요?",
            "faq_q2": "공증이 필요한가요?",
            "faq_q3": "전문 번역을 요청해야 하나요?",
            
            // InterviewPreparationView용
            "japanese_audio": "일본어 음성",
            "multilingual_subtitles": "다국어 자막",
            "listen_with_audio": "음성으로 듣기",
            
            // その他の未翻訳箇所
            "no_documents_found": "해당하는 서류를 찾을 수 없습니다",
            "try_different_search": "다른 조건으로 검색해 주세요",
            "criminal_record_explanation": "범죄 경력이 없고, 세금을 납부하고, 교통 위반이 없는 등",
            "expired": "기한 만료",
            "days_later": "%d일 후",
            "configure": "설정",
            "open": "열기",
            "enter_title": "제목 입력",
            "enter_description": "설명 입력 (선택사항)",
            "enter_name": "이름 입력",
            "enter_nationality": "국적 입력",
            "enter_occupation": "직업 입력",
            "enter_email": "이메일 주소 입력",
            "status": "상태",
            "incomplete": "미완료",
            "overdue": "기한 초과",
            
            // DocumentCategory用
            "personal": "개인정보",
            "financial": "재무서류",
            "legal": "법적서류",
            "medical": "의료서류",
            "employment": "고용관련",
            
            // DocumentPriority用
            "low": "낮음",
            "medium": "보통",
            "high": "높음",
            
            // フィルター用
            "all": "전체",
            "today": "오늘",
            "this_week": "이번 주",
            "this_month": "이번 달",
            
            // カテゴリー用
            "consultation": "상담",
            "document_preparation": "서류 준비",
            "application": "신청서",
            "interview": "면접",
            
            // 国名用
            "china": "중국",
            "vietnam": "베트남",
            "philippines": "필리핀",
            "nepal": "네팔",
            "korea": "한국",
            "common": "공통",
            
            // 在留資格用
            "worker": "근로자",
            "student": "유학생",
            "technical_intern": "기능실습생",
            "international_marriage": "국제결혼",
            "permanent_resident": "영주자",
            
            // 法務局関連
            "sapporo_legal_office": "삿포로 법무국",
            "hakodate_legal_office": "하코다테 지방법무국",
            "asahikawa_legal_office": "아사히카와 지방법무국",
            "aomori_legal_office": "아오모리 지방법무국",
            "morioka_legal_office": "모리오카 지방법무국",
            "sendai_legal_office": "센다이 법무국",
            "akita_legal_office": "아키타 지방법무국",
            "yamagata_legal_office": "야마가타 지방법무국",
            "fukushima_legal_office": "후쿠시마 지방법무국",
            "tokyo_legal_office": "도쿄 법무국",
            "tokyo_shinjuku_office": "도쿄 법무국 신주쿠 출장소",
            "tokyo_tachikawa_office": "도쿄 법무국 다치카와 출장소",
            "yokohama_legal_office": "요코하마 지방법무국",
            "kawasaki_legal_office": "가와사키 지방법무국",
            "saitama_legal_office": "사이타마 지방법무국",
            
            // 都道府県名
            "hokkaido": "홋카이도",
            "aomori": "아오모리현",
            "iwate": "이와테현",
            "miyagi": "미야기현",
            "akita": "아키타현",
            "yamagata": "야마가타현",
            "fukushima": "후쿠시마현",
            "tokyo": "도쿄도",
            "kanagawa": "가나가와현",
            "saitama": "사이타마현",
            
            // 法務局サービス
            "naturalization_consultation": "귀화 상담",
            "nationality_consultation": "국적 상담",
            "family_register_consultation": "호적 상담",
            "registration_consultation": "등기 상담"
        ],
        .filipino: [
            "app_name": "KIKA+",
            "app_subtitle": "App ng suporta sa aplikasyon ng naturalisasyon",
            "language_selection": "Pagpili ng wika",
            "settings": "Mga setting",
            "cancel": "Kanselahin",
            "save": "I-save",
            "delete": "Tanggalin",
            "edit": "I-edit",
            "close": "Isara",
            "next": "Susunod",
            "back": "Bumalik",
            "done": "Tapos na",
            "loading": "Naglo-load...",
            "error": "Error",
            "success": "Tagumpay",
            "yes": "Oo",
            "no": "Hindi",
            "name": "Pangalan",
            "nationality": "Nasyonalidad",
            "birth_date": "Petsa ng kapanganakan",
            
            // Main Menu
            "diagnosis_check": "Pagsusuri ng kuwalipikasyon",
            "diagnosis_subtitle": "Suriin ang kuwalipikasyon sa naturalisasyon",
            "step_guide": "Gabay sa mga hakbang",
            "step_guide_subtitle": "Detalyadong gabay sa proseso ng aplikasyon",
            "document_checklist": "Listahan ng mga dokumento",
            "document_checklist_subtitle": "Suriin ang mga kinakailangang dokumento",
            "translation_support": "Suporta sa pagsasalin",
            "translation_support_subtitle": "Tulong sa pagsasalin ng dokumento",
            "legal_office_search": "Paghahanap ng tanggapan ng legal",
            "legal_office_search_subtitle": "Hanapin ang pinakamalapit na tanggapan ng legal",
            "interview_preparation": "Pagpapahanda sa interbyu",
            "interview_preparation_subtitle": "Maghanda at magsanay para sa interbyu",
            "notification_management": "Pamamahala ng mga abiso",
            "notification_management_subtitle": "Pamahalaan ang mga deadline at iskedyul",
            
            // Diagnosis questions
            "diagnosis_q1": "Nakatira ka na ba nang tuloy-tuloy sa Japan ng mahigit 5 taon?",
            "diagnosis_q2": "Ikaw ba ay 20 taong gulang o mas matanda at may kakayahan na maging adult ayon sa batas ng iyong bansa?",
            "diagnosis_q3": "Mabuti ba ang iyong ugali?",
            "diagnosis_q4": "Makakabuhay ka ba mula sa iyong sariling ari-arian o kasanayan, o ng iyong asawa o ibang kamag-anak na kasama sa iyong pamumuhay?",
            "diagnosis_q5": "Wala ka bang nasyonalidad, o dapat mawala ang iyong nasyonalidad kapag nakuha mo ang nasyonalidad ng Japan?",
            "diagnosis_q6": "Pagkatapos ng petsa ng pagpapatupad ng Konstitusyon ng Japan, nagplano, nag-advocate, nag-organisa, o sumali ka na ba sa partido politikal o ibang organisasyon na nagplano o nag-advocate ng pagwasak sa Konstitusyon ng Japan o gobyerno na itinatag sa ilalim nito sa pamamagitan ng dahas?",
            "diagnosis_q7": "Nakatira ka ba ngayon sa Japan?",
            "diagnosis_q8": "Makakapaghanda ka ba ng mga dokumento na kinakailangan para sa aplikasyon ng naturalisasyon?",
            "diagnosis_q9": "Makakabasa at makakasulat ka ba ng Japanese?",
            "diagnosis_q10": "Naiintindihan mo ba ang proseso ng aplikasyon ng naturalisasyon?",
            
            // Common UI elements
            "question": "Tanong",
            "diagnosis_title": "Pagsusuri ng kuwalipikasyon sa naturalisasyon",
            "eligible": "Kuwalipikado",
            "possible_eligibility": "Posibleng kuwalipikado",
            "insufficient_eligibility": "Hindi sapat ang kuwalipikasyon",
            "result": "Resulta",
            "eligibility_score": "Marka ng kuwalipikasyon",
            "detailed_result": "Detalyadong resulta",
            "next_steps": "Mga susunod na hakbang",
            
            // Interview questions
            "interview_q1": "Ano ang pangalan mo?",
            "interview_a1": "Ang pangalan ko ay [Pangalan].",
            "interview_tip1": "Magsalita nang malinaw at mabagal.",
            "interview_q2": "Saan ka ipinanganak?",
            "interview_a2": "Ipinanganak ako sa [Bansa].",
            "interview_tip2": "Sabihin nang tumpak ang lugar ng kapanganakan.",
            "interview_q3": "Kailan ka pumunta sa Japan?",
            "interview_a3": "Pumunta ako sa Japan noong [Taon].",
            "interview_tip3": "Tandaan nang tumpak ang taon na pumunta ka sa Japan.",
            "interview_q4": "Bakit gusto mong mag-naturalisasyon?",
            "interview_a4": "Dahil gusto kong manirahan nang permanente sa Japan.",
            "interview_tip4": "Ipaliwanag ang dahilan sa sarili mong salita.",
            "interview_q5": "Ano ang gusto mo sa Japan?",
            "interview_a5": "Gusto ko ang kultura at mga tao ng Japan.",
            "interview_tip5": "Magbigay ng mga tiyak na dahilan.",
            "interview_q6": "Magpapatuloy ka bang manirahan sa Japan pagkatapos ng naturalisasyon?",
            "interview_a6": "Oo, magpapatuloy akong manirahan sa Japan.",
            "interview_tip6": "Ipakita ang iyong intensyon na magpatuloy na manirahan sa Japan.",
            "interview_q7": "Ano ang kasalukuyan mong trabaho?",
            "interview_a7": "Ako ay [Trabaho].",
            "interview_tip7": "Sabihin nang tumpak ang kasalukuyan mong trabaho.",
            "interview_q8": "Maayos ba ang iyong trabaho?",
            "interview_a8": "Oo, maayos.",
            "interview_tip8": "Ipakita na mayroon kang matatag na trabaho.",
            "interview_q9": "Matatag ba ang iyong kita?",
            "interview_a9": "Oo, matatag.",
            "interview_tip9": "Ipakita na matatag ka sa ekonomiya.",
            "interview_q10": "Ilan ang miyembro ng iyong pamilya?",
            "interview_a10": "Mayroon akong [Bilang] miyembro ng pamilya.",
            "interview_tip10": "Sabihin nang tumpak ang komposisyon ng pamilya.",
            "interview_q11": "Nakatira ba sa Japan ang mga miyembro ng iyong pamilya?",
            "interview_a11": "Oo, nakatira sa Japan ang aking pamilya.",
            "interview_tip11": "Sabihin nang tumpak ang sitwasyon ng pamilya.",
            "interview_q12": "Mabuti ba ang iyong relasyon sa pamilya?",
            "interview_a12": "Oo, mabuti.",
            "interview_tip12": "Ipakita na mayroon kang mabuting relasyon sa pamilya.",
            "interview_q13": "Gaano ka kagaling mag-Japanese?",
            "interview_a13": "Kaya kong makipag-usap sa araw-araw nang walang problema.",
            "interview_tip13": "I-evaluate nang naaangkop ang iyong kakayahan sa Japanese.",
            "interview_q14": "Nagpapatuloy ka bang mag-aral ng Japanese?",
            "interview_a14": "Oo, nagpapatuloy akong mag-aral.",
            "interview_tip14": "Ipakita ang iyong motibasyon sa pag-aaral ng Japanese.",
            "interview_q15": "Naiintindihan mo ba ang mga batas ng Japan?",
            "interview_a15": "Naiintindihan ko ang mga pangunahing batas.",
            "interview_tip15": "Ipakita ang iyong pag-unawa sa mga batas ng Japan.",
            "interview_q16": "Nagbabayad ka ba ng buwis nang maayos?",
            "interview_a16": "Oo, nagbabayad ako nang maayos.",
            "interview_tip16": "Ipakita na tinutupad mo ang iyong obligasyon sa pagbabayad ng buwis.",
            "interview_q17": "Mayroon ka bang kriminal na rekord?",
            "interview_a17": "Hindi, wala.",
            "interview_tip17": "Ipakita na mayroon kang mabuting ugali.",
            "interview_q18": "Mayroon ka bang ibang tanong?",
            "interview_a18": "Walang partikular.",
            "interview_tip18": "Sumagot nang maikli.",
            
            // Translation Support
            "translation_support_title": "Suporta sa Pagsasalin",
            "select_language": "Piliin ang Wika",
            "select_document": "Piliin ang Dokumento",
            "original_text": "Orihinal na Teksto",
            "show_template": "Ipakita ang Template",
            "translate": "Isalin",
            "faq": "FAQ",
            "faq_q1": "Kailangan ba ng pagsasalin?",
            "faq_q2": "Kailangan ba ng notaryo?",
            "faq_q3": "Dapat bang humiling ng propesyonal na pagsasalin?",
            
            // InterviewPreparationView用
            "japanese_audio": "Audio sa Hapon",
            "multilingual_subtitles": "Mga subtitle sa maraming wika",
            "listen_with_audio": "Makinig gamit ang audio",
            
            // その他の未翻訳箇所
            "no_documents_found": "Walang nahanap na dokumento",
            "try_different_search": "Subukan ang ibang search criteria",
            "criminal_record_explanation": "Walang criminal record, nagbabayad ng tax, walang traffic violation, atbp.",
            "expired": "Expired",
            "days_later": "%d araw mamaya",
            "configure": "I-configure",
            "open": "Buksan",
            "enter_title": "Maglagay ng title",
            "enter_description": "Maglagay ng description (optional)",
            "enter_name": "Maglagay ng pangalan",
            "enter_nationality": "Maglagay ng nasyonalidad",
            "enter_occupation": "Maglagay ng trabaho",
            "enter_email": "Maglagay ng email address",
            "status": "Status",
            "incomplete": "Hindi kumpleto",
            "overdue": "Overdue",
            
            // DocumentCategory用
            "personal": "Personal na Impormasyon",
            "financial": "Mga Dokumentong Pampinansyal",
            "legal": "Mga Dokumentong Legal",
            "medical": "Mga Dokumentong Medikal",
            "employment": "May Kaugnayan sa Trabaho",
            
            // DocumentPriority用
            "low": "Mababa",
            "medium": "Katamtaman",
            "high": "Mataas",
            
            // フィルター用
            "all": "Lahat",
            "today": "Ngayon",
            "this_week": "Ngayong Linggo",
            "this_month": "Ngayong Buwan",
            
            // カテゴリー用
            "consultation": "Konsultasyon",
            "document_preparation": "Paghahanda ng Dokumento",
            "application": "Aplikasyon",
            "interview": "Interbyu",
            
            // 国名用
            "china": "Tsina",
            "vietnam": "Vietnam",
            "philippines": "Pilipinas",
            "nepal": "Nepal",
            "korea": "Korea",
            "common": "Karaniwan",
            
            // 在留資格用
            "worker": "Manggagawa",
            "student": "Mag-aaral",
            "technical_intern": "Teknikal na Intern",
            "international_marriage": "Internasyonal na Kasal",
            "permanent_resident": "Permanenteng Resident",
            
            // 法務局関連
            "sapporo_legal_office": "Tanggapan ng Legal Affairs ng Sapporo",
            "hakodate_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Hakodate",
            "asahikawa_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Asahikawa",
            "aomori_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Aomori",
            "morioka_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Morioka",
            "sendai_legal_office": "Tanggapan ng Legal Affairs ng Sendai",
            "akita_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Akita",
            "yamagata_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Yamagata",
            "fukushima_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Fukushima",
            "tokyo_legal_office": "Tanggapan ng Legal Affairs ng Tokyo",
            "tokyo_shinjuku_office": "Sangay ng Shinjuku ng Tanggapan ng Legal Affairs ng Tokyo",
            "tokyo_tachikawa_office": "Sangay ng Tachikawa ng Tanggapan ng Legal Affairs ng Tokyo",
            "yokohama_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Yokohama",
            "kawasaki_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Kawasaki",
            "saitama_legal_office": "Tanggapan ng Legal Affairs ng Distrito ng Saitama",
            
            // 都道府県名
            "hokkaido": "Hokkaido",
            "aomori": "Prepektura ng Aomori",
            "iwate": "Prepektura ng Iwate",
            "miyagi": "Prepektura ng Miyagi",
            "akita": "Prepektura ng Akita",
            "yamagata": "Prepektura ng Yamagata",
            "fukushima": "Prepektura ng Fukushima",
            "tokyo": "Tokyo",
            "kanagawa": "Prepektura ng Kanagawa",
            "saitama": "Prepektura ng Saitama",
            
            // 法務局サービス
            "naturalization_consultation": "Konsultasyon sa Naturalisasyon",
            "nationality_consultation": "Konsultasyon sa Nasyonalidad",
            "family_register_consultation": "Konsultasyon sa Rehistro ng Pamilya",
            "registration_consultation": "Konsultasyon sa Rehistrasyon"
        ],
        .nepali: [
            "app_name": "KIKA+",
            "app_subtitle": "नागरिकता आवेदन समर्थन एप",
            "language_selection": "भाषा चयन",
            "settings": "सेटिङहरू",
            "cancel": "रद्द गर्नुहोस्",
            "save": "सुरक्षित गर्नुहोस्",
            "delete": "मेटाउनुहोस्",
            "edit": "सम्पादन गर्नुहोस्",
            "close": "बन्द गर्नुहोस्",
            "next": "अर्को",
            "back": "फिर्ता",
            "done": "सम्पन्न",
            "loading": "लोड हुँदै...",
            "error": "त्रुटि",
            "success": "सफल",
            "yes": "हो",
            "no": "होइन",
            "name": "नाम",
            "nationality": "राष्ट्रियता",
            "birth_date": "जन्म मिति",
            
            // Main Menu
            "diagnosis_check": "योग्यता जाँच",
            "diagnosis_subtitle": "नागरिकता आवेदन योग्यता जाँच",
            "step_guide": "चरण गाइड",
            "step_guide_subtitle": "विस्तृत आवेदन प्रक्रिया गाइड",
            "document_checklist": "कागजात चेकलिस्ट",
            "document_checklist_subtitle": "आवश्यक कागजातहरू जाँच",
            "translation_support": "अनुवाद समर्थन",
            "translation_support_subtitle": "कागजात अनुवाद सहायता",
            "legal_office_search": "कानूनी कार्यालय खोज",
            "legal_office_search_subtitle": "नजिकैको कानूनी कार्यालय खोज",
            "interview_preparation": "अन्तर्वार्ता तयारी",
            "interview_preparation_subtitle": "अन्तर्वार्ता तयारी र अभ्यास",
            "notification_management": "सूचना व्यवस्थापन",
            "notification_management_subtitle": "म्याद र कार्यक्रम व्यवस्थापन",
            
            // Diagnosis questions
            "diagnosis_q1": "तपाईं जापानमा 5 वर्ष भन्दा बढी लगातार बस्नुभएको छ?",
            "diagnosis_q2": "तपाईं 20 वर्ष वा माथिका हुनुहुन्छ र आफ्नो देशको कानुन अनुसार वयस्क क्षमता राख्नुहुन्छ?",
            "diagnosis_q3": "तपाईंको चरित्र राम्रो छ?",
            "diagnosis_q4": "तपाईं आफ्नो वा साझा जीविकाको साथी वा अन्य आफन्तको सम्पत्ति वा कौशलबाट जीविका चलाउन सक्नुहुन्छ?",
            "diagnosis_q5": "तपाईंसँग राष्ट्रियता छैन, वा जापानी राष्ट्रियता प्राप्त गरेर त्यो राष्ट्रियता गुमाउनुपर्छ?",
            "diagnosis_q6": "जापानी संविधान लागू भएको दिन पछि, तपाईंले कहिल्यै जापानी संविधान वा यसको अधीनमा स्थापित सरकारलाई हिंसा द्वारा नष्ट गर्ने योजना वा दाबी गर्नुभएको छ, वा यस्तो योजना वा दाबी गर्ने राजनीतिक दल वा अन्य संगठन गठन वा सामेल हुनुभएको छ?",
            "diagnosis_q7": "तपाईं हाल जापानमा बस्नुहुन्छ?",
            "diagnosis_q8": "तपाईं नागरिकता आवेदनको लागि आवश्यक कागजातहरू तयार गर्न सक्नुहुन्छ?",
            "diagnosis_q9": "तपाईं जापानी पढ्न र लेख्न सक्नुहुन्छ?",
            "diagnosis_q10": "तपाईं नागरिकता आवेदन प्रक्रिया बुझ्नुहुन्छ?",
            
            // Common UI elements
            "question": "प्रश्न",
            "diagnosis_title": "नागरिकता योग्यता जाँच",
            "eligible": "योग्य",
            "possible_eligibility": "सम्भावित योग्य",
            "insufficient_eligibility": "अपर्याप्त योग्यता",
            "result": "परिणाम",
            "eligibility_score": "योग्यता स्कोर",
            "detailed_result": "विस्तृत परिणाम",
            "next_steps": "अर्को चरणहरू",
            
            // Interview questions
            "interview_q1": "तपाईंको नाम के हो?",
            "interview_a1": "मेरो नाम [नाम] हो।",
            "interview_tip1": "स्पष्ट र धीमै बोल्नुहोस्।",
            "interview_q2": "तपाईं कहाँ जन्मनुभयो?",
            "interview_a2": "म [देश] मा जन्मेको हुँ।",
            "interview_tip2": "जन्मस्थान सही बताउनुहोस्।",
            "interview_q3": "तपाईं कहिले जापान आउनुभयो?",
            "interview_a3": "म [वर्ष] मा जापान आएको हुँ।",
            "interview_tip3": "जापान आएको वर्ष सही सम्झनुहोस्।",
            "interview_q4": "तपाईं किन नागरिकता चाहनुहुन्छ?",
            "interview_a4": "किनभने म जापानमा स्थायी रूपमा बस्न चाहन्छु।",
            "interview_tip4": "आफ्नै शब्दमा कारण व्याख्या गर्नुहोस्।",
            "interview_q5": "तपाईंलाई जापानको के मन पर्छ?",
            "interview_a5": "मलाई जापानी संस्कृति र मान्छेहरू मन पर्छ।",
            "interview_tip5": "विशिष्ट कारणहरू दिनुहोस्।",
            "interview_q6": "नागरिकता पछि पनि तपाईं जापानमा बस्नेछन्?",
            "interview_a6": "हो, म जापानमा बस्नेछु।",
            "interview_tip6": "जापानमा बस्ने इच्छा देखाउनुहोस्।",
            "interview_q7": "तपाईंको हालको पेशा के हो?",
            "interview_a7": "म [पेशा] हुँ।",
            "interview_tip7": "हालको पेशा सही बताउनुहोस्।",
            "interview_q8": "काम राम्रोसँग चलिरहेको छ?",
            "interview_a8": "हो, राम्रोसँग चलिरहेको छ।",
            "interview_tip8": "स्थिर पेशा भएको देखाउनुहोस्।",
            "interview_q9": "आम्दानी स्थिर छ?",
            "interview_a9": "हो, स्थिर छ।",
            "interview_tip9": "आर्थिक रूपमा स्थिर भएको देखाउनुहोस्।",
            "interview_q10": "तपाईंको परिवारमा कति जना छन्?",
            "interview_a10": "मसँग [संख्या] जना परिवार छन्।",
            "interview_tip10": "परिवारको संरचना सही बताउनुहोस्।",
            "interview_q11": "तपाईंको परिवार जापानमा बस्छन्?",
            "interview_a11": "हो, मेरो परिवार जापानमा बस्छ।",
            "interview_tip11": "परिवारको स्थिति सही बताउनुहोस्।",
            "interview_q12": "परिवारसँगको सम्बन्ध राम्रो छ?",
            "interview_a12": "हो, राम्रो छ।",
            "interview_tip12": "परिवारसँग राम्रो सम्बन्ध भएको देखाउनुहोस्।",
            "interview_q13": "तपाईं कति जापानी बोल्न सक्नुहुन्छ?",
            "interview_a13": "दैनिक कुराकानीमा समस्या छैन।",
            "interview_tip13": "जापानी क्षमतालाई उचित रूपमा मूल्याङ्कन गर्नुहोस्।",
            "interview_q14": "तपाईं जापानी सिक्न जारी राख्नुहुन्छ?",
            "interview_a14": "हो, म सिक्न जारी राख्छु।",
            "interview_tip14": "जापानी सिक्ने इच्छा देखाउनुहोस्।",
            "interview_q15": "तपाईं जापानी कानुन बुझ्नुहुन्छ?",
            "interview_a15": "म आधारभूत कानुनहरू बुझ्छु।",
            "interview_tip15": "जापानी कानुनको बुझाइ देखाउनुहोस्।",
            "interview_q16": "तपाईं कर सही तिर्नुहुन्छ?",
            "interview_a16": "हो, म सही तिर्छु।",
            "interview_tip16": "कर दायित्व पूरा गर्ने देखाउनुहोस्।",
            "interview_q17": "तपाईंसँग अपराधको इतिहास छ?",
            "interview_a17": "होइन, छैन।",
            "interview_tip17": "राम्रो चरित्र भएको देखाउनुहोस्।",
            "interview_q18": "तपाईंसँग अरू प्रश्नहरू छन्?",
            "interview_a18": "विशेष छैन।",
            "interview_tip18": "संक्षिप्त रूपमा जवाफ दिनुहोस्।",
            
            // Translation Support
            "translation_support_title": "अनुवाद सहयोग",
            "select_language": "भाषा छान्नुहोस्",
            "select_document": "कागजात छान्नुहोस्",
            "original_text": "मूल पाठ",
            "show_template": "टेम्पलेट देखाउनुहोस्",
            "translate": "अनुवाद",
            "faq": "बारम्बार सोधिने प्रश्नहरू",
            "faq_q1": "अनुवाद आवश्यक छ?",
            "faq_q2": "नोटरी आवश्यक छ?",
            "faq_q3": "म पेशेवर अनुवाद माग्नु पर्छ?",
            
            // InterviewPreparationView用
            "japanese_audio": "जापानी भाषा",
            "multilingual_subtitles": "बहुभाषी उपशीर्षक",
            "listen_with_audio": "ध्वनिसँग सुन्नुहोस्",
            
            // その他の未翻訳箇所
            "no_documents_found": "सम्बन्धित कागजातहरू फेला परेनन्",
            "try_different_search": "अरू खोज मापदण्डहरू प्रयास गर्नुहोस्",
            "criminal_record_explanation": "अपराधको इतिहास छैन, कर तिर्छ, यातायात उल्लङ्घन छैन, आदि",
            "expired": "म्याद सकियो",
            "days_later": "%d दिन पछि",
            "configure": "कन्फिगर गर्नुहोस्",
            "open": "खोल्नुहोस्",
            "enter_title": "शीर्षक प्रविष्ट गर्नुहोस्",
            "enter_description": "विवरण प्रविष्ट गर्नुहोस् (वैकल्पिक)",
            "enter_name": "नाम प्रविष्ट गर्नुहोस्",
            "enter_nationality": "राष्ट्रियता प्रविष्ट गर्नुहोस्",
            "enter_occupation": "पेशा प्रविष्ट गर्नुहोस्",
            "enter_email": "इमेल ठेगाना प्रविष्ट गर्नुहोस्",
            "status": "स्थिति",
            "incomplete": "अपूर्ण",
            "overdue": "म्याद नाघ्यो",
            
            // DocumentCategory用
            "personal": "व्यक्तिगत जानकारी",
            "financial": "आर्थिक कागजातहरू",
            "legal": "कानूनी कागजातहरू",
            "medical": "चिकित्सा कागजातहरू",
            "employment": "रोजगार सम्बन्धित",
            
            // DocumentPriority用
            "low": "कम",
            "medium": "मध्यम",
            "high": "उच्च",
            
            // フィルター用
            "all": "सबै",
            "today": "आज",
            "this_week": "यो हप्ता",
            "this_month": "यो महिना",
            
            // カテゴリー用
            "consultation": "परामर्श",
            "document_preparation": "कागजात तयारी",
            "application": "आवेदन",
            "interview": "अन्तर्वार्ता",
            
            // 国名用
            "china": "चीन",
            "vietnam": "भियतनाम",
            "philippines": "फिलिपिन्स",
            "nepal": "नेपाल",
            "korea": "कोरिया",
            "common": "साझा",
            
            // 在留資格用
            "worker": "कामदार",
            "student": "विद्यार्थी",
            "technical_intern": "प्राविधिक इन्टर्न",
            "international_marriage": "अन्तर्राष्ट्रिय विवाह",
            "permanent_resident": "स्थायी निवासी",
            
            // 法務局関連
            "sapporo_legal_office": "सप्पोरो कानूनी कार्यालय",
            "hakodate_legal_office": "हाकोदाते जिल्ला कानूनी कार्यालय",
            "asahikawa_legal_office": "आसाहिकावा जिल्ला कानूनी कार्यालय",
            "aomori_legal_office": "आओमोरी जिल्ला कानूनी कार्यालय",
            "morioka_legal_office": "मोरिओका जिल्ला कानूनी कार्यालय",
            "sendai_legal_office": "सेन्दाई कानूनी कार्यालय",
            "akita_legal_office": "अकिता जिल्ला कानूनी कार्यालय",
            "yamagata_legal_office": "यामागाता जिल्ला कानूनी कार्यालय",
            "fukushima_legal_office": "फुकुशिमा जिल्ला कानूनी कार्यालय",
            "tokyo_legal_office": "टोकियो कानूनी कार्यालय",
            "tokyo_shinjuku_office": "टोकियो कानूनी कार्यालय शिन्जुकु शाखा",
            "tokyo_tachikawa_office": "टोकियो कानूनी कार्यालय ताचिकावा शाखा",
            "yokohama_legal_office": "योकोहामा जिल्ला कानूनी कार्यालय",
            "kawasaki_legal_office": "कावासाकी जिल्ला कानूनी कार्यालय",
            "saitama_legal_office": "साइतामा जिल्ला कानूनी कार्यालय",
            
            // 都道府県名
            "hokkaido": "होक्काइदो",
            "aomori": "आओमोरी प्रान्त",
            "iwate": "इवाते प्रान्त",
            "miyagi": "मियागी प्रान्त",
            "akita": "अकिता प्रान्त",
            "yamagata": "यामागाता प्रान्त",
            "fukushima": "फुकुशिमा प्रान्त",
            "tokyo": "टोकियो",
            "kanagawa": "कानागावा प्रान्त",
            "saitama": "साइतामा प्रान्त",
            
            // 法務局サービス
            "naturalization_consultation": "नागरिकता परामर्श",
            "nationality_consultation": "राष्ट्रियता परामर्श",
            "family_register_consultation": "परिवार दर्ता परामर्श",
            "registration_consultation": "दर्ता परामर्श"
        ]
    ]
} 