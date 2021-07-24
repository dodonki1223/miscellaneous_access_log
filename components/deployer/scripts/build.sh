#!/bin/sh
set -x

if [[ ${CODEBUILD_WEBHOOK_TRIGGER} = 'branch/main' ]]; then
  ${CODEBUILD_SRC_DIR}/deployer/scripts/apply.sh
else
  ${CODEBUILD_SRC_DIR}/deployer/scripts/plan.sh
fi
