//
//  LegalOfficeSearchView.swift
//  KIKA+
//
//  Created by Igasaki Gouta on 2025/06/28.
//

import SwiftUI
import MapKit

struct LegalOfficeSearchView: View {
    @State private var searchText = ""
    @State private var selectedPrefecture = ""
    @State private var showingMap = false
    @State private var selectedOffice: LegalOffice?
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    init() {
        // 初期化時に北海道を選択
        _selectedPrefecture = State(initialValue: LocalizationManager.shared.localizedString(.hokkaido))
    }
    
    var prefectures: [String] {
    [
        LocalizationManager.shared.localizedString(.hokkaido),
        LocalizationManager.shared.localizedString(.aomori),
        LocalizationManager.shared.localizedString(.iwate),
        LocalizationManager.shared.localizedString(.miyagi),
        LocalizationManager.shared.localizedString(.akita),
        LocalizationManager.shared.localizedString(.yamagata),
        LocalizationManager.shared.localizedString(.fukushima),
        LocalizationManager.shared.localizedString(.ibaraki),
        LocalizationManager.shared.localizedString(.tochigi),
        LocalizationManager.shared.localizedString(.gunma),
        LocalizationManager.shared.localizedString(.chiba),
        LocalizationManager.shared.localizedString(.tokyo),
        LocalizationManager.shared.localizedString(.kanagawa),
        LocalizationManager.shared.localizedString(.niigata),
        LocalizationManager.shared.localizedString(.toyama),
        LocalizationManager.shared.localizedString(.ishikawa),
        LocalizationManager.shared.localizedString(.fukui),
        LocalizationManager.shared.localizedString(.yamanashi),
        LocalizationManager.shared.localizedString(.nagano),
        LocalizationManager.shared.localizedString(.gifu),
        LocalizationManager.shared.localizedString(.shizuoka),
        LocalizationManager.shared.localizedString(.aichi),
        LocalizationManager.shared.localizedString(.mie),
        LocalizationManager.shared.localizedString(.shiga),
        LocalizationManager.shared.localizedString(.kyoto),
        LocalizationManager.shared.localizedString(.osaka),
        LocalizationManager.shared.localizedString(.hyogo),
        LocalizationManager.shared.localizedString(.nara),
        LocalizationManager.shared.localizedString(.wakayama),
        LocalizationManager.shared.localizedString(.tottori),
        LocalizationManager.shared.localizedString(.shimane),
        LocalizationManager.shared.localizedString(.okayama),
        LocalizationManager.shared.localizedString(.hiroshima),
        LocalizationManager.shared.localizedString(.yamaguchi),
        LocalizationManager.shared.localizedString(.tokushima),
        LocalizationManager.shared.localizedString(.kagawa),
        LocalizationManager.shared.localizedString(.ehime),
        LocalizationManager.shared.localizedString(.kochi),
        LocalizationManager.shared.localizedString(.fukuoka),
        LocalizationManager.shared.localizedString(.saga),
        LocalizationManager.shared.localizedString(.nagasaki),
        LocalizationManager.shared.localizedString(.kumamoto),
        LocalizationManager.shared.localizedString(.oita),
        LocalizationManager.shared.localizedString(.miyazaki),
        LocalizationManager.shared.localizedString(.kagoshima),
        LocalizationManager.shared.localizedString(.okinawa),
        LocalizationManager.shared.localizedString(.saitama)
    ]
}

var filteredOffices: [LegalOffice] {
    if searchText.isEmpty {
        return legalOffices.filter { $0.prefecture == selectedPrefecture }
    } else {
        return legalOffices.filter { office in
            office.prefecture == selectedPrefecture &&
            (office.name.localizedCaseInsensitiveContains(searchText) ||
             office.address.localizedCaseInsensitiveContains(searchText))
        }
    }
}
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 検索ヘッダー
                VStack(spacing: 15) {
                    // 都道府県選択
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localizationManager.localizedString(.prefecture))
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(prefectures, id: \.self) { prefecture in
                                    Button(action: {
                                        selectedPrefecture = prefecture
                                        searchText = ""
                                    }) {
                                        Text(prefecture)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(selectedPrefecture == prefecture ? Color.blue : Color(.systemGray5))
                                            .foregroundColor(selectedPrefecture == prefecture ? .white : .primary)
                                            .cornerRadius(20)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 検索バー
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField(localizationManager.localizedString(.searchLegalOffice), text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.vertical)
                .background(Color(.systemBackground))
                
                // 法務局リスト
                if filteredOffices.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "building.2")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text(localizationManager.localizedString(.noLegalOfficeFound))
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(localizationManager.localizedString(.tryDifferentSearch))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(filteredOffices, id: \.id) { office in
                        LegalOfficeCard(office: office) {
                            selectedOffice = office
                            showingMap = true
                        }
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString(.searchLegalOffice))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingMap) {
                if let office = selectedOffice {
                    LegalOfficeMapView(office: office)
                }
            }
        }
    }
}

struct LegalOffice {
    let id = UUID()
    let name: String
    let prefecture: String
    let address: String
    let phone: String
    let fax: String
    let email: String
    let website: String
    let hours: String
    let consultationDays: String
    let latitude: Double
    let longitude: Double
    let services: [String]
}

var legalOffices: [LegalOffice] {
    [
        // 北海道
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.sapporoLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.hokkaido),
            address: "札幌市中央区北1条西13丁目",
            phone: "011-251-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 43.0618,
            longitude: 141.3545,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.hakodateLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.hokkaido),
            address: "函館市本町24-1",
            phone: "0138-23-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 41.7688,
            longitude: 140.7289,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        
        // 東北地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.aomoriLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.aomori),
            address: "青森市新町1-3-1",
            phone: "017-722-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 40.8243,
            longitude: 140.7403,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.moriokaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.iwate),
            address: "盛岡市内丸10-1",
            phone: "019-624-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 39.7036,
            longitude: 141.1527,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.sendaiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.miyagi),
            address: "仙台市青葉区本町3-3-1",
            phone: "022-221-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 38.2688,
            longitude: 140.8721,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.akitaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.akita),
            address: "秋田市大町3-1-1",
            phone: "018-862-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 39.7186,
            longitude: 140.1024,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.yamagataLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.yamagata),
            address: "山形市本町1-1-1",
            phone: "023-632-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 38.2554,
            longitude: 140.3399,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.fukushimaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.fukushima),
            address: "福島市杉妻町5-75",
            phone: "024-534-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 37.7503,
            longitude: 140.4676,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        
        // 関東地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.ibarakiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.ibaraki),
            address: "水戸市三の丸1-5-38",
            phone: "029-221-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 36.3418,
            longitude: 140.4468,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.tochigiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.tochigi),
            address: "宇都宮市本町1-1-1",
            phone: "028-632-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 36.5657,
            longitude: 139.8836,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.gunmaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.gunma),
            address: "前橋市大手町1-1-1",
            phone: "027-223-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 36.3911,
            longitude: 139.0608,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.chibaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.chiba),
            address: "千葉市中央区市場町1-1",
            phone: "043-245-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.6073,
            longitude: 140.1064,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.tokyoLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.tokyo),
            address: "東京都千代田区霞が関1-1-1",
            phone: "03-3580-4111",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.6762,
            longitude: 139.6503,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.yokohamaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.kanagawa),
            address: "横浜市中区山下町2",
            phone: "045-201-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.4437,
            longitude: 139.6380,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.saitamaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.saitama),
            address: "さいたま市浦和区高砂3-15-1",
            phone: "048-822-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.8569,
            longitude: 139.6489,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        
        // 中部地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.niigataLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.niigata),
            address: "新潟市中央区東大通1-1-1",
            phone: "025-228-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 37.9022,
            longitude: 139.0232,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.toyamaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.toyama),
            address: "富山市新桜町7-38",
            phone: "076-441-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 36.6953,
            longitude: 137.2113,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.kanazawaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.ishikawa),
            address: "金沢市広坂1-1-1",
            phone: "076-231-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 36.5613,
            longitude: 136.6562,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.fukuiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.fukui),
            address: "福井市大手3-17-1",
            phone: "0776-21-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 36.0652,
            longitude: 136.2217,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.yamanashiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.yamanashi),
            address: "甲府市丸の内1-1-1",
            phone: "055-237-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.6642,
            longitude: 138.5685,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.naganoLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.nagano),
            address: "長野市大字鶴賀緑町1613",
            phone: "026-232-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 36.6513,
            longitude: 138.1812,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.gifuLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.gifu),
            address: "岐阜市司町40-5",
            phone: "058-265-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.4233,
            longitude: 136.7607,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.shizuokaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.shizuoka),
            address: "静岡市葵区追手町9-6",
            phone: "054-221-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.9769,
            longitude: 138.3831,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.nagoyaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.aichi),
            address: "名古屋市中区三の丸2-2-1",
            phone: "052-951-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.1815,
            longitude: 136.9066,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.mieLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.mie),
            address: "津市丸之内27-45",
            phone: "059-228-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.7303,
            longitude: 136.5086,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        
        // 近畿地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.otsuLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.shiga),
            address: "大津市京町4-1-1",
            phone: "077-522-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.0045,
            longitude: 135.8683,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.kyotoLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.kyoto),
            address: "京都市上京区下立売通新町西入薮ノ内町",
            phone: "075-451-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.0116,
            longitude: 135.7681,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.osakaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.osaka),
            address: "大阪市中央区大手前1-3-49",
            phone: "06-6941-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.6863,
            longitude: 135.5197,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.kobeLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.hyogo),
            address: "神戸市中央区下山手通4-4-1",
            phone: "078-331-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.6901,
            longitude: 135.1955,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.naraLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.nara),
            address: "奈良市登大路町30",
            phone: "0742-22-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.6851,
            longitude: 135.8328,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.wakayamaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.wakayama),
            address: "和歌山市七番丁23",
            phone: "073-422-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.2261,
            longitude: 135.1675,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        
        // 中国地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.tottoriLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.tottori),
            address: "鳥取市東町1-220",
            phone: "0857-22-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.5039,
            longitude: 134.2383,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.matsueLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.shimane),
            address: "松江市殿町1",
            phone: "0852-21-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 35.4723,
            longitude: 133.0505,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.okayamaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.okayama),
            address: "岡山市北区大供1-1-1",
            phone: "086-223-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.6618,
            longitude: 133.9347,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.hiroshimaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.hiroshima),
            address: "広島市中区上八丁堀6-30",
            phone: "082-221-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.3853,
            longitude: 132.4553,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.yamaguchiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.yamaguchi),
            address: "山口市滝町1-1",
            phone: "083-922-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.1858,
            longitude: 131.4714,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        
        // 四国地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.tokushimaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.tokushima),
            address: "徳島市新町橋2-24",
            phone: "088-622-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.0658,
            longitude: 134.5593,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.takamatsuLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.kagawa),
            address: "高松市番町1-8-15",
            phone: "087-831-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 34.3401,
            longitude: 134.0434,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.matsuyamaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.ehime),
            address: "松山市一番町3-4-1",
            phone: "089-921-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 33.8416,
            longitude: 132.7660,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.kochiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.kochi),
            address: "高知市丸ノ内2-1-45",
            phone: "088-823-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 33.5597,
            longitude: 133.5311,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        
        // 九州地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.fukuokaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.fukuoka),
            address: "福岡市博多区東公園7-7",
            phone: "092-471-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 33.5902,
            longitude: 130.4017,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.sagaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.saga),
            address: "佐賀市城内1-1-59",
            phone: "0952-24-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 33.2494,
            longitude: 130.2988,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.nagasakiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.nagasaki),
            address: "長崎市江戸町2-13",
            phone: "095-822-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 32.7503,
            longitude: 129.8777,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.kumamotoLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.kumamoto),
            address: "熊本市中央区手取本町1-1",
            phone: "096-326-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 32.7898,
            longitude: 130.7417,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.oitaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.oita),
            address: "大分市府内町1-1-1",
            phone: "097-536-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 33.2381,
            longitude: 131.6126,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.miyazakiLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.miyazaki),
            address: "宮崎市橘通東2-10-1",
            phone: "0985-27-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 31.9112,
            longitude: 131.4239,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        ),
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.kagoshimaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.kagoshima),
            address: "鹿児島市山下町5-1",
            phone: "099-222-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 31.5602,
            longitude: 130.5581,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.registrationConsultation)
            ]
        ),
        
        // 沖縄地方
        LegalOffice(
            name: LocalizationManager.shared.localizedString(.nahaLegalOffice),
            prefecture: LocalizationManager.shared.localizedString(.okinawa),
            address: "那覇市泉崎1-2-2",
            phone: "098-866-1101",
            fax: "",
            email: "",
            website: "",
            hours: "8:30-17:15",
            consultationDays: LocalizationManager.shared.localizedString(.weekdays),
            latitude: 26.2124,
            longitude: 127.6809,
            services: [
                LocalizationManager.shared.localizedString(.naturalizationConsultation),
                LocalizationManager.shared.localizedString(.nationalityConsultation),
                LocalizationManager.shared.localizedString(.familyRegisterConsultation)
            ]
        )
    ]
}

struct LegalOfficeCard: View {
    let office: LegalOffice
    let onTap: () -> Void
    @ObservedObject private var localizationManager = LocalizationManager.shared
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // ヘッダー
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(office.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(office.prefecture)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                
                // 住所
                HStack {
                    Image(systemName: "mappin")
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Text(office.address)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                }
                
                // 連絡先
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: "phone")
                                .foregroundColor(.green)
                                .font(.caption)
                            Text(office.phone)
                                .font(.caption)
                        }
                        
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text(office.hours)
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(localizationManager.localizedString(.consultationDays))
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(office.consultationDays)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                
                // サービス
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(office.services, id: \.self) { service in
                            Text(service)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
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

struct LegalOfficeMapView: View {
    let office: LegalOffice
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var localizationManager = LocalizationManager.shared
    @State private var region: MKCoordinateRegion
    
    init(office: LegalOffice) {
        self.office = office
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: office.latitude, longitude: office.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 地図
                Map(coordinateRegion: $region, annotationItems: [office]) { office in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: office.latitude, longitude: office.longitude), tint: .red)
                }
                .frame(height: 300)
                
                // 詳細情報
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 基本情報
                        VStack(alignment: .leading, spacing: 15) {
                            Text(office.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            // 詳細情報表示部分を修正
                            ForEach(infoLabels, id: \.0) { icon, labelKey in
                                InfoRow(icon: icon, title: localizationManager.localizedString(labelKey), content: getContent(for: icon))
                            }
                        }
                        
                        // アクション
                        VStack(spacing: 12) {
                            Button(action: {
                                callOffice(office.phone)
                            }) {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text(localizationManager.localizedString(.callOffice))
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                openWebsite(office.website)
                            }) {
                                HStack {
                                    Image(systemName: "globe")
                                    Text(localizationManager.localizedString(.openWebsite))
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            
                            Button(action: {
                                openInMaps(office)
                            }) {
                                HStack {
                                    Image(systemName: "map")
                                    Text(localizationManager.localizedString(.openInMaps))
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
            }
            .navigationTitle(localizationManager.localizedString(.searchLegalOffice))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(localizationManager.localizedString(.close)) {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func callOffice(_ phone: String) {
        if let url = URL(string: "tel:\(phone)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func openWebsite(_ website: String) {
        if let url = URL(string: website) {
            UIApplication.shared.open(url)
        }
    }
    
    private func openInMaps(_ office: LegalOffice) {
        let latitude = office.latitude
        let longitude = office.longitude
        let name = office.name
        let urlString = "http://maps.apple.com/?q=\(name)&ll=\(latitude),\(longitude)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    private func getContent(for icon: String) -> String {
        switch icon {
        case "mappin":
            return office.address
        case "phone":
            return office.phone
        case "fax":
            return office.fax
        case "envelope":
            return office.email
        case "globe":
            return office.website
        case "clock":
            return office.hours
        case "calendar":
            return office.consultationDays
        default:
            return ""
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(content)
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

// 詳細情報のラベルをローカライズキーで管理
let infoLabels: [(String, LocalizationKey)] = [
    ("mappin", .address),
    ("phone", .phoneNumber),
    ("fax", .fax),
    ("envelope", .email),
    ("globe", .website),
    ("clock", .businessHours),
    ("calendar", .consultationDays)
]

extension LegalOffice: Identifiable {}

#Preview {
    LegalOfficeSearchView()
} 