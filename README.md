# kindle-sync

Automatically sync between a local directory and Kindle

## requirements

* BASH
* An AWS account credentials and associated policy to use SES.
* Amazon SES SMTP interface is setup
* Tested only on Ubuntu Linux. Minor tweaks may be necessary for Macs.


## usage

To manually send a PDF to to Kindle:

```
./sync.sh [test.pdf]
```

### optional

Watch a directory for new PDF files to sync to Kindle:

```
./kindle-watch.sh [DIR]
```
