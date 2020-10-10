package main

import (
	"encoding/json"
	"fmt"
	"sync"
	"time"

	"github.com/levigross/grequests"
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
	zap.S().Debug("Api locked")
}

func (api *VtbApi) unlock() {
	go func() {
		time.Sleep(time.Second)
		api.Mutex.Unlock()
		zap.S().Debug("Api unlocked")
	}()
}

func (api *VtbApi) headers() map[string]string {
	return map[string]string{
		"x-ibm-client-id": "28a5288c315b4bee1552fb20503e4cd2",
		"content-type":    "application/json",
		"accept":          "application/json"}
}

func (api *VtbApi) generalPost(apiPath string, body Unknown) (Unknown, error) {
	api.lock()
	defer api.unlock()
	url := api.BaseUrl + apiPath
	zap.S().Debugf("POST: %v", url)
	resp, err := grequests.Post(url,
		&grequests.RequestOptions{
			Headers:     api.headers(),
			RequestBody: body.Reader(),
		},
	)
	if err != nil {
		zap.S().Debugf("Api error: %v", err)
		return Unknown{}, err
	}
	zap.S().Debugf("Api success: %v", resp)
	if resp.StatusCode != 200 {
		return Unknown{}, fmt.Errorf("Api returned %d status: %v", resp.StatusCode, resp.Bytes())
	}
	return resp.Bytes(), nil
}

func (api *VtbApi) generalGet(apiPath string, params map[string]string) (Unknown, error) {
	api.lock()
	defer api.unlock()
	url := api.BaseUrl + apiPath
	resp, err := grequests.Get(url,
		&grequests.RequestOptions{
			Params:  params,
			Headers: api.headers(),
		},
	)
	if err != nil {
		zap.S().Debugf("Api error: %v", err)
		return Unknown{}, err
	}
	zap.S().Debugf("Api success: %d", resp.StatusCode)
	if resp.StatusCode != 200 {
		return Unknown{}, fmt.Errorf("Api returned %d status: %v", resp.StatusCode, resp.Bytes())
	}
	return resp.Bytes(), nil
}

func (api *VtbApi) CarRecognize(image CarImage) (CarResponse, error) {
	body, err := json.Marshal(image)
	if err != nil {
		return CarResponse{}, err
	}
	body, err = api.generalPost(apiCarRecognizePath, body)
	carresp := CarResponse{}
	err = json.Unmarshal(body, &carresp)
	if err != nil {
		return CarResponse{}, fmt.Errorf("Parse json error %v", err)
	}
	return carresp, nil
}

func (api *VtbApi) Marketplace() (Marketplace, error) {
	body, err := api.generalGet(apiMarketplacePath, map[string]string{})
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
	return api.generalPost(apiCarLoanPath, body)
}

func (api *VtbApi) Calculate(body Unknown) (Unknown, error) {
	return api.generalPost(apiCalculatePath, body)
}

func (api *VtbApi) PaymentsGraph(body Unknown) (Unknown, error) {
	return api.generalPost(apiPaymentGraphPath, body)
}

func (api *VtbApi) Settings(name string, language string) (Unknown, error) {
	params := map[string]string{"name": name, "language": language}
	return api.generalGet(apiSettingsPath, params)
}
