path :=$(if $(path), $(path), "./")

## Minikube commands

install-minikube:
	@configurations/_scripts/minikube/install.sh

delete-minikube:
	@configurations/_scripts/minikube/delete.sh

## Kubernets initialization

init-setup: 
	@$(shell configurations/_scripts/init/setup.sh)



## Applications

## Build


app-build-common:
	@ echo "selecting module $(app)"
	@ cd applications/$(app) && go clean  
	@ cd applications/$(app) && go mod tidy && go mod download
	@ cd applications/$(app) && go mod verify

app-build: app-build-common
	@ echo clean
	@ rm -f applications/$(app)/.bin/debug
	@ echo building...
	@ cd applications/$(app) && go build -tags debug -o ".bin/debug" main.go
	@ ls -lah applications/$(app)/.bin/debug

app-build-release: app-build-common
	@ echo clean
	@ rm -f applications/$(app)/.bin/release
	@ echo build release
	@ cd applications/$(app) && CGO_ENABLED=0 go build -ldflags='-w -s -extldflags "-static"' -a -o ".bin/release" main.go
	@ ls -lah applications/$(app)/.bin/release


app-docker-build: app-build-common
	@ docker build applications/$(app) -t $(app):$(version)

app-docker-push: app-build-common
	@ docker push $(repo_username)/$(app):$(version)

app-scan:
	@ go install github.com/securego/gosec/v2/cmd/gosec@latest
	@ gosec -fmt=sarif -out=applications/$(app).sarif -exclude=_test -severity=medium ./applications/$(app)/... | 2>&1
	@ cat $(path)applications/$(app).sarif

