# ZenNet

**ZenNet** es una herramienta de terminal (TUI) ligera diseñada en Bash Script para ejecutar un sencillo escaneo de red y diagnostico en tiempo real.

## Caracteristicas:
- **Diseño:** La utilidad esta enteramente desarrollada en Bash Script.
- **Arquitectura:** ZenNet esta programado bajo un paradigma imperativo y se desarrolla filosoficamente y tecnicamente con una estructura monolitica, un solo script que define toda la logica.
- **Enfoque:** NO es una herramienta orientada al ejercer de la seguridad informatica, es una utilidad experimental, academica y planeada para laboratorios de maquinas virtuales o una red local.
- **Registro centralizado:** Todos los escaneos ejecutados seran almacenados en un archivo llamado `scan.log`.

## Requisitos:
- Sistema operativo GNU/Linux o derivados de Unix.
- *Bash* como shell principal.
- Utilidades estandar del sistema (`systemctl`, `ip`, `awk`, etc).

## Instalación y ejecución:
- **Clonar repositorio:** `git clone https://github.com/JIRT2007/ZenNet.git`

- **Asignacion de permisos:** `chmod +x ZenNet/zennet.sh`

- **Ejecutar:** `./ZenNet/zennet.sh`

## Licencia:
**ZenNet** se encuentra bajo las politicas de uso y distribución, establecidas en la **General Public License v2.0**. Puedes consultar la documentación oficial en el sitio web del proyecto **GNU**.
***https://www.gnu.org/licenses/old-licenses/gpl-2.0.html***
