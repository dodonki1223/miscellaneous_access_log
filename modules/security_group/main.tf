/*
    セキュリティグループ
      インスタンスレベルで仮想ファイアウォールとして機能します
        ちなみにサブネットレベルで動作させるにはネットワークACLを使用します
        セキュリティグループは「プロトコルとポート番号」で行い、ネットワークACLは「ポート番号とCIDR」で行う
      基本的にはセキュリティグループで細かいトラフィック制御を行う
        https://dev.classmethod.jp/articles/why-i-prefer-sg-to-nacl/
      特徴
        ・許可ルールを指定できます。拒否ルールは指定できません
        ・インバウンドトラフィックとアウトバウンドトラフィックのルールを個別に指定できます
        ・セキュリティグループルールを使用すると、プロトコルとポート番号に基づいてトラフィックをフィルタリングできます
        ・セキュリティグループはステートフルです。インスタンスからリクエストを送信する場合、そのリクエストのレスポンストラフィックは、
          インバウンドセキュリティグループのルールにかかわらず、流れることができます。許可されたインバウンドトラフィックに
          対する応答（戻りのトラフィック）は、アウトバウンドルールにかかわらずアウト側に対し通過することができます
        ・セキュリティグループを初めて作成するときには、インバウンドルールはありません
          したがって、インバウンドルールをセキュリティグループに追加するまで、別のホストからインスタンスに送信されるインバウンドトラフィックは許可されません
        ・デフォルトでは、セキュリティグループにはすべてのアウトバウンドトラフィックを許可するアウトバウンドルールが含まれています
          ルールを削除し、任意の発信トラフィックのみを許可するアウトバウンドルールを追加できます
          セキュリティグループにアウトバウンドルールがない場合、インスタンスから送信されるアウトバウンドトラフィックは許可されません
        ・セキュリティグループに関連付けられたインスタンスの相互通信は、トラフィックを許可するルールを追加するまで許可さ
          れません（例外: デフォルトのセキュリティグループについては、このルールがデフォルトで指定されています）
        ・セキュリティグループはネットワークインターフェイスに関連付けられます
          インスタンスを起動した後で、インスタンスに関連付けられたセキュリティグループを変更できます
          これにより、プライマリネットワークインターフェイス (eth0) に関連付けられたセキュリティグループが変更されます
          あらゆるネットワークインターフェイスに関連付けられているセキュリティグループも指定または変更できます
          デフォルトでは、ネットワークインターフェイスを作成すると、別のセキュリティグループを指定しない限り、
          VPC のデフォルトのセキュリティグループに関連付けられます
      https://docs.aws.amazon.com/ja_jp/vpc/latest/userguide/VPC_SecurityGroups.html

 */
resource "aws_security_group" "default" {
  name   = var.name
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name}"
  }
}

/*
    セキュリティグループルール（インバウンド）
      セキュリティグループのルールは追加または削除できます (インバウンドまたはアウトバウンドアクセスの許可または取り消しとも呼ばれます)
        ルールが適用されるのは、インバウンドトラフィック (受信) またはアウトバウンドトラフィック (送信) のいずれかです
        特定の CIDR 範囲、または VPC あるいはピア VPC (VPC ピアリング接続が必要) の別のセキュリティグループにアクセス権を付与できます
      特徴
        ・デフォルトで、セキュリティグループはすべてのアウトバウンドトラフィックを許可します
        ・セキュリティグループのルールは常にパーミッシブです。アクセスを拒否するルールを作成することはできません
        ・セキュリティグループルールを使用すると、プロトコルとポート番号に基づいてトラフィックをフィルタリングできます
        ・セキュリティグループはステートフルです
          インスタンスからリクエストを送信すると、そのリクエストに対する応答トラフィックは、インバウンドルールにかかわらず、流入できます
          つまり、許可されたインバウンドトラフィックに対する応答は、アウトバウンドルールにかかわらず通過することができます
        ・ルールの追加と削除は随時行うことができます。変更は、セキュリティグループに関連付けられたインスタンスに自動的に適用されます
          一部のルール変更の影響は、トラフィックの追跡方法によって異なる場合があります
        ・複数のセキュリティグループをインスタンスに関連付けると、各セキュリティグループのルールが効率的に集約され、1 つのルールセットが作成されます
          セキュリティグループは、1 つのインスタンスに複数割り当てることができます。そのため、1 つのインスタンスに数百のルールが適用される場合があります
          結果として、インスタンスにアクセスするときに問題が発生する可能性があります。そのため、ルールは可能な限り要約することをお勧めします
 */
resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = var.port
  to_port           = var.port
  protocol          = "tcp"
  cidr_blocks       = var.cidr_blocks
  security_group_id = aws_security_group.default.id
}

/*
    セキュリティグループルール（アウトバウンド）
 */
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}