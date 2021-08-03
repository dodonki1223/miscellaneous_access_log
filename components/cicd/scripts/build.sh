#!/bin/sh

# ./modules ディレクトリ以外で tfファイルが存在するディレクトリ(component)の一覧を取得
TERRAFORM_FOLDERS=`find . -type d -name modules -prune -o -type f -name *.tf -exec dirname {} \; | sort -u`

# 対象のディレクトリごとに validate コマンドを実行する
for folder in `echo ${TERRAFORM_FOLDERS}`
do
  # 終了ステータスが0の時は変更がないため、以降の処理をスキップする
  cd ${CODEBUILD_SRC_DIR}/${folder}
  terraform plan -detailed-exitcode -refresh=false -no-color
  PLAN_STATUS_CODE=$?
  if [ ${PLAN_STATUS_CODE} -eq 0 ]; then
    continue
  fi

  if [[ ${CODEBUILD_WEBHOOK_TRIGGER} = 'branch/main' ]]; then
    ${CODEBUILD_SRC_DIR}/components/cicd/scripts/apply.sh "${folder}"
  else
    ${CODEBUILD_SRC_DIR}/components/cicd/scripts/plan.sh "${folder}"
  fi
done
