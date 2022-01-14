# Clean and init
$debuguser='debug-user'
$debuguserrole='debug-user-role'
$debuguserrolebinding='debug-user-rolebinding'
kubectl delete sa $debuguser
kubectl delete role $debuguserrole
kubectl delete rolebinding $debuguserrolebinding
kubectl apply -f role.yaml
kubectl apply -f service-account.yaml
kubectl apply -f rolebinding.yaml

# Used for test purpose, should run on server
# Need https://github.com/cloudbase/powershell-yaml on windows
$secret=kubectl get sa $debuguser -o 'jsonpath={.secrets[0].name}'  
$token=kubectl get secret $secret -o 'jsonpath={.data.token}' | base64 -d
$configYaml=kubectl config view --flatten --minify | out-string
$config = ConvertFrom-Yaml $configYaml -AllDocuments
$config.contexts[0].context.user=$debuguser
$config.contexts[0].name=$config.clusters[0].name
$config['current-context']=$config.clusters[0].name
$config.users[0].name=$debuguser
$config.users[0].user.token=$token
$config.users[0].user.remove('client-certificate-data')
$config.users[0].user.remove('client-key-data')
ConvertTo-Yaml $config > debug.kubeconfig
$podname=kubectl get pod -l $appselector -o 'jsonpath={.items[0].metadata.name}'


# run on client
kubectl --kubeconfig .\debug.kubeconfig port-forward $podname 8787:8787