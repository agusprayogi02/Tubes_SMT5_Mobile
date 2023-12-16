from flask import Flask, jsonify, request, flash, redirect, url_for
import os
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.orm import DeclarativeBase
from werkzeug.utils import secure_filename
from helper import utils
import cv2 as cv

UPLOAD_FOLDER = 'files'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config["SQLALCHEMY_DATABASE_URI"] = "postgresql://user_pg:Akubisa-1@localhost/ml_api"


class Base(DeclarativeBase):
    pass


db = SQLAlchemy(model_class=Base)
db.init_app(app)


def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@app.route('/', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            flash('No file part')
            return redirect(request.url)
        file = request.files['file']
        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename is None or file.filename == '':
            flash('No selected file')
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            return redirect(url_for('download_file', name=filename))
    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form method=post enctype=multipart/form-data>
      <input type=file name=file>
      <input type=submit value=Upload>
    </form>
    '''


@app.route('/download/<name>', methods=['GET'])
def download_file(name):
    # Read image
    img = cv.imread(os.path.join(app.config['UPLOAD_FOLDER'], name))

    # Preprocess image
    img = utils.reflection(img)

    # Extract text
    text = utils.extract_text(img)
    rest = utils.to_data(text)
    if len(rest) == 0:
        return jsonify({'error': 'Data not found'})
    return jsonify(rest)


with app.app_context():
    db.create_all()

if __name__ == "__main__":
    app.run(debug=True)
