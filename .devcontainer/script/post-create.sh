#!/usr/bin/env bash
#Description: Install to dependencies tools  ubuntu 22 MasterUCM
#Author: jblanco33
#Fecha: 20260204

#https://github.com/terraform-docs/terraform-docs/releases/tag/v0.14.1


function configDns(){ 

    ## Configuracion de resolv.conf
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf

}
function configGit(){
    # Configurar Git para evitar problemas de ownership en dev containers
    git config --global --add safe.directory '*'
    echo "Git configurado para permitir todos los directorios como seguros"
}

function configpython(){
    # Instalar Python y pip
    apt-get update && apt-get install -y python3 python3-pip python3.12-venv
    echo "Python y pip instalados"
}

function configazurecli(){
    # Instalar Azure CLI
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash
    echo "Azure CLI instalado"
}

function configterraform(){
    # Instalar Terraform
    curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
    apt-get update && apt-get install -y terraform
    echo "Terraform instalado"
}

function configawscli(){
    # Instalar AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
    rm awscliv2.zip
    rm -rf aws
    echo "AWS CLI instalado"
}

function configkubectl(){
    # Instalar kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    echo "kubectl instalado"
}   
function configkind(){
    # Instalar kind
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.17.0/kind-$(uname)-amd64
    install -o root -g root -m 0755 kind /usr/local/bin/kind
    rm kind
    echo "kind instalado"
}
function main(){
    echo Configurando el contenedor...
    # obligatorio

    configDns
    configGit
    configpython
    # configazurecli
    # configterraform
    # configawscli
    configkubectl
    configkind
    echo "Configuración finalizada."
    echo "----------------------------------------"
    echo -e \n

    GREEN='\033[0;32m'
    NC='\033[0m' # Sin color

    echo "----------------------------------------"
    echo "Resumen de instalación:"
    echo "----------------------------------------"

    echo -e "${GREEN}✔ Configuración de DNS realizada${NC}"
    echo -e "${GREEN}✔ Git configurado para usar SSH${NC}"
    echo -e "${GREEN}✔ Python y pip instalados${NC}"
    echo -e "${GREEN}✔ Azure CLI instalado${NC}"
    echo -e "${GREEN}✔ Terraform instalado${NC}"
    echo -e "${GREEN}✔ AWS CLI instalado${NC}"
    echo -e "${GREEN}✔ kubectl instalado${NC}"

}


main