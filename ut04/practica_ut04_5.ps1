# =========================================================================
# PRÁCTICA PR0404: Limpieza de logs (Script de Digestión)
# =========================================================================

# 1. Datos de entrada
$logCrudo = @"
[INFO] ID:8842 :: 2023/11/01_10:00 :: User:admin_01 :: Action:Login_Success
[ERROR] ID:9921 :: 2023/11/01_10:05 :: User:guest_user :: Action:Auth_Fail (Pass)
[WARN] ID:8843 :: 2023-11-01 10:15 :: User:dev_team :: Action:Upload_Limit_Exceeded
[CRITICAL] ID:1001 :: 01-11-2023_10:20 :: User:ROOT :: Action:Service_Stop
"@

# Rompemos el texto gigante en una lista de líneas individuales
$lineas = $logCrudo -split '\r?\n'

# Usamos un bucle foreach que guarda automáticamente el resultado en $informe
$informe = foreach ($linea in $lineas) {
    
    # Limpiamos posibles espacios en blanco extra al principio o al final de la línea
    $linea = $linea.Trim()
    
    # --- FILTRADO (Requisito 4) ---
    # Si la línea está vacía o contiene [INFO], la saltamos y pasamos a la siguiente
    if ($linea -eq "" -or $linea.Contains("[INFO]")) {
        continue 
    }
    
    # Troceamos la línea por el delimitador principal '::'
    $bloques = $linea -split "::"
    
    
    # --- GRAVEDAD E ID (Requisito 3) ---
    # $bloques[0] contiene algo como "[ERROR] ID:9921 "
    # Rompemos por ']' -> Cajón 0: "[ERROR" | Cajón 1: " ID:9921 "
    $gravedad = $bloques[0].Split("]")[0].Replace("[", "").Trim()
    $eventId = $bloques[0].Split(":")[1].Trim()
    
    
    # --- NORMALIZACIÓN DE FECHAS (Requisito 1) ---
    # $bloques[1] contiene " 2023/11/01_10:05 " o " 01-11-2023_10:20 "
    # Primero unificamos símbolos: cambiamos '/' por '-' y '_' por espacio
    $fechaCruda = $bloques[1].Trim().Replace("/", "-").Replace("_", " ")
    
    # Separamos la fecha de la hora
    $soloFecha = $fechaCruda.Split(" ")[0]
    $soloHora = $fechaCruda.Split(" ")[1]
    
    # Si la fecha empieza por el día (ej. 01-11-2023, el primer trozo tiene 2 letras), la invertimos
    if ($soloFecha.Split("-")[0].Length -eq 2) {
        $partes = $soloFecha.Split("-")
        $soloFecha = "$($partes[2])-$($partes[1])-$($partes[0])"
    }
    $fechaFinal = "$soloFecha $soloHora"
    
    
    # --- LIMPIEZA DE USUARIOS (Requisito 2) ---
    # $bloques[2] contiene " User:ROOT "
    $usuario = $bloques[2].Split(":")[1].Trim().ToLower()
    
    if ($usuario -eq "root") {
        $usuario = "administrator"
    }
    
    
    # --- EXTRACCIÓN DE ACCIÓN ---
    # $bloques[3] contiene " Action:Auth_Fail (Pass)"
    $accion = $bloques[3].Split(":")[1].Trim()
    
    
    # --- SALIDA ESTRUCTURADA (Requisito 5) ---
    # Construimos el objeto PowerShell que pide el enunciado
    [PSCustomObject]@{
        TimeStamp = $fechaFinal
        Severity  = $gravedad
        User      = $usuario
        EventID   = $eventId
        Action    = $accion
    }
}

# Exportamos el objeto final a CSV (como pide la práctica)
$informe | Export-Csv "reporte_seguridad.csv" -NoTypeInformation -Encoding UTF8

# Mostramos por pantalla la tabla resultante para comprobar que cuadra con la imagen
$informe | Format-Table