.DEFAULT_GOAL := help
.PHONY: argocd-install argocd-password argocd-uninstall datakube-install datakube-update datakube-uninstall minikube-start help

argocd-install:
	@helm repo add argo https://argoproj.github.io/argo-helm
	@helm repo update
	helm install argocd argo/argo-cd -f argocd.yaml --wait
	@echo
	@echo 'ArgoCD login:    admin'
	@echo 'ArgoCD password:' $$(kubectl get pods -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
	@kubectl get ingress

argocd-password:
	kubectl get pods -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2

argocd-uninstall:
	helm uninstall argocd

datakube-install:
	kubectl create -f datakube.yaml

datakube-update:
	kubectl apply -f datakube.yaml

datakube-uninstall:
	kubectl delete -f datakube.yaml

minikube-start:
	minikube start --cpus=4 --memory=6g --driver=hyperv --addons=metrics-server --addons=ingress --addons=ingress-dns

help:
	@echo
	@echo 'Supported commands'
	@echo '----------------------'
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
	@echo '----------------------'
	@echo 'Commands auto-completion'
	@echo "   complete -W \"\\\`grep -oE '^[a-zA-Z0-9_.-]+:([^=]|$$)' Makefile | sed 's/[^a-zA-Z0-9_.-]*$$//'\\\`\" make"
