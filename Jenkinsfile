node("docker-test") {
  checkout scm

  stage("Deploy MongoDB") {
    sh "hostname"
    sh 'docker stack deploy --compose-file docker_compose.yml mongoDBStack'
  }
}
