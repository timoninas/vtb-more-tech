#!/usr/bin/env python
import base64
import io
from PIL import Image
import torch
from torch import nn
from torchvision import transforms, models

datatransform = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225])
])

classnames = [
    'Volkswagen Tiguan', 'Volkswagen Polo sedan', 'KIA Rio sedan',
    'Hyundai Solaris sedan', 'SKODA OCTAVIA sedan'
]

# device = 'cpu'
device = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
print('Using device:', device)


def build_model(nclasses, hidden_layers=None):
    model = models.wide_resnet50_2(pretrained=False)
    for param in model.parameters():
        param.requires_grad = False
    num_in_features = model.fc.in_features

    csf = nn.Sequential()
    if hidden_layers == None:
        csf.add_module('fc0', nn.Linear(num_in_features, nclasses))
    else:
        layer_sizes = zip(hidden_layers[:-1], hidden_layers[1:])
        csf.add_module('fc0', nn.Linear(num_in_features, hidden_layers[0]))
        csf.add_module('relu0', nn.ReLU())
        csf.add_module('drop0', nn.Dropout(0.4))
        for i, (h1, h2) in enumerate(layer_sizes):
            csf.add_module('fc' + str(i + 1), nn.Linear(h1, h2))
            csf.add_module('relu' + str(i + 1), nn.ReLU())
            csf.add_module('drop' + str(i + 1), nn.Dropout(.5))
        csf.add_module('output', nn.Linear(hidden_layers[-1], nclasses))
    model.fc = csf
    return model


def load_model(fname):
    model = build_model(5, [100])
    model.load_state_dict(torch.load(fname))
    model.eval()
    for param in model.parameters():
        param.requires_grad = False
    return model.to(device)


def string_to_input(base64_string):
    imgdata = base64.b64decode(str(base64_string))
    image = Image.open(io.BytesIO(imgdata)).convert('RGB')
    image = datatransform(image)
    return image.to(device)


def inference(model, input):
    input = string_to_input(input).view(-1, 3, 224, 224)
    with torch.set_grad_enabled(False):
        output = model(input).cpu().data[0].cpu()
    probs = nn.functional.softmax(output).cpu()
    result = {}
    for i, value in enumerate(probs):
        result[classnames[i]] = value.item()
    return result
