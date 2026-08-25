$port = 3000

# Check Node.js
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) {
    Write-Host "ERROR: Node.js is not installed or not in PATH." -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/"
    exit 1
}

# Find the local network IP address
try {
    $ip = (Test-Connection -ComputerName (hostname) -Count 1 -ErrorAction Stop).IPV4Address.IPAddressToString
} catch {
    $ip = $null
}

if (-not $ip) {
    $ip = (Get-NetIPAddress -AddressFamily IPv4 |
           Where-Object { $_.IPAddress -notlike '127.*' -and $_.IPAddress -notlike '169.254.*' -and $_.PrefixOrigin -eq 'Dhcp' } |
           Select-Object -First 1).IPAddress
}

if (-not $ip) {
    $ip = "localhost"
}

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Nabawi Competition Server is starting..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Local:       http://localhost:$port" -ForegroundColor Green
Write-Host "  Network:     http://${ip}:$port" -ForegroundColor Yellow
Write-Host "  Winners API: http://${ip}:$port/winners" -ForegroundColor Yellow
Write-Host "  Data file:   winners.json" -ForegroundColor Gray
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Press Ctrl+C to stop the server" -ForegroundColor Magenta
Write-Host "============================================" -ForegroundColor Cyan

# Try to open the browser on the server computer
try {
    Start-Process "http://localhost:$port" -ErrorAction SilentlyContinue
} catch {
    # Ignore if browser cannot be opened automatically
}

# Start the server
node server.js
