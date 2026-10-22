$jsonPath = "addons.json"
$addonsData = Get-Content $jsonPath -Raw | ConvertFrom-Json

$addonConfigs = @(
    @{ id = "polestar"; repo = "fitzforge/polestar"; match = "*.zip"; exclude = "" },
    @{ id = "spoken"; repo = "rusty-key/spoken-wow"; match = "*.zip"; exclude = "audio" },
    # Filtros ajustados para garantir a captura correta
    @{ id = "spoken-ptbr"; repo = "rusty-key/spoken-wow"; match = "*ptBR*.zip"; exclude = "" },
    @{ id = "spoken-en"; repo = "rusty-key/spoken-wow"; match = "*en*.zip"; exclude = "ptBR" },
    @{ id = "lore-forever"; repo = "mliudev/LoreForever"; match = "*.zip"; exclude = "" }
)

foreach ($config in $addonConfigs) {
    # Parâmetro ?per_page=100 adicionado para consultar o histórico profundo de publicações
    $apiUrl = "https://api.github.com/repos/$($config.repo)/releases?per_page=100"
    $releases = Invoke-RestMethod -Uri $apiUrl -ErrorAction SilentlyContinue

    if ($releases) {
        $assetFound = $false
        foreach ($release in $releases) {
            if ($assetFound) { break }
            
            $latestVersion = $release.tag_name
            $asset = $release.assets | Where-Object { 
                $_.name -like $config.match -and ($config.exclude -eq "" -or $_.name -notmatch $config.exclude) 
            } | Select-Object -First 1

            if ($asset) {
                $downloadUrl = $asset.browser_download_url
                
                foreach ($addon in $addonsData.addons) {
                    if ($addon.id -eq $config.id -and $addon.version -ne $latestVersion) {
                        $addon.version = $latestVersion
                        $addon.downloadUrl = $downloadUrl
                        Write-Host "Atualizando $($addon.name) para a versão $latestVersion"
                    }
                }
                $assetFound = $true
            }
        }
    }
}

$addonsData | ConvertTo-Json -Depth 10 | Set-Content $jsonPath
