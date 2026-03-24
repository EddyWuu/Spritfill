import SwiftUI

struct PaletteEditorView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PaletteEditorViewModel
    
    var onSave: ((CustomPaletteData) -> Void)?
    
    @FocusState private var hexFieldFocused: Bool
    
    // Pro gating
    @ObservedObject private var storeService = StoreService.shared
    @State private var showProAlert = false
    @State private var showStoreSheet = false
    
    private let columns = [GridItem(.adaptive(minimum: 36), spacing: 6)]
    
    init(existingPalette: CustomPaletteData? = nil, onSave: ((CustomPaletteData) -> Void)? = nil) {
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: PaletteEditorViewModel(existingPalette: existingPalette))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                
                    TextField("Palette Name", text: $viewModel.paletteName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Hue/Saturation grid
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
                                        let color = Color(hue: h, saturation: s, brightness: viewModel.brightness)
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
                                    x: viewModel.hue * geo.size.width,
                                    y: (1.0 - viewModel.saturation) * geo.size.height
                                )
                        }
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    viewModel.overrideHex = nil
                                    viewModel.hue = min(max(value.location.x / geo.size.width, 0), 1)
                                    viewModel.saturation = min(max(1.0 - value.location.y / geo.size.height, 0), 1)
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
                                    Color(hue: viewModel.hue, saturation: viewModel.saturation, brightness: 0),
                                    Color(hue: viewModel.hue, saturation: viewModel.saturation, brightness: 1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            .clipShape(Capsule())
                            .frame(height: 12)
                            .position(x: geo.size.width / 2, y: geo.size.height / 2)
                        }
                        
                        Slider(value: Binding(
                            get: { viewModel.brightness },
                            set: { newValue in
                                viewModel.overrideHex = nil
                                viewModel.brightness = newValue
                            }
                        ), in: 0...1)
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
                        .fill(viewModel.selectedColor)
                        .frame(width: 48, height: 48)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .scaleEffect(viewModel.addedFlash ? 1.15 : 1.0)
                    
                    Text(viewModel.selectedHex)
                        .font(.system(.caption, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        if !storeService.isPro && viewModel.colors.count >= StoreProducts.freeCustomPaletteColorLimit {
                            showProAlert = true
                        } else {
                            viewModel.addCurrentColor()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("Add")
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(viewModel.isDuplicate ? Color.gray : Color.blue)
                        .clipShape(Capsule())
                    }
                    .disabled(viewModel.isDuplicate)
                }
                .padding(.horizontal)
                
                // Hex input field
                HStack(spacing: 8) {
                    Text("#")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.secondary)
                    
                    TextField("Type hex (e.g. FF5924)", text: $viewModel.hexInput)
                        .font(.system(.body, design: .monospaced))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                        .focused($hexFieldFocused)
                        .onChange(of: viewModel.hexInput) { _, newValue in
                            let cleaned = newValue.replacingOccurrences(of: "#", with: "")
                            if cleaned != newValue {
                                viewModel.hexInput = cleaned
                            }
                            if cleaned.count == 6 {
                                viewModel.navigateToHex(cleaned)
                            }
                        }
                    
                    Button {
                        viewModel.applyHexInput()
                        hexFieldFocused = false
                    } label: {
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title3)
                            .foregroundColor(viewModel.hexInput.replacingOccurrences(of: "#", with: "").count == 6 ? .blue : .gray)
                    }
                    .disabled(viewModel.hexInput.replacingOccurrences(of: "#", with: "").count != 6)
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
                                viewModel.navigateToColor(hex)
                            }
                    }
                }
                .padding(.horizontal, 8)
                
                Divider()
                
                // Added colors grid
                if viewModel.colors.isEmpty {
                    VStack(spacing: 4) {
                        Text("Tap the grid above to pick colors, then tap Add")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(height: 60)
                } else {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("\(viewModel.colors.count) colors")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if !storeService.isPro {
                                Text("(\(StoreProducts.freeCustomPaletteColorLimit) max)")
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            }
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(columns: columns, spacing: 6) {
                            ForEach(Array(viewModel.colors.enumerated()), id: \.offset) { index, hex in
                                ZStack(alignment: .topTrailing) {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color(hex: hex))
                                        .frame(width: 36, height: 36)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    
                                    Button {
                                        viewModel.removeColor(at: index)
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
                
                Spacer(minLength: 20)
                }
            }
            .padding(.top, 8)
            .navigationTitle(viewModel.existingPalette == nil ? "New Palette" : "Edit Palette")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let palette = viewModel.savePalette()
                        onSave?(palette)
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
            .alert("Pro Feature", isPresented: $showProAlert) {
                Button("Unlock Pro") { showStoreSheet = true }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Free users can add up to \(StoreProducts.freeCustomPaletteColorLimit) colors in a custom palette. Unlock Spritfill Pro for unlimited colors.")
            }
            .sheet(isPresented: $showStoreSheet) {
                StoreView()
            }
        }
    }
}
