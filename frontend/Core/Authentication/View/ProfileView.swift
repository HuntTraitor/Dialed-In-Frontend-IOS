//
//  ProfileView.swift
//  DialedIn
//
//  Created by Hunter Tratar on 7/16/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingDeleteAlert = false
    @State private var showingLogoutAlert = false
    
    private func formatDate(from dateString: String?) -> String {
        guard let dateString = dateString else { return "Not available" }
        
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return "Invalid date" }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .none
        
        return displayFormatter.string(from: date)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ZStack {
                    LinearGradient(
                        gradient: Gradient(colors: [Color("background").opacity(0.8), Color.white.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 200)
                    
                    VStack(spacing: 16) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        
                        Text("Profile")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("background"))
                            Text("Account Information")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Email Address")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 120, alignment: .leading)
                                Text(viewModel.user?.email ?? "Not available")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Text("Member Since")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .frame(width: 120, alignment: .leading)
                                Text(formatDate(from: viewModel.user?.createdAt))
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    
                    // Action buttons
                    VStack(spacing: 16) {
                        // Log out button
                         Button(action: {
                             showingLogoutAlert = true
                         }) {
                             HStack {
                                 Image(systemName: "rectangle.portrait.and.arrow.right")
                                     .font(.title3)
                                 Text("Log Out")
                                     .font(.headline)
                                     .fontWeight(.semibold)
                             }
                             .foregroundColor(.white)
                             .frame(maxWidth: .infinity)
                             .frame(height: 50)
                             .background(Color("background"))
                             .cornerRadius(12)
                         }
                         
                         // Delete account button
                         Button(action: {
                             showingDeleteAlert = true
                         }) {
                             HStack {
                                 Image(systemName: "trash")
                                     .font(.title3)
                                 Text("Delete Account")
                                     .font(.headline)
                                     .fontWeight(.semibold)
                             }
                             .foregroundColor(.white)
                             .frame(maxWidth: .infinity)
                             .frame(height: 50)
                             .background(Color.red)
                             .cornerRadius(12)
                         }
                    }
                    
                    Spacer(minLength: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
        }
        .background(Color(.systemBackground))
        .alert("Delete Account", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
        //        viewModel.deleteAccount()
                print("hi")
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone.")
        }
        .alert("Log Out", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Log Out", role: .destructive) {
                viewModel.signOut()
            }
        } message: {
            Text("Are you sure you want to log out?")
        }
        
    }
}

#Preview {
    let mockService = MockAuthService()
    let mockViewModel = AuthViewModel(authService: mockService)
    
    return ProfileView()
        .environmentObject(mockViewModel)
}

