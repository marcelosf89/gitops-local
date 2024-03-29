package main

import (
	"database/sql"
	"fmt"
	"os"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo-contrib/echoprometheus"
)

func main() {

	
	e := echo.New()

	e.Use(echoprometheus.NewMiddleware("web")) // adds middleware to gather metrics
	e.GET("/metrics", echoprometheus.NewHandler()) // adds route to serve gathered metrics

	// TODO: use the docker images user name and password config
	conn := os.Getenv("MYSQL_USER") + ":" + os.Getenv("MYSQL_PASSWORD") + "@tcp(" + os.Getenv("MYSQL_HOST") + ")/" + os.Getenv("MYSQL_DATABASE")
	db, err := sql.Open("mysql", conn)
	if err != nil {
		panic(err.Error())
	}
	defer db.Close()

	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "Hello from Basic Golang Server using Echo!")
	})

	e.Logger.Fatal(e.Start(":8080"))

	e.POST("/factors", func(c echo.Context) error {
		number, _ := strconv.Atoi(c.FormValue("number"))
		factors := factors(number)

		stmt, err := db.Prepare("INSERT INTO factors(id, value) VALUES(?, ?)")
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}
		defer stmt.Close()

		_, err = stmt.Exec(number, factors)
		if err != nil {
			return c.String(http.StatusInternalServerError, err.Error())
		}

		return c.String(http.StatusOK, fmt.Sprintf("Factors of %d have been stored successfully!", number))
	})
}

func factors(n int) int {
	var factors []int
	for i := 1; i <= n; i++ {
		if n%i == 0 {
			factors = append(factors, i)
		}
	}
	return len(factors)
}
