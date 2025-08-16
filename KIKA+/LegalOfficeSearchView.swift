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
    
    let prefectures: [String] = []
    
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

let legalOffices: [LegalOffice] = []

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