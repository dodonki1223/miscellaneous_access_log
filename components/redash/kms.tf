/*
    CMK（カスタマーマスターキー）
      CMKとは
        KMS（Key Management Service）は暗号鍵を簡単かつ安全に管理するソリューションです
        CMK（カスタマーマスターキー）が自動生成したデータキーを使用して、暗号化と復号を行います
        AWSの各種サービスでCMKを指定すれば自動的に暗号化と復号を行えます
      enable_key_rotationを指定し、自動ローテーションをONにする
        https://docs.aws.amazon.com/ja_jp/kms/latest/developerguide/rotate-keys.html#rotate-keys
      削除待機時間を30に設定する（deletion_window_in_days = 30）
 */
resource "aws_kms_key" "miscellaneous_access_kms_key" {
  description             = "CMK for ${var.application}"
  enable_key_rotation     = true
  is_enabled              = true
  deletion_window_in_days = 30
}

/*
    CMK（カスタマーマスターキー）のエイリアス
      CMKにはそれぞれUUIDが割り当てられるが、人間には分かりづらいため、エイリアスを設定し、どういう用途
      で使われているか識別しやすくする
      エイリアスで設定する名前には「alias/」というプレフィックスが必要
 */
resource "aws_kms_alias" "miscellaneous_access_kms_alias" {
  name          = "alias/${var.application}"
  target_key_id = aws_kms_key.miscellaneous_access_kms_key.key_id
}
