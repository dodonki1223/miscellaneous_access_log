#!/bin/sh

TF_LINT_VERSION="v0.30.0"
TF_NOTIFY_VERSION="v0.7.0"

install_tflint() {
  echo "Start TFLint install..."
  TF_LINT_REPOSITORY="https://github.com/terraform-linters/tflint/releases/download"
  TF_LINT_DOWNLOAD_URL="${TF_LINT_REPOSITORY}/${TF_LINT_VERSION}/tflint_linux_amd64.zip"
  wget ${TF_LINT_DOWNLOAD_URL} -P /tmp
  unzip /tmp/tflint_linux_amd64.zip -d /tmp
  mv /tmp/tflint /bin/tflint
  echo "TFLint install complete"
}

install_tfnotify() {
  echo "Start tfnotify install..."
  TF_NOTIFY_REPOSITORY="https://github.com/mercari/tfnotify/releases/download"
  TF_NOTIFY_DOWNLOAD_URL="${TF_NOTIFY_REPOSITORY}/${TF_NOTIFY_VERSION}/tfnotify_linux_amd64.tar.gz"
  wget ${TF_NOTIFY_DOWNLOAD_URL} -P /tmp
  tar zxvf /tmp/tfnotify_linux_amd64.tar.gz -C /tmp
  mv /tmp/tfnotify /bin/tfnotify
  echo "tfnotify install complete"
}

install_tflint
install_tfnotify
