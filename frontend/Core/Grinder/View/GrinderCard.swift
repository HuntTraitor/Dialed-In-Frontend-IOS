import SwiftUI

struct GrinderCard: View {
    let grinder: Grinder

    var onEdit: (() -> Void)? = nil
    var onDelete: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image("coffee.grinder")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 56, height: 56)
                .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 2)

            Text(grinder.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            Menu {
                Button {
                    onEdit?()
                } label: {
                    HStack {
                        Image(systemName: "pencil")
                        Text("Edit")
                    }
                }
                if onDelete != nil {
                    Button(role: .destructive) {
                        onDelete?()
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color("background"))
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    PreviewWrapper {
        VStack(spacing: 12) {
            GrinderCard(grinder: Grinder.MOCK_GRINDER)
        }
        .padding()
    }
}
