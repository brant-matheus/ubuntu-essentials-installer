#!/bin/bash


extensionsInstaller(){
    local extensions=("$@")

    for extension in "${extensions[@]}"; do
        echo "Installing $extension ..."
        code --install-extension $extension --force
    done

    echo "Extension installation complete!"

}
vscodeExtensionsInstall(){
    extensions=(
        "bradlc.vscode-tailwindcss"
        "miguelsolorio.symbols"
        "esbenp.prettier-vscode"
        "GitHub.github-vscode-theme"
        "miguelsolorio.fluent-icons"
        "naumovs.color-highlight"
        "adpyke.codesnap"
        "Cardinal90.multi-cursor-case-preserve"
    )

    extensionsInstaller "${extensions[@]}" 
    
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
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  #
    nvm install 23
    npm install --global yarn

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

dbeaverInstall(){
    systemUpdate && sudo sudo snap install dbeaver-ce

}

dockerInstall(){
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    # install
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

}
devProfile(){
    appsInstall
    vscodeExtensionsInstall
}

postgresCommand(){
    docker run --name postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=docker -e POSTGRES_DB=postgres -p 5432:5432 -d postgres
}

redisCommand(){
    docker run -d --name redis -p 6379:6379 redis/redis-stack-server:latest
}

adonisSetup(){
    extensions=(
        "jripouteau.japa-vscode"
        "jripouteau.adonis-vscode-extension"
    )

    extensionsInstaller "${extensions[@]}" 

}

personal(){
    nodeInstall
    devProfile
    adonisSetup
    dbeaverInstall
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

            --docker)
            dockerInstall
            ;;

            --postgres)
            postgresCommand
            ;;

            --redis)
            redisCommand
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
            --extensions-uninstall)
                vscodeExtensionsUninstall
                ;;
            --extensions-install)
                vscodeExtensionsInstall
                ;;
            
            --node)
                nodeInstall
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
                $0 --extensions-reset    Uninstall all VS Code extensions and install them again\n
                $0 --extensions-uninstall    Uninstall all VS Code extensions\n
                $0 --extensions-install    Install all VS Code extensions\n
                $0 --personal     Set up using my personal preferences\n"
                ;;
            *)
                echo "Unknown option: $arg"
                ;;
        esac
    done

}

main "$@"