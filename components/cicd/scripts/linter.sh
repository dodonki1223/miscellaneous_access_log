#!/bin/sh

# コマンドの返り値が非ゼロのとき停止する
set -e

# ./modules ディレクトリ以外で tfファイルが存在するディレクトリの一覧を取得
TERRAFORM_FOLDERS=`find . -type d -name modules -prune -o -type f -name *.tf -exec dirname {} \; | sort -u`

# 対象のディレクトリごとに validate コマンドを実行する
for folder in `echo ${TERRAFORM_FOLDERS}`
do
  echo ----- Run tflint：${CODEBUILD_SRC_DIR}/${folder} -----
  cd ${CODEBUILD_SRC_DIR}/${folder}
  tflint --module
done
