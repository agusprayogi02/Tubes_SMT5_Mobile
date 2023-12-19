import cv2 as cv
from matplotlib import pyplot as plt
import numpy as np
import pytesseract


def toRGB(img):
    return cv.cvtColor(img, cv.COLOR_BGR2RGB)


def cv2_imshow(img, title='Image', size=None):
    img = cv.cvtColor(img, cv.COLOR_BGR2RGB)
    if size is not None:
        plt.figure(figsize=size)
    plt.imshow(img)
    plt.title(title)
    plt.show()

# function to order points to proper rectangle


def order_points(pts):
    # initialzie a list of coordinates that will be ordered
    # such that the first entry in the list is the top-left,
    # the second entry is the top-right, the third is the
    # bottom-right, and the fourth is the bottom-left
    rect = np.zeros((4, 2), dtype="float32")

    # the top-left point will have the smallest sum, whereas
    # the bottom-right point will have the largest sum
    s = pts.sum(axis=1)
    rect[0] = pts[np.argmin(s)]
    rect[2] = pts[np.argmax(s)]

    # now, compute the difference between the points, the
    # top-right point will have the smallest difference,
    # whereas the bottom-left will have the largest difference
    diff = np.diff(pts, axis=1)
    rect[1] = pts[np.argmin(diff)]
    rect[3] = pts[np.argmax(diff)]

    # return the ordered coordinates
    return rect


def detect_contour(edged):
    contours, _ = cv.findContours(
        edged, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE)
    contours = sorted(contours, key=cv.contourArea, reverse=True)
    return max(contours, key=cv.contourArea)


def reflection(img):
    hsv_image = cv.cvtColor(img, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv_image)

    clahe = cv.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
    v = clahe.apply(v)

    hsv_image = cv.merge([h, s, v])
    return cv.cvtColor(hsv_image, cv.COLOR_HSV2BGR)


def four_point_transform(image, pts):
    # obtain a consistent order of the points and unpack them
    # individually
    rect = order_points(pts)

    # # multiply the rectangle by the original ratio
    # rect *= ratio

    (tl, tr, br, bl) = rect

    # compute the width of the new image, which will be the
    # maximum distance between bottom-right and bottom-left
    # x-coordiates or the top-right and top-left x-coordinates
    widthA = np.sqrt(((br[0] - bl[0]) ** 2) + ((br[1] - bl[1]) ** 2))
    widthB = np.sqrt(((tr[0] - tl[0]) ** 2) + ((tr[1] - tl[1]) ** 2))
    maxWidth = max(int(widthA), int(widthB))

    # compute the height of the new image, which will be the
    # maximum distance between the top-right and bottom-right
    # y-coordinates or the top-left and bottom-left y-coordinates
    heightA = np.sqrt(((tr[0] - br[0]) ** 2) + ((tr[1] - br[1]) ** 2))
    heightB = np.sqrt(((tl[0] - bl[0]) ** 2) + ((tl[1] - bl[1]) ** 2))
    maxHeight = max(int(heightA), int(heightB))

    # now that we have the dimensions of the new image, construct
    # the set of destination points to obtain a "birds eye view",
    # (i.e. top-down view) of the image, again specifying points
    # in the top-left, top-right, bottom-right, and bottom-left
    # order
    dst = np.array([
        [0, 0],
        [maxWidth - 1, 0],
        [maxWidth - 1, maxHeight - 1],
        [0, maxHeight - 1]], dtype="float32")

    # compute the perspective transform matrix and then apply it
    M = cv.getPerspectiveTransform(rect, dst)
    warped = cv.warpPerspective(image, M, (maxWidth, maxHeight))

    # return the warped image
    return warped


def findLargestCountours(cntList, cntWidths):
    newCntList = []
    newCntWidths = []

    # finding 1st largest rectangle
    first_largest_cnt_pos = cntWidths.index(max(cntWidths))

    # adding it in new
    newCntList.append(cntList[first_largest_cnt_pos])
    newCntWidths.append(cntWidths[first_largest_cnt_pos])

    # removing it from old
    cntList.pop(first_largest_cnt_pos)
    cntWidths.pop(first_largest_cnt_pos)

    # finding second largest rectangle
    seccond_largest_cnt_pos = cntWidths.index(max(cntWidths))

    # adding it in new
    newCntList.append(cntList[seccond_largest_cnt_pos])
    newCntWidths.append(cntWidths[seccond_largest_cnt_pos])

    # removing it from old
    cntList.pop(seccond_largest_cnt_pos)
    cntWidths.pop(seccond_largest_cnt_pos)

    # print('Old Screen Dimentions filtered', cntWidths)
    # print('Screen Dimentions filtered', newCntWidths)
    return newCntList, newCntWidths


def extract_text(img) -> list:
    # Preprocess image
    img = reflection(img)
    img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

    # Extract text
    text = pytesseract.image_to_string(img, lang='ind')
    txt = []
    for word in str(text).split('\n'):
        # print(word)
        if (len(word.strip()) == 0):
            continue
        word = word.replace(':', '').replace(
            '\"', '').replace('(', '').replace(')', '').replace('"', '').replace(';', '').replace('?', '').replace('!', '').replace('\'', '').replace('«', '')
        txt.append(word.strip())
    return txt


def to_data(text: list):
    data = {}
    for i in range(len(text)):
        if str(text[i]).isnumeric():
            data['nim'] = text[i]
            if text[i+1] is None:
                continue
            data['nama'] = text[i+1]
            data['lahir'] = text[i+2]
            data['prodi'] = text[i+3]
            data['dusun'] = text[i+4]
            data['jalan'] = text[i+5]
            data['kota'] = text[i+6]
    return data


def randomString(stringLength=10):
    import random
    import string
    letters = string.ascii_lowercase
    return ''.join(random.choice(letters) for i in range(stringLength))


def faceDetector(img):
    gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    face_cascade = cv.CascadeClassifier(
        'static/haarcascade_frontalface_alt.xml')
    faces = face_cascade.detectMultiScale(gray, 1.3, 5)
    if len(faces) == 0:
        return None
    (x, y, w, h) = faces[0]
    y -= int(h*0.2)
    h += int(h*0.4)
    x -= int(w*0.1)
    w += int(w*0.2)
    return img[y:y+h, x:x+w]
