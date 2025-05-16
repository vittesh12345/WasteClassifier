# 🗑️ WasteClassifier

A simple deep learning project that classifies images of waste as **organic** or **recyclable** using a Convolutional Neural Network (CNN) built with TensorFlow and Keras.

---

## 🧠 Model Overview

- Binary image classification: **Organic** vs **Recyclable**
- Custom Convolutional Neural Network (CNN)
- Trained on a labeled dataset of waste images
- Built using **TensorFlow** and **Keras**

---

## 📁 Project Structure

WasteClassifier/
├── WasteClassifier.ipynb # Jupyter notebook for model training and testing
├── waste_classifier_model.h5 # Trained model file
├── Dataset/ # Folder for training/test images (not included)
├── sample_output.png # Sample prediction result image
└── README.md # Project documentation

yaml
Copy
Edit

---

## 📦 Requirements

Install the necessary Python packages:

```bash
pip install tensorflow numpy matplotlib scikit-learn
🚀 Getting Started
Clone the repository:

bash
Copy
Edit
git clone https://github.com/vittesh12345/WasteClassifier.git
cd WasteClassifier
Launch the notebook:

bash
Copy
Edit
jupyter notebook WasteClassifier.ipynb
🔍 Example Inference
To use the trained model on your own image:

python
Copy
Edit
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image
import numpy as np

model = load_model('waste_classifier_model.h5')

img = image.load_img('your_image.jpg', target_size=(224, 224))
img_array = image.img_to_array(img) / 255.0
img_array = np.expand_dims(img_array, axis=0)

prediction = model.predict(img_array)

if prediction[0][0] > 0.5:
    print("Recyclable Waste")
else:
    print("Organic Waste")
✅ To-Do
 Improve model performance with data augmentation

 Add transfer learning with MobileNet or ResNet

 Create a web interface using Streamlit or Flask

 Deploy as a mobile app (e.g. with TFLite)

