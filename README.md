# Devops 

## Documentations

1. [Solution Overview](./docs/solution.md)
2. [Project Structure](./docs/project-structure.md)
3. [Architecture Overview](./docs/architecture.md)
4. [Improvements](./docs/improvements.md)

## Stack

- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/)
- [MySQL](https://www.mysql.com/)
- [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
- [Helm](https://helm.sh/)
- [Golang](https://go.dev/)

To run a test:

- [k6](https://k6.io/)


## Pre requisits

### CLI

**k6**

For Mac using brew command, if you are using other os please check on the oficial website https://k6.io/docs/get-started/installation/

```sh
brew install k6
```

**ArgoCD**

For Mac using brew command, if you are using other os please check on the oficial website https://argo-cd.readthedocs.io/en/stable/cli_installation/

```sh
brew install argocd
```

**Helm**

For Mac using brew command, if you are using other os please check on the oficial website https://helm.sh/

```sh
brew install helm
```


## Initialize Minikube

Install minikube

```sh
make install-minikube
```

Setup minikube and ArgoCD

```sh
make init-setup
```

Setup all core project that is important run the project

```sh
make third-parties-install name=observability
make third-parties-install name=mysql
```

Install the project on ArgoCD

> note: ypu need the `pat` to have the access to get the project on github


```sh
make app-install app="web" repo_appsets="https://github.com/marcelosf89/gitops-local.git" pat_token="" port=9000
```


### Important Note 

Minikube run inside the docker and because of it you need to forward the port, but the Ingress was created like a official kubernet cluester, you can check it on project like `lens` or checking on `kubectl`

| app             | url                   |
| --------------- | --------------------- |
| web application | http://localhost:9000 |
| argocd          | http://localhost:9001 |
| grafana         | http://localhost:9002 |


