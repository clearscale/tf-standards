#
# Service name variant lookup
#
locals {
  lookups = {
    codecommit   = { title = "CodeCommit",   dash = "Code-Commit",   dot = "Code.Commit"   }
    codebuild    = { title = "CodeBuild",    dash = "Code-Build",    dot = "Code.Build"    }
    codedeploy   = { title = "CodeDeploy",   dash = "Code-Deploy",   dot = "Code.Deploy"   }
    codepipeline = { title = "CodePipeline", dash = "Code-Pipeline", dot = "Code.Pipeline" }

    # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html
    region = {
      global         ="gb"
      multiregion    = "mr"
      us-east-2      = "use2"
      us-east-1      = "use1"
      us-west-1      = "usw1"
      us-west-2      = "usw2"
      af-south-1     = "afs1"
      ap-east-1      = "ape1"
      ap-south-2     = "aps2"
      ap-southeast-3 = "apse3"
      ap-southeast-4 = "apse4"
      ap-south-1     = "aps1"
      ap-northeast-3 = "apne3"
      ap-northeast-2 = "apne2"
      ap-southeast-1 = "apse1"
      ap-southeast-2 = "apse2"
      ap-northeast-1 = "apne1"
      ca-central-1   = "cac1"
      ca-west-1      = "caw1"
      eu-central-1   = "euc1"
      eu-west-1      = "euw1"
      eu-west-2      = "euw2"
      eu-south-1     = "eus1"
      eu-west-3      = "euw3"
      eu-south-2     = "eus2"
      eu-north-1     = "eun1"
      eu-central-2   = "euc2"
      il-central-1   = "ilc1"
      me-south-1     = "mes1"
      me-central-1   = "mec1"
      sa-east-1      = "sae1"
    }
  }
}