# PROW - CI in Kubernetes

This repo is intended as a getting started guide for Prow.

Prow is a Kubernetes based CI system that has been getting a lot of traction for some time now.
Jobs can be triggered by various types of events and report their status to
many different services. In addition to job execution, Prow provides GitHub automation in the form of policy
enforcement, chat-ops via `/foo` style commands, and automatic PR merging.

## Prow Components

* **Hook**
  * This is the heart of Prow.
  * Responds to github events and dispatches them to respective plugins.
  * Hooks plugins are used to trigger jobs , implement 'slash' commands, post ot Slack and many more.
  * Plugins provide a great amount of extensibility.
  * Support for external plugins.

* **Horologium**
  * Responsible for triggering all the periodic jobs.

* **Plank**
  * Controller that manages job execution and lifecycle of K8s jobs.
  * Looks for jobs created by prow with agent Kubernetes.
  * Starts the jobs.
  * Updates jobs state.
  * Terminates duplicate pre-submit jobs.

* **Sinker**
  * Cleans up.
  * Deletes completed prow jobs.
  * Ensuring to kep the most recent completed periodic job.
  * Removes old completed pods.

* **Deck**
  * Provides a view of recent prow jobs.
  * Help on plugins and commands.
  * Status of merge automation (provided by Tide).
  * Dashboard for PR authors.

* **Tide**
  * Merge automation.
  * Batches and retests a group of PRs against latest HEAD.
  * Merge the changes.

### Possible jobs in Prow

* presubmit
* postsubmit
* periodic
* batch

> Possible states of a job

* triggered
* pending
* success
* failure
* aborted
* error

### Deploy you own Prow cluster for continuous integration

1. Create a bot account. For info [look here](https://stackoverflow.com/questions/29177623/what-is-a-bot-account-on-github).

2. Create an oauth2 token from the github gui for the bot account.  

    `echo "PUT_TOKEN_HERE" > oauth`

    `kubectl create secret generic oauth --from-file=oauth=oauth`

3. Create an openssl token to be used with the Hook.

    `openssl rand -hex 20 > hmac`

    `kubectl create secret generic hmac --from-file=hmac=hmac`

4. Create all the Prow components.

    `kubectl create -f prow_starter.yaml`

5. Update all the jobs and plugins needed for the CI (rules mentioned in the [Makefile](https://github.com/sanster23/k8s-prow-guide/blob/master/Makefile)).
    Use commands:

    ```bash
    make update-config

    make update-plugins
    ```

6. For creating a webhook in github repo and pointing it to the local machine use Ultrahook.
    Install [Ultrahook](http://www.ultrahook.com/)

    ```bash
    echo "api_key: <API_KEY_ULTRAHOOK>" > ~/.ultrahook
    ```

    `ultrahook github http://<MINIKUBE_IP>:<HOOK_NODE_PORT>/hook`

    this will give you a publicly accessible endpoint (in my case): <http://github.sanster23.ultrahook.com>

7. Create a docker hub credentials secret in k8s, this will help us to use credentials to build and push images to docker registry.

  `kubectl create secret generic docker-creds --from-literal=username=<USERNAME> --from-literal=password=<PASSWORD>`
8. Create gcs creds secret

   `kubectl create secret generic gcs-sa --from-file=service-account.json=service-account.json`

   ```
TESTING

   ```
