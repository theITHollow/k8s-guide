kubectl create -f https://k8s.io/examples/application/shell-demo.yaml

kubectl exec -it shell-demo -- /bin/bash

### Execute after accessing shell
apt-get update
apt-get install curl
curl external-web