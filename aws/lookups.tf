#
# Service name variant lookup
#
locals {
  lookups = {
    codecommit   = { title = "CodeCommit",   dash = "Code-Commit",   dot = "Code.Commit"   }
    codebuild    = { title = "CodeBuild",    dash = "Code-Build",    dot = "Code.Build"    }
    codedeploy   = { title = "CodeDeploy",   dash = "Code-Deploy",   dot = "Code.Deploy"   }
    codepipeline = { title = "CodePipeline", dash = "Code-Pipeline", dot = "Code.Pipeline" }
  }
}