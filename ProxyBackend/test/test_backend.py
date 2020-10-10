#!/usr/bin/env python
import sys
import requests
import base64
import json
import time

baseUrl = sys.argv[1]
headers = {
    'x-ibm-client-id': "28a5288c315b4bee1552fb20503e4cd2",
    'content-type': "application/json",
    'accept': "application/json"
}

carLoan = {
    "comment": "Комментарий",
    "customer_party": {
        "email": "apetrovich@example.com",
        "income_amount": 140000,
        "person": {
            "birth_date_time": "1981-11-01",
            "birth_place": "г. Воронеж",
            "family_name": "Иванов",
            "first_name": "Иван",
            "gender": "male",
            "middle_name": "Иванович",
            "nationality_country_code": "RU"
        },
        "phone": "+99999999999"
    },
    "datetime": "2020-10-10T08:15:47Z",
    "interest_rate": 15.7,
    "requested_amount": 300000,
    "requested_term": 36,
    "trade_mark": "Nissan",
    "vehicle_cost": 600000
}

calculate = {
    "clientTypes": ["ac43d7e4-cd8c-4f6f-b18a-5ccbc1356f75"],
    "cost":
    850000,
    "initialFee":
    200000,
    "kaskoValue":
    24211934,
    "language":
    "en",
    "residualPayment":
    55.3469914,
    "settingsName":
    "Haval",
    "specialConditions": [
        "57ba0183-5988-4137-86a6-3d30a4ed8dc9",
        "b907b476-5a26-4b25-b9c0-8091e9d5c65f",
        "cbfc4ef3-af70-4182-8cf6-e73f361d1e68"
    ],
    "term":
    5
}

paymentsGraph = {
    "contractRate": 10.1,
    "lastPayment": 66.79349838,
    "loanAmount": 1000000,
    "payment": 50000,
    "term": 5
}


def testSettings():
    url = baseUrl + '/settings'
    params = {'language': 'ru-RU', 'name': 'Haval'}
    print("Test", url)
    res = requests.get(url, headers=headers, params=params)
    if res.status_code == 200:
        print(url, "ok")
    print(res.status_code)
    print(res.content)
    print()


def testMarketplace():
    url = baseUrl + '/marketplace'
    print("Test", url)
    res = requests.get(url, headers=headers)
    if res.status_code == 200:
        print(url, "ok")
    print(res.status_code)
    print(res.content[:80])
    print()


def testCarRecognize():
    url = baseUrl + '/car-recognize'
    print("Test", url)
    with open('test.jpeg', 'rb') as fd:
        data = base64.b64encode(fd.read())
    req_data = json.dumps({'content': data.decode()})
    res = requests.post(url, req_data, headers=headers)
    if res.status_code == 200:
        print(url, "ok")
    print(res.status_code)
    print(res.content)
    print()


def testCarLoan():
    url = baseUrl + '/carloan'
    print("Test", url)
    req_data = json.dumps(carLoan)
    res = requests.post(url, req_data, headers=headers)
    if res.status_code == 200:
        print(url, "ok")
    print(res.status_code)
    print(res.content)
    print()


def testCalculate():
    url = baseUrl + '/calculate'
    print("Test", url)
    req_data = json.dumps(calculate)
    res = requests.post(url, req_data, headers=headers)
    if res.status_code == 200:
        print(url, "ok")
    print(res.status_code)
    print(res.content)
    print()


def testPaymentsGraph():
    url = baseUrl + '/payments-graph'
    print("Test", url)
    req_data = json.dumps(paymentsGraph)
    res = requests.post(url, req_data, headers=headers)
    if res.status_code == 200:
        print(url, "ok")
    print(res.status_code)
    print(res.content)
    print()


if __name__ == '__main__':
    testCarRecognize()
    time.sleep(1)
    testSettings()
    time.sleep(1)
    testMarketplace()
    time.sleep(1)
    testCarLoan()
    time.sleep(1)
    testCalculate()
    time.sleep(1)
    testPaymentsGraph()
