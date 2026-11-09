# =========================================================================
# PRÁCTICA PR0402: Variables, tipos de datos y colecciones
# =========================================================================

# -------------------------------------------------------------------------
# Bloque 1: Tipado dinámico, estático y tipos básicos
# -------------------------------------------------------------------------
Write-Host "`n--- EJERCICIO 1 ---"
$recurso = 8080
Write-Host "Tipo inicial: $($recurso.GetType().Name)"
$recurso = "Puerto HTTP"
Write-Host "Tipo tras reasignar: $($recurso.GetType().Name)"

Write-Host "`n--- EJERCICIO 2 ---"
[int]$maxConexiones = 100
[bool]$firewallActivo = $true
Write-Host "Variables guardadas -> Conexiones: $maxConexiones | Firewall: $firewallActivo"

Write-Host "Forzando error de tipado estricto..." -ForegroundColor Yellow
$maxConexiones = "Cien"
# Si ejecutamos $maxConexiones = "Cien", PowerShell devuelve el error:
# No se puede convertir el valor "Cien" al tipo "System.Int32". Error: "La cadena de entrada no tiene el formato correcto."

Write-Host "`n--- EJERCICIO 3 ---"
[long]$tamanoBackup = 2199023255552
[decimal]$costeLicencia = 149.95d
[decimal]$iva = 31.49d
$totalFactura = $costeLicencia + $iva
Write-Host "El total de la factura es: $totalFactura"

Write-Host "`n--- EJERCICIO 4 ---"
$fechaActual = Get-Date
Write-Host "Año actual: $($fechaActual.Year)"
Write-Host "La contraseña caducará el: $($fechaActual.AddDays(45))"

$inicio = Get-Date
Start-Sleep -Seconds 3
$fin = Get-Date
[TimeSpan]$tiempoTotal = $fin - $inicio
Write-Host "Segundos totales transcurridos de la pausa: $($tiempoTotal.TotalSeconds)"


# -------------------------------------------------------------------------
# Bloque 2: Manipulación de cadenas y expresiones regulares
# -------------------------------------------------------------------------
Write-Host "`n--- EJERCICIO 5 ---"
$servicio = "Spooler"
$fecha = Get-Date
Write-Host 'Frase literal con comillas simples: El servicio es $servicio'
Write-Host "Frase expandida: El servicio es $servicio y el día del mes es $($fecha.Day)"

Write-Host "`n--- EJERCICIO 6 ---"
$cadenaFormateada = "El servidor {0} con IP {1} tiene un uso de CPU del {2}%" -f "SRV-WEB01", "10.0.1.15", 85
Write-Host $cadenaFormateada

$alertaCorreo = @"
-------------------------------------------
AVISO TÉCNICO AL ADMINISTRADOR
-------------------------------------------
El servidor SRV-WEB01 con IP 10.0.1.15 tiene un uso de CPU del 85%.
Por favor, revise el estado de los servicios.
"@
Write-Host $alertaCorreo

Write-Host "`n--- EJERCICIO 7 ---"
$lineaLog = "   error_critico;SRV-DB01;192.168.10.50;Puerto_3306   "
$lineaProcesada = $lineaLog.Trim().Replace('_', ' ').ToUpper()
$campos = $lineaProcesada.Split(';')
Write-Host "La dirección IP extraída es: $($campos[2])"

Write-Host "`n--- EJERCICIO 8 ---"
$codigoActivo = "SRV-2026-PROD-99"
Write-Host "¿Empieza por SRV*? $($codigoActivo -like 'SRV*')"
Write-Host "¿Contiene dígitos? $($codigoActivo -match '\d')"
Write-Host "Código con números reemplazados: $($codigoActivo -replace '\d', 'X')"


# -------------------------------------------------------------------------
# Bloque 3: Operadores aritméticos y librería [Math]
# -------------------------------------------------------------------------
Write-Host "`n--- EJERCICIO 9 ---"
$memoriaLibreMB = 3540
$memoriaTotalMB = 16384
$porcentajeMemoria = ($memoriaLibreMB / $memoriaTotalMB) * 100

Write-Host "Porcentaje redondeado al entero más cercano: $([Math]::Round($porcentajeMemoria))%"
Write-Host "Porcentaje redondeado hacia arriba: $([Math]::Ceiling($porcentajeMemoria))%"
Write-Host "Porcentaje redondeado hacia abajo: $([Math]::Floor($porcentajeMemoria))%"
Write-Host "El resto de dividir 16384 entre 1024 es: $(16384 % 1024)"


# -------------------------------------------------------------------------
# Bloque 4: Arrays, ArrayLists y Listas Genéricas
# -------------------------------------------------------------------------
Write-Host "`n--- EJERCICIO 10 ---"
$nodos = @("Nodo1", "Nodo2", "Nodo3", "Nodo4", "Nodo5")
Write-Host "Primer nodo: $($nodos[0])"
Write-Host "Último nodo: $($nodos[-1])"
Write-Host "Total de nodos: $($nodos.Count)"
$subRed = $nodos[0..2]
Write-Host "Nodos extraídos en la subred: $subRed"

Write-Host "`n--- EJERCICIO 11 ---"
$colaImpresion = New-Object System.Collections.ArrayList
[void]$colaImpresion.Add("Factura.pdf")
$null = $colaImpresion.Add("Informe.docx")
$colaImpresion.Add("Nomina.pdf") | Out-Null

$colaImpresion.Insert(0, "Urgente.pdf")
$colaImpresion.Remove("Informe.docx")

if ($colaImpresion.Contains("Nomina.pdf")) {
    Write-Host "El documento Nomina.pdf sigue en la cola de impresión."
}

Write-Host "`n--- EJERCICIO 12 ---"
$listaIPs = New-Object System.Collections.Generic.List[string]
$listaIPs.Add("192.168.1.50")
$listaIPs.Add("10.0.0.1")
$listaIPs.Add("172.16.0.10")
$listaIPs.Add("192.168.1.5")
$listaIPs.Sort()

Write-Host "Iteración con foreach:"
foreach ($ip in $listaIPs) {
    Write-Host "IP: $ip"
}

Write-Host "Iteración con ForEach-Object (pipeline):"
$listaIPs | ForEach-Object {
    Write-Host "La IP $_ tiene $($_.Length) caracteres."
}


# -------------------------------------------------------------------------
# Bloque 5: Tablas Hash, Objetos Personalizados y Splatting
# -------------------------------------------------------------------------
Write-Host "`n--- EJERCICIO 13 ---"
$fichaServidor = @{
    Hostname = "SRV-AD01"
    IP       = "192.168.1.10"
    RAM_GB   = 32
    Critico  = $true
}

$fichaServidor.RAM_GB = 64
$fichaServidor.SO = "Windows Server 2022"
$fichaServidor.Remove("Critico")

foreach ($clave in $fichaServidor.Keys) {
    Write-Host "$clave : $($fichaServidor[$clave])"
}

Write-Host "`n--- EJERCICIO 14 ---"
$objetoServidor = [PSCustomObject]$fichaServidor
$objetoServidor | Export-Csv "servidor.csv" -NoTypeInformation
Write-Host "Se ha exportado el archivo servidor.csv correctamente."

$parametrosCarpeta = @{
    Path     = "C:\Temp"
    Name     = "Logs_ASO"
    ItemType = "Directory"
}
# La siguiente línea ejecuta la creación de la carpeta.
# Descoméntala si quieres crearla físicamente en tu ordenador.
# New-Item @parametrosCarpeta -Force