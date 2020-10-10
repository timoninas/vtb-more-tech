package main

import (
	"encoding/json"
	"fmt"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"go.uber.org/zap"
)

const (
	vtbApiKey    = "28a5288c315b4bee1552fb20503e4cd2"
	vtbBaseUrl   = "https://gw.hackathon.vtb.ru/vtb/hackathon"
	flaskBaseUrl = "http://84.201.167.60:8080"
	apiPath      = "/api"
)

var apis = []Api{
	NewVtbApi(vtbApiKey, vtbBaseUrl),
	NewFlaskApi(flaskBaseUrl),
}

func apiCarLoanHandler(ctx *fiber.Ctx) error {
	body := ctx.Body()
	err := fmt.Errorf("Api error")
	for _, api := range apis {
		tmp, err := api.CarLoan(body)
		if err == nil {
			return ctx.Send(tmp)
		}
	}
	return err
}

func apiCalculateHandler(ctx *fiber.Ctx) error {
	body := ctx.Body()
	err := fmt.Errorf("Api error")
	for _, api := range apis {
		tmp, err := api.Calculate(body)
		if err == nil {
			return ctx.Send(tmp)
		}
	}
	return err
}

func apiPaymentsGraphHandler(ctx *fiber.Ctx) error {
	body := ctx.Body()
	err := fmt.Errorf("Api error")
	for _, api := range apis {
		tmp, err := api.PaymentsGraph(body)
		if err == nil {
			return ctx.Send(tmp)
		}
	}
	return err
}

func apiMarketplaceHandler(ctx *fiber.Ctx) error {
	err := fmt.Errorf("Api error")
	res := Marketplace{}
	valid := false
	for _, api := range apis {
		var tmp Marketplace
		tmp, err = api.Marketplace()
		if err == nil {
			valid = true
			res.Extend(tmp)
		}
	}
	if valid {
		return ctx.JSON(res)
	}
	return err
}

func apiSettingsHandler(ctx *fiber.Ctx) error {
	err := fmt.Errorf("Api error")
	lang := ctx.Query("language", "ru-RU")
	name := ctx.Query("name", "Haval")
	for _, api := range apis {
		tmp, err := api.Settings(name, lang)
		if err == nil {
			return ctx.Send(tmp)
		}
	}
	return err
}

func apiCarRecognizeHandler(ctx *fiber.Ctx) error {
	resp := CarResponse{}
	image := CarImage{}
	valid := false
	err := json.Unmarshal(ctx.Body(), &image)
	if err != nil {
		return err
	}
	for _, api := range apis {
		tmp, err := api.CarRecognize(image)
		if err == nil {
			resp.Extend(tmp)
			valid = true
		}
	}
	if valid {
		return ctx.JSON(resp)
	} else {
		return err
	}
}

func syncLogger(ctx *fiber.Ctx) (err error) {
	defer zap.S().Sync()
	fmt.Println(ctx.BaseURL())
	err = ctx.Next()
	return
}

func errorHandler(ctx *fiber.Ctx) error {
	err := ctx.Next()
	if err != nil {
		return ctx.Status(400).JSON(
			ErrorMessage{Error: true, Message: err.Error()})
	}
	return err
}

func main() {
	zap_logger, _ := zap.NewDevelopment()
	zap.ReplaceGlobals(zap_logger)
	app := fiber.New()
	app.Use(syncLogger)
	app.Use(logger.New())
	api := app.Group(apiPath)
	api.Use(errorHandler)
	api.Post(apiCarRecognizePath, apiCarRecognizeHandler)
	api.Post(apiCarLoanPath, apiCarLoanHandler)
	api.Post(apiCalculatePath, apiCalculateHandler)
	api.Post(apiPaymentGraphPath, apiPaymentsGraphHandler)
	api.Get(apiMarketplacePath, apiMarketplaceHandler)
	api.Get(apiSettingsPath, apiSettingsHandler)
	app.Listen(":8090")
}
