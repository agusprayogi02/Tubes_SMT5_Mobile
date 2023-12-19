import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import socket


def setup_ip():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)

    # initializations
    cred = credentials.Certificate(
        'penilaian-blt-uta-firebase-adminsdk-7l6nb-38142e407d.json')
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    # adding first data
    doc_ref = db.collection('base_url').document('URLKU')

    doc_ref.set({
        'url': f'http://{ip_address}:8080/'
    })
    print(ip_address)
