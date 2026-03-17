import SwiftUI

struct PaletteEditorView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var existingPalette: CustomPaletteData?
    var onSave: ((CustomPaletteData) -> Void)?
    
    @State private var paletteName: String = ""
    @State private var colors: [String] = []
    @State private var hue: Double = 0.0
    @State private var saturation: Double = 1.0
    @State private var brightness: Double = 1.0
    @State private var addedFlash: Bool = false
    @State private var hexInput: String = ""
    @FocusState private var hexFieldFocused: Bool
    
    private let columns = [GridItem(.adaptive(minimum: 36), spacing: 6)]
    
    init(existingPalette: CustomPaletteData? = nil, onSave: ((CustomPaletteData) -> Void)? = nil) {
        self.existingPalette = existingPalette
        self.onSave = onSave
        _paletteName = State(initialValue: existingPalette?.name ?? "")
        _colors = State(initialValue: existingPalette?.hexColors ?? [])
    }
    
    private var selectedColor: Color {
        Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    private var selectedHex: String {
        selectedColor.toHex() ?? "#000000"
    }
    
    private var isDuplicate: Bool {
        colors.contains(where: { $0.lowercased() == selectedHex.lowercased() })
    }
    
    private func addCurrentColor() {
        let hex = selectedHex
        guard !colors.contains(where: { $0.lowercased() == hex.lowercased() }) else { return }
        colors.append(hex)
        withAnimation(.easeOut(duration: 0.2)) {
            addedFlash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            addedFlash = false
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                
                TextField("Palette Name", text: $paletteName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                // Hue/Saturation grid — tap anywhere to pick
                GeometryReader { geo in
                    ZStack {
                        // Draw the hue × saturation grid
                        Canvas { context, size in
                            let cols = Int(size.width)
                            let rows = Int(size.height)
                            let colStep = max(1, cols / 64)
                            let rowStep = max(1, rows / 32)
                            
                            for x in stride(from: 0, to: cols, by: colStep) {
                                for y in stride(from: 0, to: rows, by: rowStep) {
                                    let h = Double(x) / Double(cols)
                                    let s = 1.0 - (Double(y) / Double(rows))
                                    let color = Color(hue: h, saturation: s, brightness: brightness)
                                    context.fill(
                                        Path(CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(colStep), height: CGFloat(rowStep))),
                                        with: .color(color)
                                    )
                                }
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        // Crosshair indicator
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 16, height: 16)
                            .shadow(color: .black.opacity(0.5), radius: 1)
                            .position(
                                x: hue * geo.size.width,
                                y: (1.0 - saturation) * geo.size.height
                            )
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                hue = min(max(value.location.x / geo.size.width, 0), 1)
                                saturation = min(max(1.0 - value.location.y / geo.size.height, 0), 1)
                            }
                    )
                }
                .frame(height: 140)
                .padding(.horizontal)
                
                // Brightness slider
                HStack(spacing: 10) {
                    Image(systemName: "sun.min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    ZStack(alignment: .leading) {
                        // Gradient track
                        GeometryReader { geo in
                            LinearGradient(
                                colors: [
                                    Color(hue: hue, saturation: saturation, brightness: 0),
                                    Color(hue: hue, saturation: saturation, brightness: 1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(Capsule())
                            .frame(height: 12)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        }
                        
                        Slider(value: $brightness, in: 0...1)
                            .tint(.clear)
                    }
                    .frame(height: 28)
                    
                    Image(systemName: "sun.max")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Preview + Add button
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(selectedColor)
                        .frame(width: 48, height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .scaleEffect(addedFlash ? 1.15 : 1.0)
                    
                    Text(selectedHex)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: addCurrentColor) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(isDuplicate ? Color.gray : Color.blue)
                        .clipShape(Capsule())
                    }
                    .disabled(isDuplicate)
                }
                .padding(.horizontal)
                
                // Hex input field
                HStack(spacing: 8) {
                    Text("#")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    TextField("Type hex (e.g. FF5924)", text: $hexInput)
                        .font(.system(.body, design: .monospaced))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                        .focused($hexFieldFocused)
                        .onChange(of: hexInput) { oldValue, newValue in
                            // Strip # if user types it
                            let cleaned = newValue.replacingOccurrences(of: "#", with: "")
                            if cleaned != newValue {
                                hexInput = cleaned
                            }
                            // When 6 chars, navigate to that color
                            if cleaned.count == 6 {
                                let hex = "#" + cleaned.uppercased()
                                let color = Color(hex: hex)
                                let uiColor = UIColor(color)
                                var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                                uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
                                hue = Double(h)
                                saturation = Double(s)
                                brightness = Double(b)
                            }
                        }
                    
                    Button {
                        let cleaned = hexInput.replacingOccurrences(of: "#", with: "")
                        guard cleaned.count == 6 else { return }
                        let hex = "#" + cleaned.uppercased()
                        let color = Color(hex: hex)
                        let uiColor = UIColor(color)
                        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
                        hue = Double(h)
                        saturation = Double(s)
                        brightness = Double(b)
                        addCurrentColor()
                        hexInput = ""
                        hexFieldFocused = false
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                            .foregroundColor(hexInput.replacingOccurrences(of: "#", with: "").count == 6 ? .blue : .gray)
                    }
                    .disabled(hexInput.replacingOccurrences(of: "#", with: "").count != 6)
                }
                .padding(.horizontal)
                
                // Quick add row: black, white, and common grays
                HStack(spacing: 8) {
                    ForEach(["#000000", "#333333", "#666666", "#999999", "#CCCCCC", "#FFFFFF",
                             "#FF0000", "#FF8800", "#FFFF00", "#00FF00", "#0088FF", "#8800FF"], id: \.self) { hex in
                        Circle()
                            .fill(Color(hex: hex))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(hex == "#FFFFFF" ? Color.gray.opacity(0.3) : Color.clear, lineWidth: 1)
                            )
                            .onTapGesture {
                                let uiColor = UIColor(Color(hex: hex))
                                var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
                                uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
                                hue = Double(h)
                                saturation = Double(s)
                                brightness = Double(b)
                            }
                    }
                }
                .padding(.horizontal, 8)
                
                Divider()
                
                // Added colors grid
                if colors.isEmpty {
                    VStack(spacing: 4) {
                        Text("Tap the grid above to pick colors, then tap Add")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(colors.count) colors")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 6) {
                                ForEach(Array(colors.enumerated()), id: \.offset) { index, hex in
                                    ZStack(alignment: .topTrailing) {
                                        RoundedRectangle(cornerRadius: 6)
                                            .fill(Color(hex: hex))
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 6)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                        
                                        Button {
                                            colors.remove(at: index)
                                        } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.red).frame(width: 14, height: 14))
                                        }
                                        .offset(x: 4, y: -4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.top, 8)
            .navigationTitle(existingPalette == nil ? "New Palette" : "Edit Palette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let id = existingPalette?.id ?? UUID().uuidString
                        let name = paletteName.isEmpty ? "Custom Palette" : paletteName
                        let palette = CustomPaletteData(id: id, name: name, hexColors: colors)
                        CustomPaletteService.shared.savePalette(palette)
                        onSave?(palette)
                        dismiss()
                    }
                    .disabled(colors.count < 2)
                }
            }
        }
    }
}
