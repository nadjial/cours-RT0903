#!/bin/bash

## les variables 
repertoire="119220/mg"
nom="$repertoire"
namespace=mbang-stephane
deployment="dep"
#nom1="$repertoire:${TRAVIS_COMMIT::6}"
#nom="$repertoire"
svc="travis-cv"
public_tcp_port=8080
private_tcp_port=8000

## le Build 
echo "le nom de l'image build : $nom"

## Build image & push sur docker hub
echo "Kaloubol@10" | docker login -u "119220" --password-stdin
docker build -t $nom .
docker push $nom

## l'utilisation de l'image docker créé pour la creation et le deployement dans mon namespace(kubernetes)

#gcloud  Authentification 
gcloud auth activate-service-account --key-file=key.json

# assignatiion du  projet 'amnay-275801' comme current projet
gcloud config set project amnay-275801

# recuperation du  credentials de connexion au cluster Kubernetes
gcloud container clusters get-credentials --zone=europe-west4-c my-first-cluster-1

# demarrage sur namespace personel
kubectl config set-context --current --namespace=mbang-stephane

#  création  du déploiement avec l'image docker (1fois, renvoie already create si existant)
kubectl create deployment "$deployment" --image=$nom--replicas=3
# on crée le service (1fois, renvoie already create si existant)
kubectl create service clusterip $svc --tcp=8080:8000

# on récupère le deployment en yaml
kubectl get deployment "$deployment" -o yaml >> dpl.yaml
# on remplace le nom de l'image par le nom de la nouvelle image (le numéro de ligne change en fonction de la longueur de la dernière config appliquée)
sed -i -E "s/119220\/mg:[a-z0-9]+/119220\/mg:${TRAVIS_COMMIT::6}/" dpl.yaml

# Update deployment config
kubectl apply -f dpl.yaml
