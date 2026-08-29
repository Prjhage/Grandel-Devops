# destroy.ps1 — Run this AFTER your FA demo to stop AWS charges!
# Run from project root: .\destroy.ps1

Write-Host "=======================================" -ForegroundColor Red
Write-Host "  DESTROYING AWS EC2 INFRASTRUCTURE   " -ForegroundColor Red
Write-Host "  This stops all AWS charges!          " -ForegroundColor Red  
Write-Host "=======================================" -ForegroundColor Red
Write-Host ""
Write-Host "Are you sure you want to destroy the EC2 server?" -ForegroundColor Yellow
Write-Host "Type 'yes' to continue or anything else to cancel:" -ForegroundColor Yellow
$confirm = Read-Host

if ($confirm -eq "yes") {
    Set-Location terraform
    .\terraform destroy -auto-approve
    Set-Location ..
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Green
    Write-Host "  EC2 Destroyed! No more AWS charges! " -ForegroundColor Green
    Write-Host "=======================================" -ForegroundColor Green
} else {
    Write-Host "Cancelled. EC2 is still running." -ForegroundColor Cyan
}
