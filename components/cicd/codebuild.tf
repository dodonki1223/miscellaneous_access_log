/*
    CodeBuildで使用する権限
      現在は最高権限を設定しているため、ちゃんと権限を絞る必要がある
 */
module "continuous_apply_codebuild_role" {
  source     = "../../modules/iam_role"
  name       = "continuous-apply"
  identifier = "codebuild.amazonaws.com"
  policy     = data.aws_iam_policy.administrator_access.policy
}

data "aws_iam_policy" "administrator_access" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

/*
    GitHubトークン設定
      CodeBuildで使用するためにGitHubトークンを参照できるようにする
 */
data "aws_ssm_parameter" "github_token" {
  name = "/continuous_apply/github_token"
}

/*
    CodeBuild
      GitHubのイベントをHookしてCodeBuildが実行されるようにする
      キャッシュ機構を設定しているわけではないのでもっと高速化できるかも？
 */
resource "aws_codebuild_project" "continuous_apply" {
  name          = "continuous-apply"
  service_role  = module.continuous_apply_codebuild_role.iam_role_arn
  build_timeout = "30"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  /*
      CodeBuildで使用するビルド環境の設定
        イメージはterraform公式のものを使用する
        docker hubにログインが現状できていないため、時々ビルドが失敗する問題がある
   */
  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.0.3"
    image_pull_credentials_type = "CODEBUILD"
  }

  /*
      対象となるリポジトリ設定
        CodeBuildどんな処理を実行するのかはbuildspec.ymlに書かれている
        buildspec.ymlのディレクトリを変更するにはbuildspecの設定を使用する
   */
  source {
    type            = "GITHUB"
    location        = "https://github.com/dodonki1223/miscellaneous_access_log.git"
    git_clone_depth = 1
    # buildspec.yml のディレクトリ変更方法
    #   https://docs.aws.amazon.com/ja_jp/AWSCloudFormation/latest/UserGuide/aws-properties-codebuild-project-source.html#cfn-codebuild-project-source-buildspec
    #   https://stackoverflow.com/questions/45723187/how-can-i-have-multiple-codebuild-buildspec-files-in-different-directories
    buildspec = "./components/cicd/buildspec.yml"
  }

  /*
      local-exec
        リソースが作成された後にローカルで実行される
          https://www.terraform.io/docs/language/resources/provisioners/local-exec.html
        GitHubをアクセストークンで接続するためにこの設定が必要？
          ローカルに$GITHUB_TOKENとprofileの設定を予め行っておく必要がある
          https://docs.aws.amazon.com/ja_jp/codebuild/latest/userguide/access-tokens.html#access-tokens-github-cli
   */
  provisioner "local-exec" {
    command = <<-EOT
      aws codebuild import-source-credentials \
        --server-type GITHUB \
        --auth-type PERSONAL_ACCESS_TOKEN \
        --token $GITHUB_TOKEN \
        --profile terraform
    EOT

    environment = {
      GITHUB_TOKEN = data.aws_ssm_parameter.github_token.value
    }
  }
}

/*
    CodeBuildでHookできるイベントを設定する
      GitHubで発生したイベントをCodeBuildで検知できるようにするための設定
 */
resource "aws_codebuild_webhook" "continuous_apply" {
  project_name = aws_codebuild_project.continuous_apply.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED"
    }
  }

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_UPDATED"
    }
  }

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}
