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

The directory structure of `/path/to/saved/pull-secret.json/dir`:
```bash
$ ls -l /path/to/saved/pull-secret.json/dir/
-rw-r--r-- 1 midu   midu       3126 Apr  9 20:06 config.json
-rw-r--r-- 1 100999 100999        0 Apr 11 08:04 redhat-operator-index.csv
```

- `config.json` its the [pull-secret.json][pull-secret.json].
- `redhat-operator-index.csv` its the `registry.redhat.io/redhat/redhat-operator-index:v4.12` indexed rendered data for further processing. Each iteration will create a new file.