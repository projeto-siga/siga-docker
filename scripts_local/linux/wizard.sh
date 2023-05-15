#!/bin/bash

# Função para exibir as opções disponíveis
exibir_opcoes() {
    echo "Escolha uma opção:"
	echo ""
    echo "1. Exibir lista de branches"
    echo "2. Executar SIGA"
    echo "3. Sair"
    echo
}

# Função para exibir a lista de branches
exibir_branches() {
    echo "Obtendo a lista de branches..."
    branches=""

    for page in {1..3}; do
        result=$(curl -s "https://api.github.com/repos/projeto-siga/siga/branches?per_page=100&page=$page" | grep -o '"name": "[^"]*' | awk -F'"' '{print $4}')
        branches="$branches$result"
    done
	
    if [ -n "$branches" ]; then
        echo "Branches disponíveis:"
        echo "$branches"
    else
        echo "Não foi possível obter a lista de branches."
    fi
    
    echo
}

	# Função para fazer checkout em um branch
executar_SIGA() {
    echo "Digite o nome do branch:"
    read branch
	
	if [ -z "$branch" ]; then
		echo "A Branch não foi escolhida, setando branch default master"
		export BRANCH=master
		echo ""
		sleep 3
	else
		export BRANCH=$branch
	fi
    
	
    if [ -d "siga-docker" ]; then
	    echo ""
	    echo "Atualizando siga docker..."	
		echo ""
        cd siga-docker		
	    git pull
    else
	    echo ""
        echo "Clonando siga docker..."	
        echo ""		
		git clone https://github.com/projeto-siga/siga-docker
		cd siga-docker
    fi
    

    echo ""
    echo "Executando docker-compose para o Branch $branch..."
    echo ""
	echo "Removendo imagens antigas do siga"
	docker rmi -f "siga-docker-appserver"
	echo ""
	echo "Iniciando SIGA"
	echo ""
	docker-compose up
	
    echo
}

clear

echo " "
echo "   _____ _                   ____             __            "
echo "  / ___/(_)___ _____ _      / __ \____  _____/ /_____  _____"
echo "  \__ \/ / __ '/ __ '/_____/ / / / __ \/ ___/ //_/ _ \/ ___/"
echo " ___/ / / /_/ / /_/ /_____/ /_/ / /_/ / /__/ ,< /  __/ /    "
echo "/____/_/\__,_/\__,_/     /_____/\____/\___/_/|_|\___/_/     "
echo "       /____/                                          "
echo " "
echo " "

# Loop principal do wizard
while true; do
    exibir_opcoes
    read -p "Opção selecionada: " opcao
    
    case $opcao in
        1)
            exibir_branches
            ;;
        2)
            executar_SIGA
            ;;
        3)
            echo "Saindo..."
            break
            ;;
        *)
            echo "Opção inválida. Tente novamente."
            ;;
    esac
done
