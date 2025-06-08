import SwiftUI 

struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content

    @State private var elementsSize: [Data.Element: CGSize] = [:]

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(row, id: \.self) { item in
                        content(item)
                            .fixedSize()
                            .background(GeometryReader { geometry in
                                Color.clear
                                    .preference(key: SizePreferenceKey.self, value: [item: geometry.size])
                            })
                    }
                }
            }
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            for (key, size) in preferences {
                if let elementKey = key as? Data.Element {
                    elementsSize[elementKey] = size
                }
            }
        }

    }

    private func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRowWidth: CGFloat = 0

        for item in data {
            let itemSize = elementsSize[item, default: CGSize(width: 100, height: 30)]
            if currentRowWidth + itemSize.width + spacing > availableWidth {
                rows.append([item])
                currentRowWidth = itemSize.width + spacing
            } else {
                rows[rows.count - 1].append(item)
                currentRowWidth += itemSize.width + spacing
            }
        }
        return rows
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: [AnyHashable: CGSize] = [:]
    static func reduce(value: inout [AnyHashable: CGSize], nextValue: () -> [AnyHashable: CGSize]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}
