#!/bin/bash

vscodeExtensionsInstall(){
    extensions=(
        "bradlc.vscode-tailwindcss"
        "miguelsolorio.symbols"
        "esbenp.prettier-vscode"
        "GitHub.github-vscode-theme"
        "miguelsolorio.fluent-icons"
        "naumovs.color-highlight"
        "eamodio.gitlens"
        "Codeium.codeium"
        "adpyke.codesnap"
        "donjayamanne.githistory"
        "Cardinal90.multi-cursor-case-preserve"
    )

    for extension in "${extensions[@]}"; do
  
        echo "Installing $extension ..."
        code --install-extension $extension --force
        
    done

    echo "Extension installation complete!"
    
}

vscodeExtensionsReset(){
    vscodeExtensionsUninstall
    vscodeExtensionsInstall
}
vscodeExtensionsUninstall(){
    code --list-extensions | while read extension;
    do
        code --uninstall-extension $extension --force
    done
}
systemUpdate(){
    sudo apt update
}

basicSetup(){
    which snap &> /dev/null || systemUpdate && sudo apt install snapd
    which curl &> /dev/null || systemUpdate && sudo apt install curl
    clear
}

# installer
vscodeInstall(){
    systemUpdate && sudo snap install code --classic
}

braveInstall(){
    systemUpdate && sudo snap install brave
}

spotifyInstall(){
    systemUpdate && sudo snap install spotify
}

discordInstall(){
    systemUpdate && sudo snap install discord
}

postmanInstall(){
    systemUpdate && sudo snap install postman
}

gitInstall(){
    systemUpdate && sudo apt install git
}

nodeInstall(){
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    nvm install 23
    systemUpdate
}
#profiles
appsInstall(){
    gitInstall
    discordInstall
    vscodeInstall
    braveInstall
    spotifyInstall
    postmanInstall
}
devProfile(){
    appsInstall
    vscodeExtensionsInstall
}



adonisSetup(){
    extensions=(
        "jripouteau.japa-vscode"
        "jripouteau.adonis-vscode-extension"
    )
    for extension in "${extensions[@]}"; do
  
        echo "Installing $extension ..."
        code --install-extension $extension --force
        
    done

    echo "Extension installation complete!"
}

personal(){
    nodeInstall
    devProfile
    adonisSetup
}

main() {
    basicSetup
    if [ $# -eq 0 ]; then
        echo "Use --help for usage. $0 --help"
        exit 1
    fi
        for arg in "$@"; do
        case $arg in
            --dev)
                devProfile
                ;;
            --adonis)
            adonisSetup
            ;;

            --node)
            nodeInstall
            ;;
            --dev-noextension)
                appsInstall
                ;;
            --extensions-reset)
                vscodeExtensionsReset
                ;;
            --extensions-uinstall)
                vscodeExtensionsUninstall
                ;;
            --extensions-install)
                vscodeExtensionsInstall
                ;;
            --personal)
                personal
                ;;
            --help)
                echo -e "Usage:\n  
                $0 --dev     Set up all aps including VS Code extensions\n  
                $0 --adonis     Set up VS Code extensions for adonis\n
                $0 --node     Set up node version 23 and nvm verison 0.40\n
                $0 --dev-noextension     Set up all aps without VS Code extensions\n  
                $0 --extension-reset    Uninstall all VS Code extensions and install them again\n
                $0 --extension-uinstall    Uninstall all VS Code extensions\n
                $0 --extension-install    Install all VS Code extensions\n
                $0 --personal     Set up using my personal preferences\n"
                ;;
            *)
                echo "Unknown option: $arg"
                ;;
        esac
    done

}

main "$@"