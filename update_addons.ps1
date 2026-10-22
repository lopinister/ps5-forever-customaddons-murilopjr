$jsonPath = "addons.json"
$addonsData = Get-Content $jsonPath | ConvertFrom-Json

# Exemplo: Monitorando um addon hospedado publicamente no GitHub
$repoOriginal = "deadlybossmods/dbm-classic" # Altere para o repositório do addon desejado
$apiUrl = "https://api.github.com/repos/$repoOriginal/releases/latest"
$response = Invoke-RestMethod -Uri $apiUrl -ErrorAction SilentlyContinue

if ($response) {
    $latestVersion = $response.tag_name
    # Pega o link do primeiro arquivo .zip atrelado à release
    $downloadUrl = ($response.assets | Where-Object { $_.name -like "*.zip" })[0].browser_download_url

    foreach ($addon in $addonsData.addons) {
        if ($addon.id -eq "exemplo-addon-github" -and $addon.version -ne $latestVersion) {
            $addon.version = $latestVersion
            $addon.downloadUrl = $downloadUrl
            Write-Host "Atualizando $($addon.name) para a versão $latestVersion"
        }
    }
}

# Salva o arquivo sobrescrevendo a versão antiga
$addonsData | ConvertTo-Json -Depth 10 | Set-Content $jsonPath
