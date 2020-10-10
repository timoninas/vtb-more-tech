#!/usr/bin/env python

import sys
import base64
import json
import time
import os
from collections import Counter
import requests
from tqdm.auto import tqdm


def get_preds(url, fname):
    with open(fname, 'rb') as fd:
        data = base64.b64encode(fd.read())
    req_data = json.dumps({'content': data.decode()})
    t1 = time.time()
    response = requests.post(url, req_data)
    t2 = time.time()
    result = json.loads(response.content)
    return result['probabilities'], t2 - t1


def get_class(preds):
    return max(preds, key=lambda x: preds[x])


if __name__ == '__main__':
    api_url = sys.argv[1]
    data_dir = sys.argv[2]
    classes = os.listdir(data_dir)
    for cls in tqdm(classes):
        folder = os.path.join(data_dir, cls)
        count = 0
        correct = 0
        counter = Counter()
        for img_name in tqdm(os.listdir(folder), leave=False):
            img_path = os.path.join(folder, img_name)
            try:
                preds, t = get_preds(api_url, img_path)
                pred_cls = get_class(preds)
                counter[pred_cls] += 1
                correct += pred_cls == cls
                count += 1
            except KeyboardInterrupt:
                sys.exit(0)
            except BaseException as err:
                print(img_path, err)
        print(f'Results for {cls}')
        print(f'Correct {correct} from {count} answers: {correct / count}')
        print(counter)
