#!/bin/sh

set -x

# git の commit ログから変更のあった component の一覧を取得する
CHANGE_LIST=`git log -n 1 --name-only --oneline | tail -n +2 | grep components | cut -d '/' -f2 | uniq`

# 変更された component 単位で処理させる
for component in `echo ${CHANGE_LIST}`
do
  if [[ ${CODEBUILD_WEBHOOK_TRIGGER} = 'branch/main' ]]; then
    ${CODEBUILD_SRC_DIR}/components/deployer/scripts/apply.sh "${component}"
  else
    ${CODEBUILD_SRC_DIR}/components/deployer/scripts/plan.sh "${component}"
  fi
done
