# DATAKUBE
Data Platform on Kubernetes

#### How to start

##### Run `make` to see list of operations
```shell script
$ make

Supported commands
----------------------
argocd-install
argocd-password
argocd-uninstall
datakube-install
datakube-uninstall
datakube-update
minikube-start
----------------------
Commands auto-completion
   complete -W "\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$//'\`" make
```

##### Create/start minikube instance if needed
```shell script
$ make minikube-start
minikube start --cpus=4 --memory=6g --driver=hyperv --addons=metrics-server --addons=ingress --addons=ingress-dns
```

##### Resolve URLs to minikube IP address
To open services by urls in a browser do one of
- Add the minikube ip as a dns server:
    [minikube-ip-as-a-dns-server](https://github.com/kubernetes/minikube/tree/master/deploy/addons/ingress-dns#add-the-minikube-ip-as-a-dns-server)

   OR

- Append mappings to `etc/hosts` file 
    ```shell script
    $ echo $(minikube ip) argocd.minikube prometheus.minikube grafana.minikube minio.minikube airflow.minikube spark-history.minikube
    172.25.75.177 argocd.minikube prometheus.minikube grafana.minikube minio.minikube airflow.minikube spark-history.minikube
    ```

##### Install ArgoCD
```shell script
$ make argocd-install
 .........
helm install argocd argo/argo-cd -f argocd.yaml --wait
NAME: argocd
LAST DEPLOYED: Mon Sep 28 00:47:26 2020
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
 .........
ArgoCD login:    admin
ArgoCD password: argocd-server-6c7748b66d-jlv4s
NAME            CLASS    HOSTS             ADDRESS         PORTS   AGE
argocd-server   <none>   argocd.minikube   172.25.75.177   80      21s
```

##### ArgoCD UI
In browser open http://argocd.minikube and use login/password from previous step output

##### Install datakube
```shell script
$ make datakube-install
```

##### Smoke tests
- Check datakube installation status http://argocd.minikube
- Check prometheus access http://prometheus.minikube
- Check grafana(admin/admin) dashboards http://grafana.minikube
- Check minio(YOURACCESSKEY/YOURSECRETKEY) http://minio.minikube
- Check airflow by running example DAGs http://airflow.minikube

##### Run example spark application
```shell script
$ kubectl create -f example/spark-minio.yaml -n datakube
$ kubectl get pod -n datakube -w
```
After spark-pi-driver pod completed run
```shell script
$ kubectl delete -f example/spark-minio.yaml -n datakube
```
Check http://minio.minikube/minio/spark-history

##### Uninstall datakube and argocd
```shell script
$ make datakube-uninstall
$ make argocd-uninstall
```
