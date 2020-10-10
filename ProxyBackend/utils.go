package main

import (
	"fmt"

	"github.com/levigross/grequests"
	"go.uber.org/zap"
)

type httpApi interface {
	headers() map[string]string
	getUrl(endpoint string) string
	lock()
	unlock()
}

func generalPost(api httpApi, apiPath string, body Unknown) (Unknown, error) {
	api.lock()
	defer api.unlock()
	url := api.getUrl(apiPath)
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
	zap.S().Debugf("Api success: %d", resp.StatusCode)
	if resp.StatusCode != 200 {
		return Unknown{}, fmt.Errorf("Api returned %d status: %v", resp.StatusCode, resp.Bytes())
	}
	return resp.Bytes(), nil
}

func generalGet(api httpApi, apiPath string, params map[string]string) (Unknown, error) {
	api.lock()
	defer api.unlock()
	url := api.getUrl(apiPath)
	zap.S().Debugf("GET: %v", url)
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
