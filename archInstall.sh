#!/bin/bash

############################### A Partir daqui pode rodar tudo automaticamente ############################### 

#Instalar o basico
pacman -S nano sudo dosfstools os-prober mtools networkmanager grub-efi-x86_64 efibootmgr iwd xorg-server nvidia nvidia-libgl mesa netctl wireless_tools dhcpcd wpa_supplicant dialog 
systemctl enable netctl
systemctl enable dhcpcd
systemctl enable NetworkManager

#Problemas com wifi depois de instalar ? https://ostechnix.com/fix-job-netctl-service-failed-error-arch-linux/

#Setar fuso horário de Brasilia
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

#Sincronizar horas
hwclock --systohc

#Edite a linguagem do sistema, descomentando a linnha pt_BR.UTF8
echo pt_BR.UTF-8 UTF-8 > /etc/locale.gen

#Gerar os locales após
locale-gen

#Definir sua variavel linguagem, digite no arquivo LANG=pt_BR.UTF-8
echo LANG=pt_BR.UTF-8 > /etc/locale.conf 

#Persistir layout do teclado, digite no arquivo KEYMAP=br-abnt2
echo KEYMAP=br-abnt2 > /etc/vconsole.conf

#Crie o arquivo e defina seu hostname (colocar nome  do usuario)
echo lambert > /etc/hostname

#Definir hosts em /etc/hosts
echo 127.0.0.1 localhost.localdomain localhost > /etc/hosts
::1 localhost.localdomain localhost >> /etc/hosts
127.0.1.1	lambert.localdomain	lambert >> /etc/hosts

#Definir voce como um sudoer e adicionar como usuario 
useradd -m -g users -G wheel lambert
echo lambert ALL=(ALL) ALL >> /etc/sudoers

#Gerar um Initramfs
mkinitcpio -P

#Definir senha do root
echo "Digite a senha do root"
passwd

#Definir a senha da sua conta
echo "Digite a senha do usuario lambert"
passwd lambert

#Configurar grub

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch_grub --recheck

cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

grub-mkconfig -o /boot/grub/grub.cfg

###Reboot para checar o grub

#Instalar drivers e alguns utilitarios
pacman -Sy
sudo pacman -S git wget firefox curl neovim xorg-server
