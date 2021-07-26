#!/bin/sh

# 対象の components のディレクトリへ移動
cd ${CODEBUILD_SRC_DIR}/components/$1

# デプロイの実行
terraform init -input=false -no-color
terraform apply -input=false -no-color -auto-approve
