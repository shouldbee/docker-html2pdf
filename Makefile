SHOULDBEE_ENV := -e SHOULDBEE_API_URL=$(SHOULDBEE_API_URL) -e SHOULDBEE_USERNAME=$(SHOULDBEE_USERNAME) -e SHOULDBEE_PASSWORD=$(SHOULDBEE_PASSWORD)

GO      := sudo docker run -i  --rm --net host -v `pwd`:/vagrant -w /vagrant $(SHOULDBEE_ENV) shouldbee/go go
GOM     := sudo docker run -it --rm --net host -v `pwd`:/vagrant -w /vagrant $(SHOULDBEE_ENV) shouldbee/go bin/gom
GOX     := sudo docker run -it --rm --net host -v `pwd`:/vagrant -w /vagrant/src shouldbee/go /vagrant/bin/gom exec gox

GOPATH := ${PWD}/_vendor:${GOPATH}
export GOPATH

# how to pass args:
# make ARGS="run"
run: fmt
	$(GOM) run src/proxy/*.go ${ARGS}

install:
	$(GOM) install

fmt:
	$(GO) fmt ./...

test: assets fmt
	$(GOM) run src/*.go --debug run

build: fmt
	$(GOX) -os="linux darwin windows" -arch="386 amd64" -output="/vagrant/build/{{.OS}}-{{.Arch}}/html2pdf" -ldflags "-X main.version '`$(VERSION)`'"

deploy:
	cp -r build deploy/
	./bin/make-formula.sh
