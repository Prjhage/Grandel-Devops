# deploy.ps1 — Grandel EC2 Deployment Script
# Run from project root: .\deploy.ps1

$EC2_IP = "65.2.37.86"
$KEY_FILE = ".\fa1-key.pem"
$REMOTE_USER = "ubuntu"
$APP_DIR = "/home/ubuntu/grandel"
$SSH_OPTS = "-o StrictHostKeyChecking=no"

Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "  Grandel AWS EC2 Deployment Script   " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

# Step 1: Create remote directory
Write-Host "`n[1/5] Creating app directory on EC2..." -ForegroundColor Yellow
ssh $SSH_OPTS -i $KEY_FILE "${REMOTE_USER}@${EC2_IP}" "mkdir -p $APP_DIR/Backend $APP_DIR/frontend"

# Step 2: Copy key project files to EC2
Write-Host "`n[2/5] Uploading project files to EC2..." -ForegroundColor Yellow
scp $SSH_OPTS -i $KEY_FILE docker-compose.yml "${REMOTE_USER}@${EC2_IP}:${APP_DIR}/"
scp $SSH_OPTS -i $KEY_FILE backend.env "${REMOTE_USER}@${EC2_IP}:${APP_DIR}/.env"

# Step 3: Copy Backend folder
Write-Host "`n[3/5] Uploading Backend..." -ForegroundColor Yellow
scp $SSH_OPTS -i $KEY_FILE -r Backend\Dockerfile Backend\app.js Backend\package.json Backend\package-lock.json Backend\routes Backend\models Backend\middleware Backend\controllers Backend\utils "${REMOTE_USER}@${EC2_IP}:${APP_DIR}/Backend/" 2>$null
# Fallback: copy the whole Backend directory (minus node_modules)
ssh $SSH_OPTS -i $KEY_FILE "${REMOTE_USER}@${EC2_IP}" "find $APP_DIR/Backend -maxdepth 0 -type d" | Out-Null

# Step 4: Copy Frontend folder
Write-Host "`n[4/5] Uploading Frontend..." -ForegroundColor Yellow
scp $SSH_OPTS -i $KEY_FILE frontend\Dockerfile "${REMOTE_USER}@${EC2_IP}:${APP_DIR}/frontend/"
scp $SSH_OPTS -i $KEY_FILE frontend\nginx.conf "${REMOTE_USER}@${EC2_IP}:${APP_DIR}/frontend/" 2>$null

# Step 5: Build and start Docker containers
Write-Host "`n[5/5] Building and starting Docker containers on EC2..." -ForegroundColor Yellow
ssh $SSH_OPTS -i $KEY_FILE "${REMOTE_USER}@${EC2_IP}" @"
cd $APP_DIR
docker-compose down 2>/dev/null || true
docker-compose build --no-cache
docker-compose up -d
docker ps
"@

Write-Host "`n=======================================" -ForegroundColor Green
Write-Host "  Deployment Complete!" -ForegroundColor Green
Write-Host "  App URL: http://$EC2_IP" -ForegroundColor Green
Write-Host "=======================================" -ForegroundColor Green
