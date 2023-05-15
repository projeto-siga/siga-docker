# Função para exibir as opções disponíveis
function exibir_opcoes {
    Write-Host "Escolha uma opção:"
    Write-Host ""
    Write-Host "1. Exibir lista de branches"
    Write-Host "2. Executar SIGA"
    Write-Host "3. Sair"
    Write-Host ""
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

    if (Test-Path "siga-docker") {
        Write-Host ""
        Write-Host "Atualizando siga docker..."
        Write-Host ""
        Set-Location "siga-docker"
        git pull
    } else {
        Write-Host ""
        Write-Host "Clonando siga docker..."
        Write-Host ""
        git clone https://github.com/projeto-siga/siga-docker
        Set-Location "siga-docker"
    }

    Write-Host ""
    Write-Host "Executando docker-compose para o Branch $branch..."
    Write-Host ""
    Write-Host "Removendo imagens antigas do siga"
    docker rmi -f "siga-docker-appserver"
    Write-Host ""
    Write-Host "Iniciando SIGA"
    Write-Host ""
    docker-compose up

    Write-Host ""
}

Clear-Host

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
