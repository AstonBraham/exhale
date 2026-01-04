// SettingsModel.swift
import SwiftUI
import Combine

struct SettingsModelTypes {
    enum ColorFillGradient: String, Codable {
        case on, off
    }
    
    enum AnimationShape: String, Codable {
        case fullscreen, circle, square
    }
    
    enum AnimationMode: String, Codable {
        case sinusoidal, linear
    }
}

class SettingsModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let defaults = UserDefaults.standard
    
    @Published var backgroundColor: Color {
        didSet {
            saveColor(backgroundColor, forKey: "backgroundColor")
        }
    }
    
    @Published var inhaleColor: Color {
        didSet {
            saveColor(inhaleColor, forKey: "inhaleColor")
        }
    }
    
    @Published var exhaleColor: Color {
        didSet {
            saveColor(exhaleColor, forKey: "exhaleColor")
        }
    }
    
    @Published var inhaleDuration: TimeInterval {
        didSet {
            defaults.set(inhaleDuration, forKey: "inhaleDuration")
        }
    }
    
    @Published var postInhaleHoldDuration: TimeInterval {
        didSet {
            defaults.set(postInhaleHoldDuration, forKey: "postInhaleHoldDuration")
        }
    }
    
    @Published var exhaleDuration: TimeInterval {
        didSet {
            defaults.set(exhaleDuration, forKey: "exhaleDuration")
        }
    }
    
    @Published var postExhaleHoldDuration: TimeInterval {
        didSet {
            defaults.set(postExhaleHoldDuration, forKey: "postExhaleHoldDuration")
        }
    }
    
    @Published var drift: Double {
        didSet {
            defaults.set(drift, forKey: "drift")
        }
    }
    
    @Published var overlayOpacity: Double {
        didSet {
            defaults.set(overlayOpacity, forKey: "overlayOpacity")
        }
    }
    
    @Published var colorFillGradient: ColorFillGradient {
        didSet {
            defaults.set(colorFillGradient.rawValue, forKey: "colorFillGradient")
        }
    }
    
    @Published var shape: AnimationShape {
        didSet {
            defaults.set(shape.rawValue, forKey: "shape")
        }
    }
    
    @Published var animationMode: AnimationMode {
        didSet {
            defaults.set(animationMode.rawValue, forKey: "animationMode")
        }
    }
    
    @Published var randomizedTimingInhale: Double {
        didSet {
            defaults.set(randomizedTimingInhale, forKey: "randomizedTimingInhale")
        }
    }
    
    @Published var randomizedTimingPostInhaleHold: Double {
        didSet {
            defaults.set(randomizedTimingPostInhaleHold, forKey: "randomizedTimingPostInhaleHold")
        }
    }
    
    @Published var randomizedTimingExhale: Double {
        didSet {
            defaults.set(randomizedTimingExhale, forKey: "randomizedTimingExhale")
        }
    }
    
    @Published var randomizedTimingPostExhaleHold: Double {
        didSet {
            defaults.set(randomizedTimingPostExhaleHold, forKey: "randomizedTimingPostExhaleHold")
        }
    }
    
    @Published var isAnimating: Bool {
        didSet {
            defaults.set(isAnimating, forKey: "isAnimating")
        }
    }
    
    @Published var resetAnimation: Bool = false
    
    @Published var isPaused: Bool = false
    
    @Published var circlePositionX: Double {
        didSet {
            defaults.set(circlePositionX, forKey: "circlePositionX")
        }
    }
    
    @Published var circlePositionY: Double {
        didSet {
            defaults.set(circlePositionY, forKey: "circlePositionY")
        }
    }
    
    @Published var circleMaxSize: Double {
        didSet {
            defaults.set(circleMaxSize, forKey: "circleMaxSize")
        }
    }
    
    @Published var circleFillMode: CircleFillMode {
        didSet {
            defaults.set(circleFillMode.rawValue, forKey: "circleFillMode")
        }
    }
    
    @Published var circleMaxScreenFill: Double {
        didSet {
            defaults.set(circleMaxScreenFill, forKey: "circleMaxScreenFill")
        }
    }
    
    @Published var eyeBlinkColor: Color {
        didSet {
            saveColor(eyeBlinkColor, forKey: "eyeBlinkColor")
        }
    }
    
    @Published var eyeBlinkSize: Double {
        didSet {
            defaults.set(eyeBlinkSize, forKey: "eyeBlinkSize")
        }
    }
    
    @Published var eyeBlinkDuration: TimeInterval {
        didSet {
            defaults.set(eyeBlinkDuration, forKey: "eyeBlinkDuration")
        }
    }
    
    @Published var eyeBlinkInterval: TimeInterval {
        didSet {
            defaults.set(eyeBlinkInterval, forKey: "eyeBlinkInterval")
        }
    }
    
    func triggerAnimationReset() {
        resetAnimation = true
        resetAnimation = false
    }
    
    func start() {
        isAnimating = true
        isPaused = false
    }
    
    func stop() {
        isAnimating = false
        isPaused = false
    }
    
    func pause() {
        isPaused = true
    }
    
    func unpause() {
        isPaused = false
    }
    
    init() {
        self.backgroundColor = Color.clear
        self.inhaleColor = Color.red
        self.exhaleColor = Color.blue
        self.colorFillGradient = .on
        self.inhaleDuration = 5
        self.postInhaleHoldDuration = 0
        self.exhaleDuration = 10
        self.postExhaleHoldDuration = 0
        self.drift = 1.01
        self.overlayOpacity = 0.25
        self.shape = .rectangle
        self.animationMode = .sinusoidal
        self.randomizedTimingInhale = 0
        self.randomizedTimingPostInhaleHold = 0
        self.randomizedTimingExhale = 0
        self.randomizedTimingPostExhaleHold = 0
        self.isAnimating = true
        self.circlePositionX = 0.5
        self.circlePositionY = 0.5
        self.circleMaxSize = 1.0
        self.circleFillMode = .filled
        self.circleMaxScreenFill = 1.0
        self.eyeBlinkColor = Color.black
        self.eyeBlinkSize = 50.0
        self.eyeBlinkDuration = 0.2
        self.eyeBlinkInterval = 3.0
        
        self.backgroundColor = loadColor(forKey: "backgroundColor") ?? Color.clear
        self.inhaleColor = loadColor(forKey: "inhaleColor") ?? Color(red: 1, green: 0, blue: 0)
        self.exhaleColor = loadColor(forKey: "exhaleColor") ?? Color(red: 0, green: 0, blue: 1)
        
        if defaults.object(forKey: "inhaleDuration") != nil {
            self.inhaleDuration = defaults.double(forKey: "inhaleDuration")
        }
        
        if defaults.object(forKey: "postInhaleHoldDuration") != nil {
            self.postInhaleHoldDuration = defaults.double(forKey: "postInhaleHoldDuration")
        }
        
        if defaults.object(forKey: "exhaleDuration") != nil {
            self.exhaleDuration = defaults.double(forKey: "exhaleDuration")
        }
        
        if defaults.object(forKey: "postExhaleHoldDuration") != nil {
            self.postExhaleHoldDuration = defaults.double(forKey: "postExhaleHoldDuration")
        }
        
        if defaults.object(forKey: "drift") != nil {
            self.drift = defaults.double(forKey: "drift")
        }
        
        if defaults.object(forKey: "overlayOpacity") != nil {
            self.overlayOpacity = defaults.double(forKey: "overlayOpacity")
        }
        
        if let savedGradient = defaults.string(forKey: "colorFillGradient"),
           let gradient = ColorFillGradient(rawValue: savedGradient) {
            self.colorFillGradient = gradient
        } else {
            self.colorFillGradient = .on
        }
        
        if let savedShape = defaults.string(forKey: "shape"),
           let shape = AnimationShape(rawValue: savedShape) {
            self.shape = shape
        } else {
            self.shape = .rectangle
        }
        
        if let savedMode = defaults.string(forKey: "animationMode"),
           let mode = AnimationMode(rawValue: savedMode) {
            self.animationMode = mode
        } else {
            self.animationMode = .sinusoidal
        }
        
        if defaults.object(forKey: "randomizedTimingInhale") != nil {
            self.randomizedTimingInhale = defaults.double(forKey: "randomizedTimingInhale")
        }
        
        if defaults.object(forKey: "randomizedTimingPostInhaleHold") != nil {
            self.randomizedTimingPostInhaleHold = defaults.double(forKey: "randomizedTimingPostInhaleHold")
        }
        
        if defaults.object(forKey: "randomizedTimingExhale") != nil {
            self.randomizedTimingExhale = defaults.double(forKey: "randomizedTimingExhale")
        }
        
        if defaults.object(forKey: "randomizedTimingPostExhaleHold") != nil {
            self.randomizedTimingPostExhaleHold = defaults.double(forKey: "randomizedTimingPostExhaleHold")
        }
        
        if defaults.object(forKey: "circlePositionX") != nil {
            self.circlePositionX = defaults.double(forKey: "circlePositionX")
        }
        
        if defaults.object(forKey: "circlePositionY") != nil {
            self.circlePositionY = defaults.double(forKey: "circlePositionY")
        }
        
        if defaults.object(forKey: "circleMaxSize") != nil {
            self.circleMaxSize = defaults.double(forKey: "circleMaxSize")
        }
        
        if let savedFillMode = defaults.string(forKey: "circleFillMode"),
           let fillMode = CircleFillMode(rawValue: savedFillMode) {
            self.circleFillMode = fillMode
        } else {
            self.circleFillMode = .filled
        }
        
        if defaults.object(forKey: "circleMaxScreenFill") != nil {
            self.circleMaxScreenFill = defaults.double(forKey: "circleMaxScreenFill")
        }
        
        self.eyeBlinkColor = loadColor(forKey: "eyeBlinkColor") ?? Color(red: 0, green: 0, blue: 0)
        
        if defaults.object(forKey: "eyeBlinkSize") != nil {
            self.eyeBlinkSize = defaults.double(forKey: "eyeBlinkSize")
        }
        
        if defaults.object(forKey: "eyeBlinkDuration") != nil {
            self.eyeBlinkDuration = defaults.double(forKey: "eyeBlinkDuration")
        }
        
        if defaults.object(forKey: "eyeBlinkInterval") != nil {
            self.eyeBlinkInterval = defaults.double(forKey: "eyeBlinkInterval")
        }
    }
    
    private func saveColor(_ color: Color, forKey key: String) {
        if let cgColor = color.cgColor, let nsColor = NSColor(cgColor: cgColor) {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: nsColor, requiringSecureCoding: false)
            defaults.set(data, forKey: key)
        }
    }
    
    private func loadColor(forKey key: String) -> Color? {
        guard let data = defaults.object(forKey: key) as? Data else {
            return nil
        }
        do {
            if let nsColor = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSColor.self], from: data) as? NSColor {
                return Color(nsColor)
            }
        } catch {
            print("Couldn't read file.")
        }
        return nil
    }
    
    func resetToDefaults() {
        self.backgroundColor = Color.clear
        self.inhaleColor = Color.red
        self.exhaleColor = Color.blue
        self.inhaleDuration = 5
        self.postInhaleHoldDuration = 0
        self.exhaleDuration = 10
        self.postExhaleHoldDuration = 0
        self.drift = 1.01
        self.overlayOpacity = 0.25
        self.colorFillGradient = .on
        self.shape = .rectangle
        self.animationMode = .sinusoidal
        self.randomizedTimingInhale = 0
        self.randomizedTimingPostInhaleHold = 0
        self.randomizedTimingExhale = 0
        self.randomizedTimingPostExhaleHold = 0
        self.circlePositionX = 0.5
        self.circlePositionY = 0.5
        self.circleMaxSize = 1.0
        self.circleFillMode = .filled
        self.circleMaxScreenFill = 1.0
        self.eyeBlinkColor = Color.black
        self.eyeBlinkSize = 50.0
        self.eyeBlinkDuration = 0.2
        self.eyeBlinkInterval = 3.0
        
        let keys = ["backgroundColor", "inhaleColor", "exhaleColor", "inhaleDuration", "postInhaleHoldDuration", "exhaleDuration", "postExhaleHoldDuration", "drift", "overlayOpacity", "colorFillGradient", "shape", "animationMode", "randomizedTimingInhale", "randomizedTimingPostInhaleHold", "randomizedTimingExhale", "randomizedTimingPostExhaleHold", "circlePositionX", "circlePositionY", "circleMaxSize", "circleFillMode", "circleMaxScreenFill", "eyeBlinkColor", "eyeBlinkSize", "eyeBlinkDuration", "eyeBlinkInterval"]
        for key in keys {
            defaults.removeObject(forKey: key)
        }
    }
}

