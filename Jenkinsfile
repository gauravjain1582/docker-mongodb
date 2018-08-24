node("docker-test") {
  checkout scm

  stage("Deploy MongoDB") {
    sh "hostname"
    sh 'docker stack deploy --compose-file docker_compose.yml mongoDBStack'
    sh 'ls -ltr ${WORKSPACE}'
    sh 'pwd'
    sh 'find / -name init_replication.sh'
    sh '${WORKSPACE}/init_replication.sh'
    sh 'deploy_mongo_express_gui.sh'
  }
}
