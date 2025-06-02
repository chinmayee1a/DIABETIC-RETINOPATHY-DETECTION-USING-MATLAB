from flask import Flask, request, jsonify
import matlab.engine

app = Flask(__name__)

# Start MATLAB engine
eng = matlab.engine.start_matlab()

@app.route('/processImage', methods=['POST'])
def process_image():
    # Check if an image file is provided
    if 'image' not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    # Save the uploaded file
    file = request.files['image']
    filepath = f"./{file.filename}"
    file.save(filepath)

    # Call MATLAB function for diabetic retinopathy detection
    try:
        severity = eng.detectDiabeticRetinopathy(filepath)
        return jsonify({"severity": severity})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(port=5000)
