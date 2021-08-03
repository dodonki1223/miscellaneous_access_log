#!/bin/sh

# 対象の components のディレクトリへ移動
cd ${CODEBUILD_SRC_DIR}/$1

# 対象の component を取得
COMPONENT=`echo $1 | cut -d '/' -f 3`

# デプロイ計画の実行
echo ----- Run terraform plan：${COMPONENT} -----
terraform init -input=false -no-color
terraform plan -input=false -no-color | \
tfnotify --config ${CODEBUILD_SRC_DIR}/components/cicd/tfnotify.yml plan --message "${COMPONENT} - $(date)"
