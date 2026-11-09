# =========================================================================
# Ejercicio 1: Limpieza básica 
# =========================================================================

# 1. Normalizar a mayúsculas
$sys = "Windows Server"
$sys.ToUpper()

# 2. Normalizar a minúsculas
$user = "ADMINISTRATOR"
$user.ToLower()

# 3. Limpieza de espacios extremos (principio y final)
$ip = " 192.168.1.10 "
$ip.Trim()

# 4. Eliminación total de espacios (cambia espacio ' ' por nada '')
$mac = "00 AA 11 BB 22 CC"
$mac.Replace(" ", "")

# 5. Longitud de la cadena
$pass = "P@ssw0rd123"
$pass.Length


# =========================================================================
# Ejercicio 2: Reemplazo y sustitución (Estilo dinámico con Split)
# =========================================================================

# 6. Cambio de separadores de fecha
$fecha = "2023.10.05"
$fecha.Replace(".", "-")

# 7. Actualización de dominio
$web = "www.miempresa.es"
$web.Replace(".es", ".com")

# 8. Censura de datos (El que hizo el profesor: saca el trozo [3] y lo cambia por XXXX)
$tarjeta = "1234-5678-9012-3456"
$tarjeta.Replace($tarjeta.Split("-")[3], "XXXX")

# 9. Cambio de barra de rutas (Linux a Windows)
$rutaLinux = "/home/usuario/docs"
$rutaLinux.Replace("/", "\")

# 10. Doble reemplazo (Encadenando dos Replace seguidos como pide la pista)
$valor = "(Software)"
$valor.Replace("(", "").Replace(")", "")


# =========================================================================
# Ejercicio 3: Extracción (Usando Split siempre que hay separador porque es más fácil)
# =========================================================================

# 11. Extraer prefijo de país (Cortamos por el guion y cogemos el primer trozo [0])
$tlf = "+34-600111222"
$tlf.Split("-")[0]
# (Si obliga a usar posición: $tlf.Substring(0, 3))

# 12. Extraer año fiscal (Igual: cortamos por guion y cogemos el [0])
$codigo = "2024-FACTURA-SEP"
$codigo.Split("-")[0]
# (Si obliga a usar posición: $codigo.Substring(0, 4))

# 13. Ignorar el primer carácter (Empezamos a cortar en la posición 1 hasta el final)
$idEmpleado = "E55421"
$idEmpleado.Substring(1)

# 14. Extraer extensión de archivo (Mucho más fácil: cortamos por el punto y cogemos el último [-1])
$fichero = "informe.pdf"
$fichero.Split(".")[-1]
# (Si obliga a usar posición: $fichero.Substring($fichero.Length - 3))

# 15. Relleno de ceros (Rellena por la izquierda hasta medir 3 caracteres usando el '0')
$numero = "7"
$numero.PadLeft(3, '0')


# =========================================================================
# Ejercicio 4: Troceado (Split) y arrays
# =========================================================================

# 16. Obtener nombre de usuario desde email (Trozo [0] antes de la @)
$email = "pepe.garcia@empresa.com"
$email.Split("@")[0]

# 17. Obtener dominio desde email (Trozo [1] después de la @)
$email = "pepe.garcia@empresa.com"
$email.Split("@")[1]

# 18. Obtener nombre de archivo de una ruta larga (El [-1] coge siempre el último trozo)
$path = "C:\Users\Admin\Downloads\instaler.msi"
$path.Split("\")[-1]

# 19. Obtener letra de unidad (El [0] coge el primer trozo antes de la primera barra)
$path = "D:\Datos\Backups"
$path.Split("\")[0]

# 20. Separar CSV manual (El [1] es el segundo elemento: Marketing)
$linea = "Juan;Marketing;Madrid"
$linea.Split(";")[1]


# =========================================================================
# Ejercicio 5: Aplicaciones prácticas (Trucos fáciles de una línea)
# =========================================================================

# 21. Detección de usuario Admin
$u = "ADM_Lopez"
$u.StartsWith("ADM")
# (Alternativa de los apuntes: $u -like "ADM*")

# 22. Formato de nombre propio (Primera letra [0] en mayúscula + desde la 1 en minúscula)
$nombre = "JAVIER"
$nombre.Substring(0,1).ToUpper() + $nombre.Substring(1).ToLower()

# 23. Limpieza de Distinguished Name (Doble Split: cortas por coma [0] -> "CN=Beatriz", y cortas por igual [1] -> "Beatriz")
$dn = "CN=Beatriz,OU=Ventas,DC=dominio,DC=local"
$dn.Split(",")[0].Split("=")[1]

# 24. Generador de iniciales (Usando [0] sacas la primera letra directamente sin Substring)
$n = "Fernando"
$a = "Alonso"
"$($n[0]).$($a[0])."

# 25. Inversión de fecha (Troceas por guion y unes los cajones al revés: [2], [1] y [0])
$euDate = "31-12-2023"
$euDate.Split("-")[2] + $euDate.Split("-")[1] + $euDate.Split("-")[0]