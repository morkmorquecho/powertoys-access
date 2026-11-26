# Ruta del JSON: está en la misma carpeta que este script
$archivoJson = Join-Path $PSScriptRoot "accesos.json"

if (-not (Test-Path $archivoJson)) {
    Write-Host "No encuentro el archivo: $archivoJson" -ForegroundColor Red
    exit 1
}

# Lee el JSON; si tiene un error de formato, avisa y se detiene
try {
    $accesos = Get-Content $archivoJson -Raw -Encoding UTF8 | ConvertFrom-Json
} catch {
    Write-Host "El JSON tiene un error de formato: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

if ($null -eq $accesos) {
    Write-Host "El JSON está vacío, no se hizo ningún cambio." -ForegroundColor Yellow
    exit 1
}

# Carpeta "Accesos" dentro del Menú Inicio (la que indexa PowerToys Run)
$carpeta = Join-Path ([Environment]::GetFolderPath("Programs")) "Accesos"
New-Item -ItemType Directory -Path $carpeta -Force | Out-Null

$shell = New-Object -ComObject WScript.Shell
$archivosEsperados = @()

# Crea o actualiza un acceso .lnk por cada entrada del JSON
foreach ($item in $accesos.PSObject.Properties) {
    $nombre = $item.Name
    $url = $item.Value
    $archivosEsperados += "$nombre.lnk"

    $lnk = $shell.CreateShortcut((Join-Path $carpeta "$nombre.lnk"))
    $lnk.TargetPath = "cmd.exe"
    $lnk.Arguments = "/c start `"`" `"$url`""
    $lnk.WindowStyle = 7
    $lnk.Save()
    Write-Host "OK  $nombre -> $url" -ForegroundColor Green
}

# Borra los accesos que ya no están en el JSON
Get-ChildItem $carpeta -File |
    Where-Object { $_.Extension -in ".lnk", ".url" -and $_.Name -notin $archivosEsperados } |
    ForEach-Object {
        Remove-Item $_.FullName
        Write-Host "DEL $($_.Name)" -ForegroundColor Yellow
    }

Write-Host "`nListo. Accesos sincronizados en: $carpeta"