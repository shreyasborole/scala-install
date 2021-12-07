# Scala 3 Installer for Linux

A simple bash script to install/uninstall latest version Scala 3 and it's required dependencies.

## Getting Started

Scala 3 is available in existing repositories of AUR and RPM, but those are distro-specific. This script makes it easier to install/uninstall Scala 3 with just one-command on almost any distros. 

### Prerequisites

Make sure you have
> The Scala 3.x series supports JDK 8, as well as 11 and beyond. As Scala and the JVM continue to evolve, some eventual Scala version may drop support for JDK 8, in order to better take advantage of new JVM features. It isn’t clear yet what the new minimum supported version might become.
* Java 8 and above (preferably 11 onwards)
* Bash Shell

## Usage

Install Scala:

```
$ source scala-install.sh
```
OR
```
$ . scala-install.sh
```

Uninstall Scala:
> The script autodetects if Scala is installed, if it does it prompts for uninstallation. Rerun the script to uninstall.

```
$ source scala-install.sh
```
OR
```
$ . scala-install.sh
```

