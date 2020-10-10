package main

import (
	"encoding/json"
	"fmt"
	"sync"
	"time"

	"go.uber.org/zap"
)

type VtbApi struct {
	ApiKey  string
	BaseUrl string
	Mutex   *sync.Mutex
}

func NewVtbApi(key string, url string) *VtbApi {
	return &VtbApi{
		ApiKey:  key,
		BaseUrl: url,
		Mutex:   &sync.Mutex{},
	}
}

func (api *VtbApi) lock() {
	api.Mutex.Lock()
	zap.S().Debug("VtbApi locked")
}

func (api *VtbApi) unlock() {
	go func() {
		time.Sleep(time.Second)
		api.Mutex.Unlock()
		zap.S().Debug("VtbApi unlocked")
	}()
}

func (api VtbApi) getUrl(endpoint string) string {
	return api.BaseUrl + endpoint
}

func (api VtbApi) headers() map[string]string {
	return map[string]string{
		"x-ibm-client-id": api.ApiKey,
		"content-type":    "application/json",
		"accept":          "application/json"}
}

func (api *VtbApi) CarRecognize(image CarImage) (CarResponse, error) {
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

func (api *VtbApi) Marketplace() (Marketplace, error) {
	body, err := generalGet(api, apiMarketplacePath, map[string]string{})
	if err != nil {
		return Marketplace{}, fmt.Errorf("Get %v", err)
	}
	market := Marketplace{}
	err = json.Unmarshal(body, &market)
	if err != nil {
		return Marketplace{}, fmt.Errorf("Parse json error %v", err)
	}
	return market, nil
}

func (api *VtbApi) CarLoan(body Unknown) (Unknown, error) {
	return generalPost(api, apiCarLoanPath, body)
}

func (api *VtbApi) Calculate(body Unknown) (Unknown, error) {
	return generalPost(api, apiCalculatePath, body)
}

func (api *VtbApi) PaymentsGraph(body Unknown) (Unknown, error) {
	return generalPost(api, apiPaymentGraphPath, body)
}

func (api *VtbApi) Settings(name string, language string) (Unknown, error) {
	params := map[string]string{"name": name, "language": language}
	return generalGet(api, apiSettingsPath, params)
}
