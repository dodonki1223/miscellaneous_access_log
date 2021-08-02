#!/bin/sh

TF_LINT_VERSION="v0.30.0"

install_tflint() {
  echo "Start TFLint install..."
  TF_LINT_REPOSITORY="https://github.com/terraform-linters/tflint/releases/download"
  TF_LINT_DOWNLOAD_URL="${TF_LINT_REPOSITORY}/${TF_LINT_VERSION}/tflint_linux_amd64.zip"
  wget ${TF_LINT_DOWNLOAD_URL} -P /tmp
  unzip /tmp/tflint_linux_amd64.zip -d /tmp
  mv /tmp/tflint /bin/tflint
  echo "TFLint install complete"
}

install_tflint
