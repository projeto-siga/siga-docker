# Função para exibir as opções disponíveis
function exibir_opcoes {
    Write-Host "Escolha uma opção:"
    Write-Host ""
    Write-Host "1. Exibir lista de branches"
    Write-Host "2. Executar SIGA"
    Write-Host "3. Sair"
    Write-Host ""
}

function limpar-Repo {
    # Armazena o valor do comando docker images --filter=reference="*appserver" -q em uma variável
    $images = docker images --filter reference="*appserver" -q

    # Verifica se a variável images contém algum valor
    if ($images) {
        # Executa o comando docker rmi -f com base no valor da variável images
        docker rmi -f $images
        Write-Host "Remoção das imagens com referência '*appserver' concluída."
    } else {
        Write-Host "Nenhuma imagem com referência '*appserver' encontrada para remoção."
    }

    docker rm appserver mysqlserver redisserver emailserver
}

# Função para exibir a lista de branches
function exibir_branches {
	Write-Host ""
    Write-Host "Obtendo a lista de branches..."
	Write-Host ""
    $branches = ""

    for ($page = 1; $page -le 3; $page++) {
        $result = (Invoke-WebRequest -Uri "https://api.github.com/repos/projeto-siga/siga/branches?per_page=100&page=$page" -UseBasicParsing).Content | ConvertFrom-Json
        $branchNames = $result.name

        foreach ($branchName in $branchNames) {
            $branches += $branchName + "`n"
        }
    }

    if ($branches -ne "") {
		Write-Host ""
        Write-Host "Branches disponíveis:"
		Write-Host ""
        Write-Host $branches
    } else {
        Write-Host "Não foi possível obter a lista de branches."
    }

    Write-Host
}

# Função para fazer checkout em um branch
function executar_SIGA {
    Write-Host "Digite o nome do branch:"
    $branch = Read-Host

    if ([string]::IsNullOrEmpty($branch)) {
        Write-Host "A Branch não foi escolhida, setando branch default master"
        $env:BRANCH = "master"
        Write-Host ""
        Start-Sleep -Seconds 3
    } else {
        $env:BRANCH = $branch
    }

    Write-Host ""
    Write-Host "Executando docker-compose para o Branch $branch..."
    Write-Host ""
    Write-Host "Removendo imagens antigas do siga"
    limpar-Repo
    Write-Host ""
    Write-Host "Iniciando SIGA"
    Write-Host ""
    docker-compose up

    Write-Host ""
}

[Console]::OutputEncoding =  [System.Text.Encoding]::GetEncoding(1252)

Write-Host " "
Write-Host "   _____ _                   ____             __            "
Write-Host "  / ___/(_)___ _____ _      / __ \____  _____/ /_____  _____"
Write-Host "  \__ \/ / __ '/ __ '/_____/ / / / __ \/ ___/ //_/ _ \/ ___/"
Write-Host " ___/ / / /_/ / /_/ /_____/ /_/ / /_/ / /__/ ,< /  __/ /    "
Write-Host "/____/_/\__,_/\__,_/     /_____/\____/\___/_/|_|\___/_/     "
Write-Host "       /____/                                          "
Write-Host " "
Write-Host " "

# Loop principal do wizard
while ($true) {
    exibir_opcoes
    $opcao = Read-Host "Opção selecionada: "

	Write-Host ""

    switch ($opcao) {
        "1" {
            exibir_branches
            break
        }
        "2" {
            executar_SIGA
            break
        }
        "3" {
            Write-Host "Saindo..."
			exit
            break
        }
        default {
            Write-Host "Opção inválida. Tente novamente."
        }
    }
}