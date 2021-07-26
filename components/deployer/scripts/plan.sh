#!/bin/sh

# 対象の components のディレクトリへ移動
cd ${CODEBUILD_SRC_DIR}/components/$1

# デプロイ計画の実行
terraform init -input=false -no-color
terraform plan -input=false -no-color
