[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$env:PATH = $env:PATH + ";C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
cd "C:\Users\Andrew\Documents\projets\site-vitrine"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  SITE VITRINE - DEPLOIEMENT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Ouvrez ce lien : github.com/login/device" -ForegroundColor Yellow
Write-Host "Entrez le code qui s'affiche" -ForegroundColor Yellow
Write-Host ""

gh auth login --hostname github.com --clipboard --git-protocol https

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Authentification OK !" -ForegroundColor Green
    
    # Create or get repo
    $repoName = "site-vitrine"
    $userInfo = gh api user --jq '.login' 2>$null
    
    # Create repo
    gh repo create $repoName --public --source=. --remote=origin --push --force 2>$null
    if ($LASTEXITCODE -ne 0) {
        gh repo create $repoName --public --source=. --remote=origin --push --force 2>$null
    }
    
    # Add Pages workflow
    $ghDir = ".github\workflows"
    if (!(Test-Path $ghDir)) { New-Item -ItemType Directory -Path $ghDir -Force | Out-Null }
    $wf = @"
name: Deploy to GitHub Pages
on:
  push:
    branches: [main]
permissions:
  contents: read
  pages: write
  id-token: write
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/configure-pages@v4
      - uses: actions/upload-pages-artifact@v3
        with:
          path: '.'
      - uses: actions/deploy-pages@v4
"@
    $wf | Out-File -FilePath "$ghDir\pages.yml" -Encoding UTF8
    git add .github/workflows/pages.yml
    git commit -m "Add Pages workflow" --amend --no-verify 2>$null
    git push --force 2>&1
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  SITE EN LIGNE !" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "URL : https://$userInfo.github.io/$repoName/" -ForegroundColor Yellow
    Write-Host "Repo : https://github.com/$userInfo/$repoName" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Si la page n'apparait pas, allez sur le repo -> Settings -> Pages" -ForegroundColor White
    Write-Host "Source: main -> Save" -ForegroundColor White
} else {
    Write-Host ""
    Write-Host "Authentification echue." -ForegroundColor Red
    Write-Host "Alternative : https://app.netlify.com/drop" -ForegroundColor Yellow
    Write-Host "Glissez-déposez le dossier site-vitrine" -ForegroundColor White
}
Read-Host "Appuyez sur Entree"
