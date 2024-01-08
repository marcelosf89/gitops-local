.EXPORT_ALL_VARIABLES:

path :=$(if $(path), $(path), "./")
repo_username :=$(if $(repo_username), $(repo_username), "masf89")


# Minikube commands
install-minikube:
	@configurations/scripts/minikube/install.sh

delete-minikube:
	@configurations/scripts/minikube/delete.sh

# Kubernets initialization
init-setup: 
	@configurations/scripts/init/setup.sh

# Applications

## Build
app-build-common:
	@ echo "selecting module $(app)"
	@ cd applications/$(app)/src && go clean  
	@ cd applications/$(app)/src && go mod tidy && go mod download
	@ cd applications/$(app)/src && go mod verify

app-build: app-build-common
	@ echo clean
	@ rm -f applications/$(app)/src/.bin/debug
	@ echo building...
	@ cd applications/$(app)/src && go build -tags debug -o ".bin/debug" main.go
	@ ls -lah applications/$(app)/src/.bin/debug

app-build-release: app-build-common
	@ echo clean
	@ rm -f applications/$(app)/src /.bin/release
	@ echo build release
	@ cd applications/$(app)/src  && CGO_ENABLED=0 go build -ldflags='-w -s -extldflags "-static"' -a -o ".bin/release" main.go
	@ ls -lah applications/$(app)//src .bin/release

# Docker
app-docker-build: app-build-common
	@ docker build applications/$(app)/src -t $(repo_username)/$(app):$(version)

app-docker-push: app-build-common
	@ docker push $(repo_username)/$(app):$(version)

# Sec Scan
app-scan:
	@ go install github.com/securego/gosec/v2/cmd/gosec@latest
	@ gosec -fmt=sarif -out=applications/$(app).sarif -exclude=_test -severity=medium ./applications/$(app)/src/... | 2>&1
	@ cat $(path)applications/$(app).sarif

# App Set
## Install / Update
app-install: 
	@ configurations/appsets/install-appsets.sh $(app) $(repo_appsets) $(pat_token) $(port)

## Update
app-update: 
	@ configurations/appsets/update-appsets.sh $(app) 

# Helm

## Build Helmchart
app-update-release:
	@ configurations/scripts/helm/release-app.sh $(app) $(environment) $(version)

## Push Helmchart
push-update-release: app-update-release
	@ git config user.name github-actions
	@ git config user.email github-actions@github.com

	@ git add applications/$(app)/_release/env/$(environment)/	

	@ git commit --allow-empty -m "release to $(environment) with the version $(version)"
	@ git push https://github.com/$(repo_appsets).git

# Install Third Parties
third-parties-install: 
	@ configurations/third_parties/$(name)/install.sh

# Run Load Test
run-load-test: 
	@ tests/load-test.sh
