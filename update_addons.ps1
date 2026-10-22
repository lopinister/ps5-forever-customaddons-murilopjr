$jsonPath = "addons.json"
$addonsData = Get-Content $jsonPath -Raw | ConvertFrom-Json

$addonConfigs = @(
    @{ id = "polestar"; repo = "fitzforge/polestar"; match = "*.zip"; exclude = "" },
    @{ id = "spoken"; repo = "rusty-key/spoken-wow"; match = "*.zip"; exclude = "audio" },
    @{ id = "spoken-ptbr"; repo = "rusty-key/spoken-wow"; match = "*ptBR*.zip"; exclude = "" },
    @{ id = "spoken-en"; repo = "rusty-key/spoken-wow"; match = "*audio-en*.zip"; exclude = "" }
)

foreach ($config in $addonConfigs) {
    $apiUrl = "https://api.github.com/repos/$($config.repo)/releases/latest"
    $response = Invoke-RestMethod -Uri $apiUrl -ErrorAction SilentlyContinue

    if ($response) {
        $latestVersion = $response.tag_name
        
        $asset = $response.assets | Where-Object { 
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
        }
    }
}

$addonsData | ConvertTo-Json -Depth 10 | Set-Content $jsonPath
