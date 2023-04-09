# csv-rander
This repo is design to host the raw code of the csv-rander container image which is converting the redhat-operator-index to csv format

## How to use the `csv-rander`:

Obtain the [pull-secret][pull-secret.json] to obtain the access to the `redhat-operator-index`, save it to a path in your workstation.

- building the container-base-image:
```bash
$ git clone https://github.com/midu16/csv-rander.git
$ cd csv-rander/
$ podman build -t csv-rander:latest .
$ podman run -d -e PRE_GA_INDEX=registry.redhat.io/redhat/redhat-operator-index -e PRE_GA_TAG=v4.12 -v /path/to/saved/pull-secret.json/dir:/home/admin/.docker:Z localhost/csv-rander:latest
$ podman logs <conainer-id>
```
[pull-secret.json]: https://console.redhat.com/openshift/install/pull-secret

## How to use the `csv-rander` public image:

```bash
$ podman run -d -e PRE_GA_INDEX=registry.redhat.io/redhat/redhat-operator-index -e PRE_GA_TAG=v4.12 -v /path/to/saved/pull-secret.json/dir:/home/admin/.docker:Z quay.io/midu/csv-rander:latest
```