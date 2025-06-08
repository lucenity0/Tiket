//
//  HelpSheet.swift
//  Tiket
//
//  Created by Nafees S on 08/06/25.
//

import SwiftUI

struct HelpSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Need Help?")
                    .font(.title2)
                    .bold()
                    .padding(.top)

                Text("For support or queries, email us at:")
                    .font(.body)

                Text("nafees.s2005@gmail.com")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: "mailto:nafees.s2005@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }

                Spacer()
            }
            .padding()
            .navigationTitle("Help Center")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
