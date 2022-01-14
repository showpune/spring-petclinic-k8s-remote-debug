#!/usr/bin/env bash

# ==== Resource Group ====
export RESOURCE_GROUP=zhiyonglipetclinic
export REGION=eastasia
export SPRING_CLOUD_SERVICE=zhiyonglipetclinic
export APP_NAME=petclinic

az cloud set -n AzureCloud
az login
az account set -s "Azure Spring Cloud Dogfood Test v3 - TTL = 1 Days"

# ==== JARS ====
export GATEWAY_JAR="target\spring-petclinic-2.6.0-SNAPSHOT.jar"

# ==== Create Resource Group ====
az group create --name ${RESOURCE_GROUP} --location ${REGION}

az configure --defaults \
    group=${RESOURCE_GROUP} \
    location=${REGION} \
    spring-cloud=${SPRING_CLOUD_SERVICE}

# ==== Create Azure Spring Cloud ====
az spring-cloud create --name ${SPRING_CLOUD_SERVICE} \
    --resource-group ${RESOURCE_GROUP} \
    --location ${REGION}

# ==== Create the gateway app ====
az spring-cloud app create --name ${APP_NAME} --instance-count 1 --is-public true \
    --memory 2 \
    --jvm-options='-Xms2048m -Xmx2048m -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:+UseG1GC -Djava.awt.headless=true -Djava.awt.headless=true -Dreactor.netty.http.server.accessLogEnabled=true'

# ==== Build for cloud ====
mvn clean package -DskipTests -Denv=cloud

# ==== Deploy apps ====
az spring-cloud app deploy --name ${APP_NAME} --jar-path ${GATEWAY_JAR}
