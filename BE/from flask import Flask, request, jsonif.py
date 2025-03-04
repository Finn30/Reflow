from flask import Flask, request, jsonify
import pytesseract
pytesseract.pytesseract.tesseract_cmd = r"C:\Program Files\Tesseract-OCR\tesseract.exe"
from PIL import Image
import io
import os

app = Flask(__name__)

# Buat folder untuk menyimpan gambar yang diunggah
UPLOAD_FOLDER = 'uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/ocr', methods=['POST'])
def ocr():
    if 'image' not in request.files:
        return jsonify({'error': 'No image uploaded'}), 400
    
    image_file = request.files['image']
    image_path = os.path.join(UPLOAD_FOLDER, image_file.filename)
    image_file.save(image_path)
    
    image = Image.open(image_path)
    extracted_text = pytesseract.image_to_string(image, lang='eng')
    
    nik = extract_nik(extracted_text)
    nama = extract_nama(extracted_text)
    tanggal_lahir = extract_tanggal_lahir(extracted_text)
    
    return jsonify({
        'nik': nik,
        'nama': nama,
        'tanggal_lahir': tanggal_lahir
    })

def extract_nik(text):
    import re
    match = re.search(r'\b\d{16}\b', text)
    return match.group(0) if match else ""

def extract_nama(text):
    import re
    match = re.search(r'Nama\s*:\s*(.*)', text)
    return match.group(1).strip() if match else ""

def extract_tanggal_lahir(text):
    import re
    match = re.search(r'\b\d{2}-\d{2}-\d{4}\b', text)
    return match.group(0) if match else ""

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)