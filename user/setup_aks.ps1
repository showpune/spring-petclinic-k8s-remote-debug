az account set --subscription d51e3ffe-6b84-49cd-b426-0dc4ec660356
az aks get-credentials --resource-group zhiyonglidataflow --name debug-performance-test --admin
$appselector='app=petclinic'
$serverIp = kubectl get svc -l $appselector -o 'jsonpath={.items[0].status.loadBalancer.ingress[0].ip}'
./setup_common.ps1