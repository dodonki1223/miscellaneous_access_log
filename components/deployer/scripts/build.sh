#!/bin/sh

# コマンドの返り値が非ゼロのとき停止する
set -e

# git の commit ログから変更のあった component の一覧を取得する
# 以下のエラーが発生したため、以下の記事を参考に修正
#   error: Could not read 2ee9bf675d2077e4b3bfc0b03ba7cb00fd89e331
#   fatal: Failed to traverse parents of commit 4cddb1bce3fbe3f6654d1283fa7a42324f26e2d3
#   https://stackoverflow.com/questions/52266900/aws-codebuild-fails-on-eb-deploy-git-failed-to-traverse-parents-of-commit
CHANGE_LIST=`git log -n 1 --name-only --oneline | tail -n +2 | grep components | cut -d '/' -f2 | uniq`

# 変更された component 単位で処理させる
for component in `echo ${CHANGE_LIST}`
do
  echo ${component}
  if [[ ${CODEBUILD_WEBHOOK_TRIGGER} = 'branch/main' ]]; then
    ${CODEBUILD_SRC_DIR}/components/deployer/scripts/apply.sh "${component}"
  else
    ${CODEBUILD_SRC_DIR}/components/deployer/scripts/plan.sh "${component}"
  fi
done
