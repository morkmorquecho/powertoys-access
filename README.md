# powertoys-accesos

Accesos rápidos a URLs para **PowerToys Run**. Defines tus enlaces en un archivo JSON y un script de PowerShell crea los accesos directos en el Menú Inicio, para abrirlos escribiendo unas letras.

## Cómo funciona

PowerToys Run indexa los accesos directos (`.lnk`) del Menú Inicio. Este proyecto lee `accesos.json` y, por cada entrada, crea un `.lnk` que abre la URL en tu navegador predeterminado. También elimina los accesos que quitaste del JSON.

## Requisitos

- Windows 10 u 11
- [PowerToys](https://learn.microsoft.com/windows/powertoys/) con PowerToys Run activado
- PowerShell (viene con Windows)

## Estructura

```
powertoys-accesos/
├── accesos.example.json       # Ejemplo de configuración
├── accesos.json               # Tu configuración real (ignorado por Git)
├── sincronizar-accesos.ps1    # Script que crea los accesos
├── sincronizar.bat            # Ejecuta el script con doble clic
└── .gitignore
```

## Instalación

1. Clona el repositorio:

   ```powershell
   git clone https://github.com/morkmorquecho/powertoys-accesos.git
   cd powertoys-accesos
   ```

2. Copia el archivo de ejemplo y edítalo con tus URLs:

   ```powershell
   copy accesos.example.json accesos.json
   ```

## Configuración

`accesos.json` usa el formato `"nombre": "url"`:

```json
{
  "mi-app": "http://localhost:8000/",
  "mi-docs": "https://ejemplo.com/docs/",
  "mi-api": "http://servidor.local:8000/api/redoc/"
}
```

Todas las líneas llevan coma al final **excepto la última**.

## Uso

1. Haz doble clic en `sincronizar.bat` (o ejecuta `sincronizar-accesos.ps1` desde PowerShell).
2. Espera uno o dos minutos a que Windows indexe los accesos.
3. Abre PowerToys Run con tu atajo, escribe el nombre (por ejemplo `mi-`) y presiona Enter.

Para **agregar, cambiar o quitar** un acceso, edita `accesos.json` y vuelve a ejecutar `sincronizar.bat`.

## Importante

El script crea y **borra** archivos `.lnk` y `.url` en la carpeta `Accesos` dentro del Menú Inicio:

```
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accesos
```

Usa esa carpeta solo para este proyecto.

## Solución de problemas

- **No aparecen los accesos:** espera un par de minutos o reinicia PowerToys (clic derecho en su icono, Salir, y ábrelo de nuevo).
- **Siguen sin aparecer:** en la configuración de PowerToys Run, confirma que el plugin **Program** esté activado.
- **Error de formato JSON:** revisa comas y comillas; el script muestra el mensaje del error.

## Licencia

MIT
