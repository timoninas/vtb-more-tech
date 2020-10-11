#!/usr/bin/env python
import json
import base64
import pickle
import io
import sys
from flask import Flask, request, jsonify
import utils

app = Flask(__name__)
model = utils.load_model(sys.argv[1])


@app.route('/car-recognize', methods=['POST'])
def car_recognize():
    try:
        data = json.loads(request.data)
        preds = utils.inference(model, data['content'])
        response = {'probabilities': preds}
        return jsonify(response)

    except BaseException as err:
        print(err)
        raise (err)


app.run()
