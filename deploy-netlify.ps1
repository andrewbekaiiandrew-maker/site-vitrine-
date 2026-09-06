Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  NETLIFY - DEPLOIEMENT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Deploiement en cours..." -ForegroundColor Yellow
Write-Host ""

# Deploy with auth token
$env:NETLIFY_AUTH_TOKEN = "nfc_Xewkc9LKzhduN5LbCnunfeSePiZgqbxh7858"
node "C:\Users\Andrew\AppData\Roaming\npm\node_modules\netlify-cli\bin\run.js" deploy --dir="C:\Users\Andrew\Documents\projets\site-vitrine" --prod 2>&1

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  TERMINE !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Read-Host "Appuyez sur Entree"
