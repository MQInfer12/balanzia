import SwiftUI

struct UINumericPicker: View {
  var title: String
  @Binding var value: Double
  var range: ClosedRange<Int> = 0...9999
  var decimalPlaces: Int = 2

  @State private var integerPart: Int = 0
  @State private var decimalPart: Int = 0
  @State private var stepIndex: Int = 0

  private let steps = [1, 10, 100]
  private var decimalMultiplier: Int {
    Int(pow(10.0, Double(decimalPlaces)))
  }

  private var integerOptions: [Int] {
    let step = steps[stepIndex]
    let offset = integerPart % step
    return stride(
      from: range.lowerBound + offset, through: range.upperBound, by: step
    ).map { $0 }
  }

  var body: some View {
    VStack {
      Text(title)
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack {
        Picker("Integer", selection: $integerPart) {
          ForEach(integerOptions, id: \.self) { number in
            Text("\(number)").tag(number)
          }
        }
        .frame(width: 60)
        .clipped()
        .onChange(of: integerPart) { _, _ in updateValue() }
        .labelsHidden()
        .pickerStyle(.wheel)
        .id(stepIndex)

        if decimalPlaces > 0 {
          Text(".")
            .font(.title2)
            .padding(.horizontal, 2)

          Picker("Decimal", selection: $decimalPart) {
            ForEach(0..<decimalMultiplier, id: \.self) { number in
              Text(String(format: "%0\(decimalPlaces)d", number)).tag(number)
            }
          }
          .frame(width: 50)
          .clipped()
          .onChange(of: decimalPart) { _, _ in updateValue() }
          .labelsHidden()
          .pickerStyle(.wheel)
        }

        Spacer()

        VStack {
          Text("x\(steps[stepIndex])")
            .font(.system(size: 10))

          Spacer()
          
          Button {
            stepIndex = (stepIndex + 1) % steps.count
          } label: {
            Image(systemName: "arrow.triangle.2.circlepath")
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)
              .padding(4)
          }
          .buttonStyle(PlainButtonStyle())
          .background(Color.gray.opacity(0.25))
          .cornerRadius(20)
        }
      }
    }
    .onAppear {
      integerPart = Int(value)
      decimalPart = Int(
        (value - Double(integerPart)) * Double(decimalMultiplier))
    }
  }

  private func updateValue() {
    value =
      Double(integerPart) + Double(decimalPart) / Double(decimalMultiplier)
    print(value)
  }
}
