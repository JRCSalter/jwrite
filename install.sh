#/bin/bash

mkdir -p ~/.local/share/jwrite
mkdir -p ~/.config/jwrite

cp -r assets/templates          ~/.local/share/jwrite/
cp assets/help                  ~/.local/share/jwrite/
cp README                       ~/.local/share/jwrite/
cp -r assets/logs               ~/.local/share/jwrite/
cp -r assets/example_manuscript ~/.local/share/jwrite/
cp -r scripts                   ~/.local/share/jwrite/
cp assets/config/jwrite.config  ~/.config/jwrite/

mkdir -p /usr/local/man/man1
sudo cp jwrite.1.gz /usr/local/man/man1
sudo cp jwrite /usr/local/bin/
sudo chmod +x /usr/local/bin/jwrite
