package main

import (
	"crypto/rand"
	"encoding/base32"
	"encoding/base64"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

func getRandomString() string {
	b := make([]byte, 32)
	io.ReadFull(rand.Reader, b)
	return strings.TrimRight(base32.StdEncoding.EncodeToString(b), "=")
}

func getEncodedPdfContents(filepath string) (string, error) {
	contents, err := ioutil.ReadFile(filepath)

	if err != nil {
		return "", err
	} else {
		return base64.StdEncoding.EncodeToString(contents), nil
	}
}

func html2pdfHandler(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()

	url := r.Form["url"][0]

	pathToPdf := "/tmp/" + getRandomString() + ".pdf"

	cmd := exec.Command("wkhtmltopdf", url, pathToPdf)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	err := cmd.Run()

	if err != nil {
		log.Fatal(err)
		http.Error(w, "InternalServerError", http.StatusInternalServerError)
	} else {
		base64pdf, pdferr := getEncodedPdfContents(pathToPdf)

		if pdferr != nil {
			http.Error(w, "InternalServerError: pdf not found", http.StatusInternalServerError)
		} else {
			w.Header().Set("Content-Type", "application/pdf")
			fmt.Fprintf(w, base64pdf)
			os.Remove(pathToPdf)
		}
	}
}

func main() {
	http.HandleFunc("/", html2pdfHandler)
	http.ListenAndServe(":80", nil)
}
