oh-my-posh init pwsh --config "C:\Users\Valentin\AppData\Local\Programs\oh-my-posh\themes\amro.omp.json" | Invoke-Expression
# asd
Register-ArgumentCompleter -CommandName Alumno -ParameterName nombre -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $baseUrl = "G:\.shortcut-targets-by-id\19HcSeozY-s8k8S55nuP3Vue5LHl6j7F9\Alumnos"

    Get-ChildItem -Path $baseUrl -Directory |
        Where-Object { $_.Name -like "$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_.Name, $_.Name, 'ParameterValue', $_.Name
            )
        }
}

# Contenido base para archivos Excalidraw
$contenidoExcalidraw = @'
{
  "type": "excalidraw",
  "version": 2,
  "source": "https://marketplace.visualstudio.com/items?itemName=pomdtr.excalidraw-editor",
  "elements": [],
  "appState": {
    "gridSize": 20,
    "gridStep": 5,
    "gridModeEnabled": false,
    "viewBackgroundColor": "#ffffff"
  },
  "files": {}
}
'@

function Alumno {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$nombre
    )

    $baseUrl = "G:\.shortcut-targets-by-id\19HcSeozY-s8k8S55nuP3Vue5LHl6j7F9\Alumnos"
    $nombreCompleto = $nombre -join " "

    if (-not $nombreCompleto) {
        $nombreCompleto = Read-Host "ℹ️  Escribí el nombre del alumno"
    }

    $rutaExacta = Join-Path -Path $baseUrl -ChildPath $nombreCompleto

    if (-not (Test-Path $rutaExacta)) {
        # Buscar coincidencias parciales
        $coincidencias = Get-ChildItem -Path $baseUrl -Directory |
            Where-Object { $_.Name -like "*$nombreCompleto*" }

        if ($coincidencias.Count -eq 1) {
            $rutaExacta = $coincidencias[0].FullName
            Write-Host "✔ Coincidencia parcial encontrada: $($coincidencias[0].Name)" -ForegroundColor Yellow
        } elseif ($coincidencias.Count -gt 1) {
            Write-Host "⚠️  Varias coincidencias encontradas para '$nombreCompleto':" -ForegroundColor Yellow
            $coincidencias | ForEach-Object { " - $($_.Name)" }
            return
        } else {
            Write-Host "❌ La carpeta no existe: $nombreCompleto`n" -ForegroundColor Red
            return
        }
    }

    Write-Host "✔ Carpeta encontrada: $nombreCompleto" -ForegroundColor Green
    Set-Clipboard -Value $rutaExacta
    Write-Host "📋 Ruta copiada al portapapeles." -ForegroundColor Cyan

    # Preguntar si quiere crear una pizarra
    $crearPizarra = Read-Host "`n🧠 ¿Querés crear una nueva pizarra Excalidraw en esta carpeta? (s/n)"
    
    if ($crearPizarra -eq "s" -or $crearPizarra -eq "S") {
        $fecha = Get-Date -Format "dd-MM"
        $nombreArchivo = "$fecha.excalidraw"
        $pizarraPath = Join-Path $rutaExacta $nombreArchivo

        # Si ya existe, buscar el siguiente número disponible
        $contador = 2
        while (Test-Path $pizarraPath) {
            $nombreArchivo = "$fecha ($contador).excalidraw"
            $pizarraPath = Join-Path $rutaExacta $nombreArchivo
            $contador++
        }

        $contenidoExcalidraw | Out-File -Encoding utf8 $pizarraPath
        Write-Host "📝 Pizarra creada: $nombreArchivo" -ForegroundColor Green
    }

    if ($pizarraPath) {
        code -r $rutaExacta
        code -r $pizarraPath
    } else {
        code -r $rutaExacta
    }
}

function z {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Cmd
    )

    $command = $Cmd -join ' '
    wsl zsh -c "$command"
}

