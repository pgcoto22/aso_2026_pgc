# =========================================================================
# PRÁCTICA PR0405: Limpieza de logs web y privacidad
# =========================================================================

# 1. Datos de entrada
$logsWeb = @"
POST /api/v1/auth/login?session=a8f93j2&token=expired [IP: 192.168.10.45] [Agent: Mozilla/5.0] [ERR-0040-AUTH]
GET /api/v2/products/search?q=laptop&sort=asc [IP: 10.0.2.15] [Agent: Chrome/110.0] [ERR-0200-OK]
DELETE /api/v1/admin/drop_table?confirm=true&force=1 [IP: 172.16.254.88] [Agent: ScriptBot/1.2] [ERR-0500-FATAL]
GET /api/v1/user/profile?id=9921&token=xyz [IP: 192.168.10.102] [Agent: Firefox/109.0] [ERR-0403-FORBIDDEN]
"@

$lineas = $logsWeb -split '\r?\n'

$auditoria = foreach ($linea in $lineas) {
    $linea = $linea.Trim()
    
    # --- FILTRADO (Requisito 4) ---
    # Ignoramos líneas vacías o peticiones correctas (0200-OK)
    if ($linea -eq "" -or $linea.Contains("ERR-0200-OK")) {
        continue
    }

    # El truco: Rompemos la línea entera por el corchete de apertura '['.
    # Esto nos crea 4 cajones casi perfectos que solo hay que limpiar un poco.
    $bloques = $linea.Split('[')

    # --- MÉTODO Y RUTA (Requisito 1) ---
    # $bloques[0] contiene: "POST /api/v1/auth/login?session=a... "
    # Primero cortamos por el espacio en blanco para separar el GET/POST de la URL
    $partesRuta = $bloques[0].Trim().Split(' ')
    $method = $partesRuta[0]
    
    # Para la ruta limpia, cortamos por la interrogación (?) y nos quedamos con el lado izquierdo [0]
    $cleanPath = $partesRuta[1].Split('?')[0]


    # --- ENMASCARAMIENTO IP (Requisito 2) ---
    # $bloques[1] contiene: "IP: 192.168.10.45] "
    # Limpiamos el texto que sobra con Replace
    $ipCruda = $bloques[1].Replace("IP: ", "").Replace("] ", "").Trim()
    
    # Para ocultar el último bloque, troceamos la IP por los puntos
    $octetos = $ipCruda.Split('.')
    # Y reconstruimos la IP juntando los 3 primeros cajones y poniendo asteriscos fijos al final
    $maskedIp = "$($octetos[0]).$($octetos[1]).$($octetos[2]).***"


    # --- AGENTE ---
    # $bloques[2] contiene: "Agent: Mozilla/5.0] "
    $agent = $bloques[2].Replace("Agent: ", "").Replace("] ", "").Trim()


    # --- CÓDIGO DE ERROR (Requisito 3) ---
    # $bloques[3] contiene: "ERR-0040-AUTH]"
    $errorCrudo = $bloques[3].Replace("]", "").Trim()
    
    # Cortamos por el guion '-' y cogemos el cajón central [1] (donde están los números)
    $errorCode = $errorCrudo.Split('-')[1]


    # --- SALIDA ESTRUCTURADA (Requisito 5) ---
    # Montamos el objeto respetando el nombre exacto de las columnas de la imagen
    [PSCustomObject]@{
        Method    = $method
        CleanPath = $cleanPath
        MaskedIP  = $maskedIp
        ErrorCode = $errorCode
        Agent     = $agent
    }
}

# Exportamos a CSV
$auditoria | Export-Csv "auditoria_web.csv" -NoTypeInformation -Encoding UTF8

# Mostramos por consola para tu captura
$auditoria | Format-Table