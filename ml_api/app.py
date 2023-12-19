from flask import Flask, jsonify, request, flash, redirect
import os
from werkzeug.utils import secure_filename
from helper import utils
import cv2 as cv

UPLOAD_FOLDER = 'files'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER


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
        filename = secure_filename(file.filename)
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        img = cv.imread(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        # Preprocess image
        img = utils.reflection(img)

        # Extract text
        text = utils.extract_text(img)
        rest = utils.to_data(text)
        if len(rest) == 0:
            return jsonify({'error': 'Data not found'})
        return jsonify(rest)
    return jsonify({'error': 'Jenis File tidak didukung'})


if __name__ == "__main__":
    app.run(debug=True)
