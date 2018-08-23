node("docker-test") {
  checkout scm

  stage("Deploy MongoDB") {
    sh "hostname"
    sh 'docker stack deploy --compose-file docker_compose.yml mongoDBStack'
    sh 'bash init_replication.sh'
    sh 'bash deploy_mongo_express_gui.sh'
  }
}
