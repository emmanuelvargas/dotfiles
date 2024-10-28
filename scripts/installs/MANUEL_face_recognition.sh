# sudo add-apt-repository ppa:boltgolt/howdy
# sudo apt update
# sudo apt install howdy

❯ sudo mv /usr/lib/python3.12/EXTERNALLY-MANAGED /usr/lib/python3.12/EXTERNALLY-MANAGED.old                                                                                                       ─╯

sudo apt-get update && sudo apt-get install -y \
python3 python3-pip python3-setuptools python3-wheel \
cmake make build-essential \
libpam0g-dev libinih-dev libevdev-dev \
python3-dev libopencv-dev python3-numpy \
python3-opencv libpam-python

get https://github.com/thecalamityjoe87/howdy/releases

❯ sudo dpkg -i howdy_2.6.1-1_all.deb                                                                                                                                                              ─╯


After setting up Howdy, you'll need to add the PAM module to pam.d/sudo and pam.d/gdm-password:

sudo nano /etc/pam.d/sudo

Add these lines:

auth sufficient pam_python.so /lib/security/howdy/pam.py
auth sufficient pam_unix.so try_first_pass likeauth nullok

Same thing for gdm-password. This is so we can use Howdy on the login/lock screens:

sudo nano /etc/pam.d/gdm-password

Add these lines:

auth sufficient pam_python.so /lib/security/howdy/pam.py
auth sufficient pam_unix.so try_first_pass likeauth nullok

Lastly, we want to stop the DEBUG crap when Howdy is used:

nano ~/.bashrc

Add these lines:

export OPENCV_LOG_LEVEL=OFF
export GST_DEBUG=0


sudo apt install v4l-utils

$ v4l2-ctl --list-devices
Integrated_Webcam_HD: Integrate (usb-0000:00:14.0-5):
	/dev/video0
	/dev/video1


sudo howdy config

sudo howdy add
