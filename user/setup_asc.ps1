az account set --subscription d51e3ffe-6b84-49cd-b426-0dc4ec660356
az aks get-credentials --resource-group cached-211cddea37bc4d6d9467fdd8a91f134 --name 211cddea37bc4d6d9467fdd8a91f134 --admin
$appselector='azure/app=spring-petclinic'
$serverIp ='zhiyonglidebug-spring-petclinic.asc-test.net'

./setup_common.ps1