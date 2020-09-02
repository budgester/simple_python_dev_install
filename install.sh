#!/bin/bash

# Simple setup for python projects

# The below will prompt you to install the XCode CLI Tools,
# or simply show the version if installed
echo "Check git version"
git --version
echo ""

echo "Check python version"
python_installed=`which python`

if [ -n "${python_installed}" ]; then
    python_version=`python3 --version`
    echo "${python_version} installed"
else
    echo "Downloading python ${python_version}"
    wget https://www.python.org/ftp/python/${python_version}/python-${python_version}-macosx10.9.pkg

    echo "Installing python ${python_version}"
    open .

    echo "Press any key to continue"
    while [ true ] ; do
        read -t 3 -n 1
        if [ $? = 0 ] ; then
            break
        else
            echo "$?"
        fi
    done
fi
echo ""

echo "Checking pip3 is up to date"
pip3 install --upgrade pip
echo ""

echo "Checking brew"

brew_installed=`which brew`

if [ -n "${brew_installed}" ]; then
    brew_version=`brew --version |grep 'Homebrew '`
    echo "${brew_version} installed"
else
    echo "Installing brew"
    /bin/bash -c "$(/usr/bin/curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi
echo ""

echo "Checking openjdk11"
echo ""

if [ -d "/usr/local/Caskroom/adoptopenjdk11" ]; then
    echo "openjdk is installed"
else
    echo "Installing openjdk11"
    brew tap adoptopenjdk/openjdk
    brew cask install adoptopenjdk11
fi
echo ""


echo "Checking brew packages"

for brew_package in `more brew_packages.txt`
do
    package_name=${brew_package%:*}
    package_loc=${brew_package##*:}

    if [ -f "${package_loc}" ]; then
        echo "${package_name} is installed"
    else
        echo "Installing ${package_name}"
        brew install ${package_name}
    fi
done
echo ""

echo "Checking flyway"
if [ -f "/opt/flyway" ]; then
        echo "flyway is installed"
else
    echo "Installing flyway"
    here=$PWD
    wget https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/5.2.4/flyway-commandline-5.2.4-macosx-x64.tar.gz

    sudo mkdir -p /opt
    sudo chown -R ${USER} /opt
    mv flyway-commandline-5.2.4-macosx-x64.tar.gz /opt
    cd /opt
    gunzip flyway-commandline-5.2.4-macosx-x64.tar.gz
    tar xvf flyway-commandline-5.2.4-macosx-x64.tar
    ln -s flyway-5.2.4/flyway
    cd ${here}
    echo "You can add flyway to your path by setting PATH=$PATH:/opt"
fi
echo ""

echo "Downloading docker"
 wget https://download.docker.com/mac/stable/Docker.dmg
echo ""

for i in 'tox===3.14.5' 'PyYAML==5.3.1' 'jinja2-cli==0.7.0'
do
    pip3 install $i
done

echo "You will need to add the following to your .bashrc"
echo "export PATH=$PATH:/opt:$HOME/Library/Python/3.7/bin"

brew install unixodbc
brew install mysql-client

echo "export PATH=$PATH:/usr/local/opt/mysql-client/bin"


# brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
# brew update
# HOMEBREW_NO_ENV_FILTERING=1 ACCEPT_EULA=Y brew install msodbcsql17 mssql-tools

# Handle brew install errors:
# git clone https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
# cp -R homebrew-core /usr/local/Homebrew/Library/Taps/homebrew/.
