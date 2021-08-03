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
