import SwiftUI // ← Add this

struct FlowLayout<T: Hashable>: View {
    let tags: [T]
    let onRemove: (T) -> Void

    var body: some View {
        FlexibleView(
            availableWidth: UIScreen.main.bounds.width - 40,
            data: tags,
            spacing: 10,
            alignment: .leading
        ) { tag in
            HStack(spacing: 4) {
                Text("\(tag)")
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                Button(action: { onRemove(tag) }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
