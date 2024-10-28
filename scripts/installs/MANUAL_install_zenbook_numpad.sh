# sudo apt install libevdev2 python3-libevdev i2c-tools git
# sudo modprobe i2c-dev
# sudo i2cdetect -l
# mkdir -p Documents/Perso/tmp/git
# cd Documents/Perso/tmp/git
# git clone https://github.com/mohamed-badaoui/asus-touchpad-numpad-driver
# cd asus-touchpad-numpad-driver
# chmod +x install.sh
# sudo ./install.sh

git clone https://github.com/asus-linux-drivers/asus-numberpad-driver
cd asus-numberpad-driver/
bash install.sh