# Used for test purpose, should run on server
# Need https://github.com/cloudbase/powershell-yaml on windows
$secret=kubectl get sa debug-user -o 'jsonpath={.secrets[0].name}'  
$token=kubectl get secret $secret -o 'jsonpath={.data.token}' | base64 -d
$configYaml=kubectl config view --flatten --minify | out-string
$config = ConvertFrom-Yaml $configYaml -AllDocuments
$config.contexts[0].context.user='debug-user'
$config.contexts[0].name=$config.clusters[0].name
$config['current-context']=$config.clusters[0].name
$config.users[0].name='debug-user'
$config.users[0].user.token=$token
$config.users[0].user.remove('client-certificate-data')
$config.users[0].user.remove('client-key-data')
ConvertTo-Yaml $config > debug.kubeconfig
$podname=kubectl get pod -l azure/app=spring-petclinic -o 'jsonpath={.items[0].metadata.name}'


# run on client
kubectl --kubeconfig .\debug.kubeconfig port-forward $podname 8787:8787