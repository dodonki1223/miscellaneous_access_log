# 詳しくは公式の Example を参考にすること
#   https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codestarnotifications_notification_rule#example-usage

# SNSトピックの作成
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

# Codeシリーズのデベロッパー用ツールの通知ルールが作成される
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
