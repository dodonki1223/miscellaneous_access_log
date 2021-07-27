#!/bin/sh

TF_LINT_VERSION="v0.30.0"

install_tflint() {
  TF_LINT_REPOSITORY="https://github.com/terraform-linters/tflint/releases/download"
  DOWNLOAD_URL="${TF_LINT_REPOSITORY}/${TF_LINT_VERSION}/tflint_linux_amd64.zip"
  wget ${DOWNLOAD_URL} -P /tmp
  unzip /tmp/tflint_linux_amd64.zip -d /tmp
  mv /tmp/tflint /bin/tflint
  echo "installed tflint"
}

install_tflint
