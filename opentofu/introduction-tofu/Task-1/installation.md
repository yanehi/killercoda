Um die folgenden Aufgaben beaarbeiten zu können, wird eine Installation von OpenTofu benötigt. 
Der offiziele Weg um OpenTofu in dem gewünschten Betriebssystem zu installieren, kann aus der 
offiziele [OpenTofu Installationsanleitung](https://opentofu.org/docs/intro/install/) entnommen werden.

Die OpenTofu CLI beinhaltet die relevanten Befehle um aus den IaC-Skripten die gewünschte Soll-Infrastruktur zu provisionieren
und mit dem OpenTofu State zu interagieren (eine Datei, die den aktuellen Zustand der Infrastruktur beschreibt). 

## Task
Innerhalb der Killercoda Szenarien befinden wir uns in einer Ubuntu 22.04 Umgebung. 
Um OpenTofu zu installieren können folgende Befehle genutzt werden:

```shell
# Update packages
apt-get update -y
# Download the installer script:
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
# Remove the installer:
rm -f install-opentofu.sh
```{{exec}}

Um zu überprüfen, ob OpenTofu korrekt installiert wurde, kann der folgende Befehl genutzt werden:

```shell
tofu -version
```{{exec}}

