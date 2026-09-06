[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$clientId = "Iv1.8a61f9b3a7aba766"
$scope = "repo"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  SITE VITRINE - DEPLOIEMENT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Device code flow
$authData = @{client_id = $clientId; scope = $scope} | ConvertTo-Json
$req = [System.Net.HttpWebRequest]::Create("https://github.com/login/device/code")
$req.Method = "POST"
$req.ContentType = "application/json"
$req.Accept = "application/json"
$stream = $req.GetRequestStream()
$stream.Write([System.Text.Encoding]::UTF8.GetBytes($authData), 0, $authData.Length)
$stream.Close()
try {
    $resp = $req.GetResponse()
    $reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
    $device = $reader.ReadToEnd() | ConvertFrom-Json
    $reader.Close()
} catch {
    Write-Host "Erreur: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "METHODE ALTERNATIVE :" -ForegroundColor Yellow
    Write-Host "1. Allez sur https://app.netlify.com/drop" -ForegroundColor White
    Write-Host "2. Glissez-déposez le dossier" -ForegroundColor White
    Write-Host "   C:\Users\Andrew\Documents\projets\site-vitrine" -ForegroundColor White
    Write-Host "3. C'est en ligne instantanement !" -ForegroundColor Green
    exit
}

$verificationUrl = $device.verification_uri
$userCode = $device.user_code
$interval = $device.interval

Write-Host "Allez sur : $verificationUrl" -ForegroundColor Yellow
Write-Host "Code : $userCode" -ForegroundColor Yellow
Write-Host ""
Write-Host "En attente..." -ForegroundColor White

$token = $null
for ($i = 0; $i -lt 60; $i++) {
    Start-Sleep -Seconds $interval
    try {
        $pollReq = [System.Net.HttpWebRequest]::Create("https://github.com/login/oauth/access_token?client_id=$clientId&device_code=$($device.device_code)&grant_type=urn:ietf:params:oauth:grant-type:device_code")
        $pollReq.Method = "POST"
        $pollReq.ContentType = "application/json"
        $pollReq.Accept = "application/json"
        $pstream = $pollReq.GetRequestStream()
        $pdata = '{}'
        $pstream.Write([System.Text.Encoding]::UTF8.GetBytes($pdata), 0, $pdata.Length)
        $pstream.Close()
        $presp = $pollReq.GetResponse()
        $preader = New-Object System.IO.StreamReader($presp.GetResponseStream())
        $ptoken = $preader.ReadToEnd() | ConvertFrom-Json
        $preader.Close()
        if ($ptoken.access_token) {
            $token = $ptoken.access_token
            break
        }
    } catch {}
}

if ($token) {
    Write-Host "Authentification OK !" -ForegroundColor Green
    
    # Create repo
    $repoName = "site-vitrine"
    $createReq = [System.Net.HttpWebRequest]::Create("https://api.github.com/user/repos")
    $createReq.Method = "POST"
    $createReq.ContentType = "application/json"
    $createReq.Accept = "application/json"
    $createReq.Headers.Add("Authorization", "Bearer $token")
    $createReq.UserAgent = "site-vitrine-deploy"
    $cdata = @{name = $repoName; private = $false; auto_init = $true} | ConvertTo-Json
    $cstream = $createReq.GetRequestStream()
    $cstream.Write([System.Text.Encoding]::UTF8.GetBytes($cdata), 0, $cdata.Length)
    $cstream.Close()
    try {
        $cresp = $createReq.GetResponse()
        $creader = New-Object System.IO.StreamReader($cresp.GetResponseStream())
        $repo = $creader.ReadToEnd() | ConvertFrom-Json
        $creader.Close()
        Write-Host "Repo cree : https://github.com/$($repo.full_name)" -ForegroundColor Green
        
        # Git push
        $env:PATH = $env:PATH + ";C:\Program Files\Microsoft Visual Studio\18\Professional\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Git\cmd"
        cd "C:\Users\Andrew\Documents\projets\site-vitrine"
        git remote remove origin 2>$null
        git remote add origin "https://github.com/$($repo.full_name).git"
        git branch -M main
        git add .
        git commit -m "Site vitrine professionnel" --amend --no-verify 2>$null
        git push -u origin main --force 2>&1
        
        # GitHub Pages workflow
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
        Write-Host "URL : https://$($repo.owner.login).github.io/$repoName/" -ForegroundColor Yellow
        Write-Host "Repo : https://github.com/$($repo.full_name)" -ForegroundColor Yellow
    } catch {
        Write-Host "Erreur repo : $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Methode alternative : https://app.netlify.com/drop" -ForegroundColor Yellow
    }
} else {
    Write-Host "Authentification echue." -ForegroundColor Red
    Write-Host "Alternative : https://app.netlify.com/drop" -ForegroundColor Yellow
}
Read-Host "Appuyez sur Entree"
