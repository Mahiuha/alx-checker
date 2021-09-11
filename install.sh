#!/usr/bin/env bash

cols=$(tput cols) # ───────────── Get the width of the terminal.
cols=$(($cols - 3)) # ─────────── Substract 3 to prevent overflow.

echo -n '┌' # ──────────────────┐ Print upper part of load bar box.
printf '─%.0s' $(seq 0 $cols) # ┤ String multiplication in bash.
echo '┐' # ─────────────────────┘

echo -n '│' # ──────────────────┐ 
printf ' %.0s' $(seq 0 $cols) # │ Print middle part uf load bar box.
echo '│' # ─────────────────────┘

echo -n '└' # ──────────────────┐ 
printf '─%.0s' $(seq 0 $cols) # │ Print bottom part uf load bar box.
echo -ne '┘\r' # ───────────────┘

echo -ne '\033[1A\033[2C' # ───── Set cursor to begining of loading bar.

cols=$(($cols - 1)) # ─────────── Substract one to account for padding.

# Start main installation loop to draw progress bar.
echo -en '\033[s' # Save cursor's position to start of load bar.
installed=0

i=0
cols=$(($cols - 1))
size=$(($cols / 3))

while [ $installed != 1 ]; do

    # 1 . Create install directory for files.
    if sudo mkdir /opt/checker 2> /dev/null ; then
        echo -ne '\033[92m'
        printf '█%.0s' $(seq 0 $size)
        echo -ne '\033[m'
        echo -en '\033[s' # Store cursor's position progrss in loading bar.
        echo ""
        echo ""
        echo -en "\t🔥 Created installation dir \033[92m/opt/checker\033[m "
    else
        echo -ne '\033[91m'
        printf '█%.0s' $(seq 0 $size)
        echo -ne '\033[m'
        echo -en '\033[s'
        echo ""
        echo ""
        echo -en "\t🤢 Dir \033[91m/opt/checker\033[m already exists."
    fi    

    # echo -en '\033[u' # Reset cursor to saved position above.
    # Due to zsh not working with the command above... this below...
    echo -en '\r'
    echo -en '\033[2A'
    echo -en '\033[3C'
    echo -en "\033[${size}C"

    # 2. Clone repository into installation directory.
    if sudo git -C /opt/checker clone https://github.com/DiegoCol93/CLI_Checker.git 2> /dev/null; then
        echo -ne '\033[92m'
        printf '█%.0s' $(seq 0 $size)
        echo -ne '\033[m'
        echo -en '\033[s'
        echo ""
        echo ""
        echo ""
        echo -en "\t🔥 Cloned repository into \033[92m/opt/checker\033[m"
    else
        echo -ne '\033[91m'
        printf '█%.0s' $(seq 0 $size)
        echo -ne '\033[m'
        echo -en '\033[s'
        echo ""
        echo ""
        echo ""
        echo -en "\t🤮 Couldn't clone repository in \033[91m/opt/checker.\033[m"
    fi    

    # echo -en '\033[u' # Reset cursor to saved position above.
    # Due to zsh not working with the command above... this below...
    echo -en '\r'
    echo -en '\033[3A'
    echo -en '\033[3C'
    echo -en "\033[${size}C"
    echo -en "\033[${size}C"

    # 3. Create symbolic link to script for running checker command.
    #
    #      This is done to allow you to run the checker command
    #      from anywhere in your machine.
    #
    if sudo ln -s /opt/checker/CLI_Checker/checker /usr/local/bin/checker 2> /dev/null ; then
        echo -ne '\033[92m'
        printf '█%.0s' $(seq 0 $(($size - 2)))
        echo -ne '\033[m'
        echo ""
        echo ""
        echo ""
        echo ""
        echo -en "\t🔥 Created symlink file:\n" \
             "\t\tfrom : \033[92m/usr/local/bin/checker ────────────┐\033[m\n" \
             "\t\tto   : \033[92m/opt/checker/CLI_Checker/checker ──┘\033[m\n"
    else
        echo -ne '\033[91m'
        printf '█%.0s' $(seq 0 $(($size - 2)))
        echo -ne '\033[m'
        echo -en '\033[s'
        echo ""
        echo ""
        echo ""
        echo ""
        echo -e "\t🥶 Couldn't create Symbolic \033[91m/usr/local/bin/checker\033[m file.\n"
        break
    fi    

    (( installed++ ))
    echo ""
    echo -e "CLI_Checker \033[92mv0.01\033[m has been installed \033[92msuccesfully\033[m."
    echo -e "You may now run:\n"
    echo -e "\t\033[92mchecker\033[m\n"
    echo -e "In order to start the checker console."

done

# Error if Not installed or already installed.
if [ $installed != 1 ]; then
    echo -e "  This could be caused by many reasons...\n"
    echo "  The main one is that the checker is already installed."
    echo "  If you are unable to launch the console."
    echo -e "  Please run these commands to erase the installation files and try installing again.\n"
    echo -e "\tsudo rm /opt/checker/ -rf"
    echo -e "\tsudo rm /usr/local/bin/checker\n"
fi
