#!/bin/sh

# 実行スクリプトのフォルダへ移動（この記述をすることで実行場所を選ばないスクリプトになる）
cd `dirname $0`

printf "＜Componentの削除手順＞\n1. providers.tfファイル以外を削除しデプロイする \n2. delete_component_s3.shを実行しComponentのtfstateファイルを削除する \n3. Componentのフォルダごとを削除 \n\n"

# 対象のComponentのproviders.tfファイル内のbackendの設定値を入力する事を想定しています
read -p "S3のディレクトリ削除で使用するprofile名を入力してください: " PROFILE_NAME
read -p "削除対象のComponent名を入力して下さい: " COMPONENT_NAME
read -p "削除対象のComponentのtfstateファイルが存在するバケット名(bucketの値)を入力して下さい: " BUCKET_NAME

# 対象のComponentのtfstateファイルを管理しているディレクトリを削除する
DELETE_S3_PATH="s3://${BUCKET_NAME}/${COMPONENT_NAME}"
printf "\n${COMPONENT_NAME}を削除します……(${DELETE_S3_PATH})\n"
read -p "削除を実行する場合はenterを押して下さい: "
aws s3 rm ${DELETE_S3_PATH} \
  --recursive \
  --profile ${PROFILE_NAME} \
