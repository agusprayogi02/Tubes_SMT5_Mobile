from random import randint
from flask import Flask, jsonify, request, flash, redirect, send_from_directory
import os
from werkzeug.utils import secure_filename
from helper import utils
import cv2 as cv
from waitress import serve

UPLOAD_FOLDER = 'files'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['CUSTOM_STATIC_PATH'] = 'static'


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/upload', methods=['POST'])
def upload_file():
    # check if the post request has the file part
    if 'file' not in request.files:
        flash('No file part')
        return redirect(request.url)
    file = request.files['file']
    # If the user does not select a file, the browser submits an
    # empty file without a filename.
    if file.filename is None or file.filename == '':
        flash('No selected file')
        return jsonify({'error': 'No selected file'})
    if file and allowed_file(file.filename):
        filename = f'file_{utils.randomString()}_{secure_filename(file.filename)}'
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        img = cv.imread(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        # Preprocess image
        img = utils.reflection(img)

        # face detection
        face = utils.faceDetector(img)
        if face is None:
            return jsonify({'error': 'Face not found'})
        imgName = f'face_{utils.randomString(20)}.jpg'
        cv.imwrite(os.path.join(app.config['UPLOAD_FOLDER'], imgName), face)

        # Extract text
        text = utils.extract_text(img)
        rest = utils.to_data(text)
        rest['foto'] = f"f/{imgName}"
        if len(rest) == 0:
            return jsonify({'error': 'Data not found'})
        return jsonify(rest)
    return jsonify({'error': 'Jenis File tidak didukung'})


@app.route('/f/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)


if __name__ == "__main__":
   serve(app, host="0.0.0.0", port=8080)
