#!/bin/sh

# 対象の components のディレクトリへ移動
cd ${CODEBUILD_SRC_DIR}/$1

# 対象の component を取得
COMPONENT=`echo $1 | cut -d '/' -f 3`

# デプロイの実行
echo ----- Run terraform apply：${COMPONENT} -----
terraform init -input=false -no-color
terraform apply -input=false -no-color -auto-approve | \
tfnotify --config ${CODEBUILD_SRC_DIR}/components/cicd/tfnotify.yml apply --message "${COMPONENT} - $(date)"
