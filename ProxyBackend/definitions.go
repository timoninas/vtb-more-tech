package main

import (
	"bytes"
	"io"
)

type Api interface {
	CarRecognize(image CarImage) (CarResponse, error)
	Marketplace() (Marketplace, error)
	CarLoan(body Unknown) (Unknown, error)
	Calculate(body Unknown) (Unknown, error)
	PaymentsGraph(body Unknown) (Unknown, error)
	Settings(name string, language string) (Unknown, error)
}

const (
	apiCarRecognizePath = "/car-recognize"
	apiMarketplacePath  = "/marketplace"
	apiCarLoanPath      = "/carloan"
	apiCalculatePath    = "/calculate"
	apiPaymentGraphPath = "/payments-graph"
	apiSettingsPath     = "/settings"
	apiKeyHeader        = "X-IBM-Client-Id"
)

type Unknown []byte

func (b Unknown) Bytes() []byte {
	return b
}

func (b Unknown) Reader() io.Reader {
	return bytes.NewReader(b)
}

type Marketplace struct {
	List []CarBrand `json:"list"`
}

func (market *Marketplace) Extend(another Marketplace) {
	if market.List == nil {
		market.List = []CarBrand{}
	}
	if another.List == nil {
		return
	}
	market.List = append(market.List, another.List...)
}

type CarBrand struct {
	Absentee           bool       `json:"absentee"`
	Alias              string     `json:"alias"`
	Country            Country    `json:"country"`
	CurrentCarCount    int        `json:"currentCarCount"`
	CurrentModelsTotal int        `json:"currentModelsTotal"`
	Generations        []string   `json:"generations"`
	Id                 int        `json:"id"`
	IsOutbound         bool       `json:"isOutbound"`
	Logo               string     `json:"logo"`
	Models             []CarModel `json:"models"`
	Title              string     `json:"title"`
	TitleRus           string     `json:"titleRus"`
}

type Country struct {
	Code  string `json:"code"`
	Id    int    `json:"id"`
	Title string `json:"title"`
}

type CarModel struct {
	Absentee             bool                                 `json:"absentee"`
	Alias                string                               `json:"alias"`
	Bodies               []CarBody                            `json:"bodies"`
	Brand                CarBrandOnly                         `json:"brand"`
	CarId                string                               `json:"carId"`
	ColorsCount          int                                  `json:"colorsCount"`
	Count                int                                  `json:"count"`
	HasSpecialPrice      bool                                 `json:"hasSpecialPrice"`
	Id                   int                                  `json:"id"`
	MetallicPay          int                                  `json:"metallicPay"`
	MinPrice             int                                  `json:"minprice"`
	Model                CarModelModel                        `json:"model"`
	OwnTitle             string                               `json:"ownTitle"`
	PearlPay             int                                  `json:"pearlPay"`
	Photo                string                               `json:"photo"`
	Prefix               string                               `json:"prefix"`
	PremiumPriceSpecials []string                             `json:"premiumPriceSpecials"`
	RenderPhotos         map[string]map[string]CarRenderPhoto `json:"renderPhotos"`
	SizesPhotos          map[string]string                    `json:"sizesPhotos"`
	SpecmetallicPay      int                                  `json:"specmetallicPay"`
	Title                string                               `json:"title"`
	TitleRus             string                               `json:"titleRus"`
	TransportType        TransportType                        `json:"transportType"`
}

type CarModelModel struct {
	Absentee bool   `json:"absentee"`
	Alias    string `json:"alias"`
	Id       int    `json:"id"`
	Prefix   string `json:"prefix"`
	Title    string `json:"title"`
	TitleRus string `json:"titleRus"`
}

type CarRenderPhoto struct {
	Height int    `json:"height"`
	Path   string `json:"path"`
	Width  int    `json:"width"`
}

type TransportType struct {
	Alias string `json:"alias"`
	Id    int    `json:"id"`
	Title string `json:"title"`
}

type CarBrandOnly struct {
	Absentee   bool    `json:"absentee"`
	Alias      string  `json:"alias"`
	Country    Country `json:"country"`
	Id         int     `json:"id"`
	IsOutbound bool    `json:"isOutbound"`
	Logo       string  `json:"logo"`
	Title      string  `json:"title"`
	TitleRus   string  `json:"titleRus"`
}

type CarBody struct {
	Alias     string `json:"alias"`
	Doors     int    `json:"doors"`
	Photo     string `json:"photo"`
	Title     string `json:"title"`
	Type      string `json:"type"`
	TypeTitle string `json:"typeTitle"`
}

type CarResponse struct {
	Probabilities map[string]float64 `json:"probabilities"`
}

func (resp *CarResponse) Extend(other CarResponse) {
	if resp.Probabilities == nil {
		resp.Probabilities = map[string]float64{}
	}
	if other.Probabilities == nil {
		return
	}
	for key, val := range other.Probabilities {
		resp.Probabilities[key] = val
	}
}

type CarImage struct {
	Content string `json:"content"`
}

type ErrorMessage struct {
	Error   bool   `json:"error"`
	Message string `json:"message"`
}
