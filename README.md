# Catálogo Customizado de Addons para ps5-forever

Este repositório mantém um catálogo JSON e um sistema de automação para instalar e atualizar addons do World of Warcraft no PS5 através do launcher `ps5-forever`. Um script verifica diariamente os repositórios oficiais e atualiza os links de download para contornar limitações de tamanho e bloqueios de API.

**Como Utilizar no PS5**
1. No menu do launcher `ps5-forever`, abra a página de **Add-ons** e vá até ao separador **Find**.
2. Selecione a opção **Add from GitHub link...**.
3. Insira o link direto para o ficheiro JSON deste repositório (abra o `addons.json`, clique em "Raw" e copie o URL do navegador). O launcher irá juntar esta lista ao catálogo oficial.

**Como Adicionar Novos Addons**
Para incluir um novo addon na automação, edite os seguintes ficheiros diretamente no GitHub:

**Passo 1: Atualizar o addons.json**
Adicione um novo bloco dentro da lista `"addons"` contendo as informações visuais do addon. Mantenha os campos de versão e URL vazios ou zerados, pois o script irá preenchê-los.
{
  "id": "meu-novo-addon",
  "name": "Nome do Addon",
  "author": "Nome do Autor",
  "version": "0.0.0",
  "description": "Descrição curta do que o addon faz.",
  "downloadUrl": "",
  "size": "Unknown"
}

**Passo 2: Atualizar o update_addons.ps1**
No topo do ficheiro, adicione uma nova linha à matriz `$addonConfigs` para associar o `id` criado no JSON ao repositório original onde a release é publicada.
@{ id = "meu-novo-addon"; repo = "autorOriginal/nomeDoRepositorio"; match = "*.zip"; exclude = "" }

Após guardar (Commit), o GitHub Actions fará a extração do link correto no próximo ciclo agendado, ou pode acionar a atualização manualmente no separador **Actions**.
