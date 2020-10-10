#  Задача для ML-участников

[Ссылка на папку с моделями](https://drive.google.com/drive/folders/1-6eTYQaBjS6u5t2psN8Jdj5kQC_IcG7a?usp=sharing)

## Запуск сервера

```bash
git clone https://github.com/timoninas/vtb-more-tech
cd vtb-more-tech
git checkout ml
pip install -r requirements.txt
python ./serve_model.py PATH_TO_MODEL_WEIGHTS
```

API URL: `http://127.0.0.1:5000/car-recognize`

## Запуск тестов

```bash
python ./test_model.py API_URL DATA_DIR
```
