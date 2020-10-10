package main

import (
	"encoding/json"
	"fmt"
	"sync"

	"go.uber.org/zap"
)

type FlaskApi struct {
	BaseUrl string
	Mutex   *sync.Mutex
}

func NewFlaskApi(url string) *FlaskApi {
	return &FlaskApi{
		BaseUrl: url,
		Mutex:   &sync.Mutex{},
	}
}

func (api FlaskApi) getUrl(endpoint string) string {
	return api.BaseUrl + endpoint
}

func (api *FlaskApi) lock() {
	api.Mutex.Lock()
	zap.S().Debug("FlaskApi locked")
}

func (api *FlaskApi) unlock() {
	api.Mutex.Unlock()
	zap.S().Debug("FlaskApi unlocked")
}

func (api FlaskApi) headers() map[string]string {
	return map[string]string{
		"content-type": "application/json",
		"accept":       "application/json"}
}

func (api *FlaskApi) CarRecognize(image CarImage) (CarResponse, error) {
	body, err := json.Marshal(image)
	if err != nil {
		return CarResponse{}, err
	}
	body, err = generalPost(api, apiCarRecognizePath, body)
	carresp := CarResponse{}
	err = json.Unmarshal(body, &carresp)
	if err != nil {
		return CarResponse{}, fmt.Errorf("Parse json error %v", err)
	}
	return carresp, nil
}

func (api *FlaskApi) Marketplace() (Marketplace, error) {
	return Marketplace{}, fmt.Errorf("Not implemented")
}

func (api *FlaskApi) CarLoan(body Unknown) (Unknown, error) {
	return Unknown{}, fmt.Errorf("Not implemented")
}

func (api *FlaskApi) Calculate(body Unknown) (Unknown, error) {
	return Unknown{}, fmt.Errorf("Not implemented")
}

func (api *FlaskApi) PaymentsGraph(body Unknown) (Unknown, error) {
	return Unknown{}, fmt.Errorf("Not implemented")
}

func (api *FlaskApi) Settings(name string, language string) (Unknown, error) {
	return Unknown{}, fmt.Errorf("Not implemented")
}
