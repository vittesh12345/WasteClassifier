import SwiftUI
import UIKit
import CoreML
import Vision
import PhotosUI

struct ContentView: View {
    @State private var image: Image? = nil
    @State private var pickedImage: UIImage? = nil
    @State private var predictionLabel: String = "Select an image to classify"
    @State private var recyclabilityLabel: String = "Recyclability: Unknown"
    
    // Load your CoreML model (WasteClassifier_1)
    private let model: VNCoreMLModel = {
        do {
            let config = MLModelConfiguration()
            let mlModel = try WasteClassifier_1(configuration: config).model
            return try VNCoreMLModel(for: mlModel)
        } catch {
            fatalError("Error loading model: \(error)")
        }
    }()
    
    var body: some View {
        VStack {
            Text("Waste Classification")
                .font(.largeTitle)
                .padding()
            
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .clipped()
                    .padding()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 300, height: 300)
                    .padding()
            }
            
            Text(predictionLabel)
                .font(.title2)
                .padding()
            
            Text(recyclabilityLabel)
                .font(.title2)
                .padding()
            
            HStack {
                Button(action: {
                    pickImage()
                }) {
                    Text("Pick an Image")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    classifyImage()
                }) {
                    Text("Classify Image")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
    
    // Present the image picker using PHPickerViewController
    private func pickImage() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = makeCoordinator()
        
        // Present the picker from the top-most view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(picker, animated: true, completion: nil)
        }
    }
    
    private func classifyImage() {
        guard let pickedImage = pickedImage else { return }
        
        // Convert the UIImage to a CIImage
        guard let ciImage = CIImage(image: pickedImage) else {
            predictionLabel = "Error processing image."
            recyclabilityLabel = "Recyclability: Unknown"
            return
        }
        
        // Create and perform the VNCoreMLRequest
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                predictionLabel = "Unable to classify image."
                recyclabilityLabel = "Recyclability: Unknown"
                return
            }
            
            DispatchQueue.main.async {
                predictionLabel = "Prediction: \(topResult.identifier) with confidence \(Int(topResult.confidence * 100))%"
                checkRecyclability(for: topResult.identifier)
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            predictionLabel = "Error during classification."
            recyclabilityLabel = "Recyclability: Unknown"
        }
    }
    
    // Simple recyclability check based on the prediction
    private func checkRecyclability(for item: String) {
        switch item.lowercased() {
        case "paper":
            recyclabilityLabel = "Recyclability: Recyclable"
        case "metal":
            recyclabilityLabel = "Recyclability: Recyclable"
        case "plastic":
            recyclabilityLabel = "Recyclability: Check local guidelines"
        default:
            recyclabilityLabel = "Recyclability: Unknown"
        }
    }
    
    // Coordinator class to handle PHPickerViewControllerDelegate methods
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ContentView
        
        init(parent: ContentView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let result = results.first {
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    DispatchQueue.main.async {
                        if let uiImage = object as? UIImage {
                            self.parent.pickedImage = uiImage
                            self.parent.image = Image(uiImage: uiImage)
                        }
                    }
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // Create a coordinator instance
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

