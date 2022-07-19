# ![RealWorld Example App](logo.png)

> ### [Scala](https://www.scala-lang.org/) codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld) spec and API.


### [Demo](https://demo.realworld.io/)&nbsp;&nbsp;&nbsp;&nbsp;[RealWorld](https://github.com/gothinkster/realworld)


This codebase was created to demonstrate a fully fledged fullstack application built with **[Scala](https://www.scala-lang.org/)** including CRUD operations, authentication, routing, pagination, and more.

We've gone to great lengths to adhere to the **[Scala](https://www.scala-lang.org/)** community styleguides & best practices.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repo.


# How it works

> Describe the general architecture of your app here

# Getting started

> npm install, npm start, etc.

# Deploy

## Deploy to [Google Cloud Platform](https://cloud.google.com/) (GCP)

1. Install the [gcloud CLI](https://cloud.google.com/sdk/docs/install).
1. Install [terraform](https://www.terraform.io).
1. [Create an Organization](https://cloud.google.com/resource-manager/docs/creating-managing-organization) on GCP.
1. [Setup Cloud Billing](https://cloud.google.com/billing/docs/onboarding-checklist) to obtain a [Billing Account](https://cloud.google.com/billing/docs/concepts#billing_account).
1. [Create a Folder](https://cloud.google.com/resource-manager/docs/creating-managing-folders) on GCP to contain your project.
1. `cd` into the [environments bootstrap directory](./deploy/gcp/terraform/environments/bootstrap).
1. Create a [`terraform.tfvars`](https://www.terraform.io/language/values/variables#variable-definitions-tfvars-files) and add the variables and their values.
1. Run `terraform init` and `terraform apply` to bootstrap your [project](https://cloud.google.com/resource-manager/docs/cloud-platform-resource-hierarchy#projects) and the [Google Storage Bucket](https://cloud.google.com/storage/docs/key-terms#buckets) that is going to contain your environment's [terraform state](https://www.terraform.io/language/state).
1. `cd` into your [environment's directory](./deploy/gcp/terraform/environments/dev). Update the `backend.tf` to use the Storage Bucket created during bootstraping as your [backend](https://www.terraform.io/language/settings/backends/gcs). Update the `locals.tf` with your project id and other values as you seem fit.
1. The [`deploy-dev` workflow](./.github/workflows/deploy-dev.yaml) will build and deploy the Docker container image to GCP's [Artifact Registry](https://cloud.google.com/artifact-registry). Add the secrets it needs to run, which were created during the project's bootstrap.
