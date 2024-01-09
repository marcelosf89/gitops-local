# Project Structure

## Application

The `application` path contains all project folders related to applications in this solution.

1. [**web**](../applications/web/)

   Webserver application

    1. [**_release**](../applications/web/_release/)

       This path contains all the necessary information to create the Helm chart for the application.

       1. [**env**](../applications/web/_release/env/)

          This path contains all helm chart compiled on Github Actions

    2. [**src**](../applications/web/src/)

      The source code for the webserver.

## Configurations

1. [**appsets**](../configurations/appsets/)

   Contains all application configurations to be created on ArgoCD.

2. [**scripts**](../configurations/scripts/)

   Contains helpful scripts for configuring ArgoCD, Minikube, etc.

3. [**third_parties**](../configurations/third_parties/)

   Contains configurations for third-party integrations.

    1. [**mysql**](../configurations/third_parties/mysql/)

      Configuration for MySQL integration.

    2. [**observability**](../configurations/third_parties/observability/)

      Configuration for observability tools.