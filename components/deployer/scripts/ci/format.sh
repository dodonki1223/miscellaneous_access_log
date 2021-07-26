#!/bin/sh

# recursive：カレンドディレクトリ以外にもサブディレクトリも含めて実行する
# check：すべてのファイルが適切にフォーマットされている場合は 0 を返しそうでない場合は 0 以外を返す
terraform fmt -recursive -check
