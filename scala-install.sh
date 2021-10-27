#!/bin/bash

# Shell: BASH ($BASH)
# Usage: source scala-install.sh

confirm() {
    #
    # syntax: confirm [<prompt>]
    #
    # Prompts the user to enter Yes or No and returns 0/1.
    #
    # This  program  is free software: you can redistribute it and/or modify  it
    # under the terms of the GNU General Public License as published by the Free
    # Software  Foundation, either version 3 of the License, or (at your option)
    # any later version.
    #
    # This  program  is  distributed  in the hope that it will  be  useful,  but
    # WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    # or  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public  License
    # for more details.
    #
    # You  should  have received a copy of the GNU General Public License  along
    # with this program. If not, see <http://www.gnu.org/licenses/>
    #
    #  04 Jul 17   0.1   - Initial version - MEJT
    #
    local _prompt _default _response
    
    if [ "$1" ]; then _prompt="$1"; else _prompt="Are you sure"; fi
    _prompt="$_prompt [y/n] ?"
    
    # Loop forever until the user enters a valid response (Y/N or Yes/No).
    while true; do
        read -r -p "$_prompt " _response
        case "$_response" in
            [Yy][Ee][Ss]|[Yy]) # Yes or Y (case-insensitive).
                return 0
            ;;
            [Nn][Oo]|[Nn])  # No or N.
                return 1
            ;;
            *) # Anything else (including a blank) is invalid.
            ;;
        esac
    done
}

# Check if scala exists
if command -v scala3-compiler &> /dev/null && command -v scala3-repl &> /dev/null; then
    printf "Scala is installed.\n"
    if confirm "Do you want to uninstall Scala?" ; then
        echo "Okay, uninstalling..."
        # Remove scala and cs
        cs uninstall scala3-compiler scala3-repl cs && echo "Files removed."
        rm -rf ~/.local/share/coursier/
        
        # Clean PATH variable
        path=$HOME/.local/share/coursier/bin
        PATH="$(echo "$PATH" |sed -e "s#\(^\|:\)$(echo "$path" |sed -e 's/[^^]/[&]/g' -e 's/\^/\\^/g')\(:\|/\{0,1\}$\)#\1\2#" -e 's#:\+#:#g' -e 's#^:\|:$##g')"
        
        # Cleaning PATH variable permanently
        grep -v ".local/share/coursier/bin" ~/.bashrc > tmpfile && mv tmpfile ~/.bashrc
        
        echo "Cleaned up"
        
        if command -v scala3-compiler &> /dev/null && command -v scala3-repl &> /dev/null && command -v cs &> /dev/null; then
            echo "Uninstallation failed."
        else
            echo "Uninstallation successful."
        fi
    else
        echo "Okay, exiting..."
    fi
else
    # Check if java exists
    if command -v java &> /dev/null; then
        # Downloading and installing cs
        printf "Java is installed.\nProceeding with installation...\nDownloading cs...\n"
        curl -fLo cs https://git.io/coursier-cli-"$(uname | tr LD ld)" && echo "Download complete." && chmod +x cs && echo "Installing cs..." && ./cs install cs &&
        
        # Cleanup
        rm -f cs
        
        # Check if cs exists
        if command -v cs &> /dev/null; then
            echo "cs is already in path proceeding with scala installation"
            cs install scala3-compiler scala3-repl && echo 'Done.'
        else
            # Add to PATH
            echo 'export PATH="$PATH:$HOME/.local/share/coursier/bin"' >> ~/.bashrc
            source ~/.bashrc
            
            # Verify if cs added to PATH
            if command -v cs &> /dev/null; then
                echo 'Added to PATH.'
                echo "cs installed successfully."
                
                # Downloading and installing scala
                cs install scala3-compiler scala3-repl && echo 'Done.'
            else
                echo "cs not installed."
            fi
        fi
        
        # Check if scala exists
        if command -v scala3-compiler &> /dev/null && command -v scala3-repl &> /dev/null; then
            echo "Installation successful."
        else
            echo "Installation failed."
        fi
    else
        printf "Java is not installed. Please install java.\nExiting...\n"
    fi
fi

