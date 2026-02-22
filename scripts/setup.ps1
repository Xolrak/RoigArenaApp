<#########
FUNCTIONS
#########>
function Show-Requirements {
    Write-Host "This script requires:" -ForegroundColor Yellow
    Write-Host "- Virtualization enabled in BIOS." -ForegroundColor Yellow
    Write-Host "- Docker installed." -ForegroundColor Yellow
    Write-Host "- WSL2 with Ubuntu-24.04." -ForegroundColor Yellow
    Write-Host "(You can install Docker and Ubuntu in the next step)" -ForegroundColor Yellow
}
function Install-DockerDesktop {
    Write-Host "Do you want to install Docker Desktop? (y/n)" -ForegroundColor Cyan
    $dockerOption = Read-Host
    $dockerLower = $dockerOption.ToLower()
    if ($dockerLower -eq "y") {
        Write-Host "Installing Docker Desktop..." -ForegroundColor Cyan
        winget --install Docker.DockerDesktop
        Write-Host "Note: If this is the first time running Docker Desktop, you may need to restart your computer." -ForegroundColor Yellow
    } elseif ($dockerLower -eq "n") {
        Write-Host "Skipping Docker installation." -ForegroundColor Yellow
        docker desktop start
    } else {
        Write-Host "Invalid option. Please enter 'y' or 'n'." -ForegroundColor Red
        return
    }
}
function Install-Ubuntu {
    Write-Host "Do you want to install Ubuntu 24.04? (y/n)" -ForegroundColor Cyan
    $option = Read-Host
    $optionLower = $option.ToLower()
    if ($optionLower -eq "y") {
        try {
            wsl --install -d Ubuntu-24.04
            Write-Host "Note: If this is the first time running WSL, you may need to restart your computer." -ForegroundColor Yellow
        }
        catch {
            Write-Host "Error attempting to install Ubuntu: $($_.Exception.Message)" -ForegroundColor Red
        }
    } elseif ($optionLower -eq "n") {
        Write-Host "Skipping Ubuntu installation." -ForegroundColor Yellow
    } else {
        Write-Host "Invalid option. Please enter 'y' or 'n'." -ForegroundColor Red
        return
    }
}
function Install-LaravelWithSail {
    Write-Host "Launching Laravel installer..." -ForegroundColor Cyan
    wsl -d Ubuntu-24.04 -u root -- bash -c 'curl -s "https://laravel.build/RoigArenaApp?with=mysql" | bash'
}
function Install-Dependences {
    Install-DockerDesktop
    Install-Ubuntu
}
function Main {
    Clear-Host
    Show-Requirements
    Install-Dependences
    Install-LaravelWithSail
}

Main