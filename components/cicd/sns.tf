# 詳しくは公式の Example を参考にすること
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule#example-usage

/*
    SNSトピック
      SNSトピックを作成し、作成したSNSトピックにアクセスポリシーを設定する
 */
resource "aws_sns_topic" "codeseries_notif" {
  name = "codeseries-notifications-for-cicd"
}

# SNSトピック用のアクセスポリシーを定義
data "aws_iam_policy_document" "notif_access" {
  statement {
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["codestar-notifications.amazonaws.com"]
    }

    resources = [aws_sns_topic.codeseries_notif.arn]
  }
}

# SNSトピックにアクセスポリシーを紐付ける
resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.codeseries_notif.arn
  policy = data.aws_iam_policy_document.notif_access.json
}

/*
    Codeシリーズの通知設定
      Codeシリーズからの通知をAmazon SNSに紐付け、アプリケーション対アプリケーション（A2A)間
      の通信を可能とする
      Codeシリーズのデベロッパー用ツールの通知ルールが作成される
      コンソール画面でSNSをAWS Chatbotに紐付けることでSlack通知を可能とする（AWS Chatbotはterraformに
      まだ対応していないため）
 */
resource "aws_codestarnotifications_notification_rule" "build" {
  detail_type = "BASIC"
  # CodeBuildのイベントについてははこちらのドキュメントを確認すること
  #   https://docs.aws.amazon.com/ja_jp/dtconsole/latest/userguide/concepts.html#events-ref-buildproject
  #   NOTE: phase の通知をするとすべてのイベントの通知を行うのですごく邪魔なので state だけ通知の対象とする
  event_type_ids = [
    "codebuild-project-build-state-failed",
    "codebuild-project-build-state-succeeded",
  ]

  name     = "codebuild-notify-for-project"
  resource = aws_codebuild_project.continuous_apply.arn

  target {
    address = aws_sns_topic.codeseries_notif.arn
  }
}
