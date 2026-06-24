#!/bin/bash
# ==========================================================
# Premium Remote VPN Auto-Installer (Advanced Model)
# ==========================================================
# Developer : edholabs
# Repository: https://github.com/edholabs/RemoteVpn-AutoInstaller
# ==========================================================

# Definisi Warna untuk Tampilan yang Lebih Menarik
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Pastikan script dijalankan sebagai root
if [ "${EUID}" -ne 0 ]; then
    echo -e "${RED}[Error]${NC} Skrip ini wajib dijalankan sebagai root (sudo bash install.sh)!"
    exit 1
fi

# Mengambil Informasi Sistem VPS
IP_VPS=$(curl -sS ifconfig.me)
OS_NAME=$(source /etc/os-release && echo $PRETTY_NAME)
RAM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')

# Membersihkan layar
clear

# Menampilkan Banner Premium
echo -e "${BLUE}======================================================${NC}"
echo -e "${CYAN}          PREMIUM VPN AUTO-INSTALLER SCRIPT           ${NC}"
echo -e "${BLUE}======================================================${NC}"
echo -e " ${YELLOW}Developer${NC}   : edholabs"
echo -e " ${YELLOW}Sistem OS${NC}   : $OS_NAME"
echo -e " ${YELLOW}IP Publik${NC}   : $IP_VPS"
echo -e " ${YELLOW}Total RAM${NC}   : $RAM_TOTAL MB"
echo -e "${BLUE}======================================================${NC}"
echo -e ""
echo -e " Silakan pilih menu instalasi di bawah ini:"
echo -e " ${CYAN}[1]${NC} Install XRAY / V2RAY (VMess, VLess, Trojan)"
echo -e " ${CYAN}[2]${NC} Install SSH & WebSocket (Dropbear, Stunnel4)"
echo -e " ${CYAN}[3]${NC} Install OpenVPN & WireGuard (Standar VPN)"
echo -e " ${CYAN}[4]${NC} Aktifkan TCP BBR (Boost Speed VPS)"
echo -e " ${CYAN}[x]${NC} Keluar dari Skrip"
echo -e ""
read -p " Masukkan Pilihan Anda [1-4 atau x]: " MENU_PILIHAN

case $MENU_PILIHAN in
  1)
    echo -e "\n${GREEN}[+] Memulai instalasi Xray/V2Ray Core...${NC}"
    sleep 2
    bash <(curl -L -s https://raw.githubusercontent.com/XTLS/Xray-install/main/install-release.sh)
    echo -e "${GREEN}[+] Instalasi Xray selesai! Credit: edholabs${NC}"
    ;;
  2)
    echo -e "\n${GREEN}[+] Memulai instalasi SSH & WebSocket...${NC}"
    sleep 2
    apt-get update -y && apt-get install -y dropbear stunnel4 sslh
    echo -e "${GREEN}[+] Instalasi paket SSH & WebSocket selesai! Credit: edholabs${NC}"
    ;;
  3)
    echo -e "\n${GREEN}[+] Memulai instalasi OpenVPN & Wireguard...${NC}"
    sleep 2
    # Instalasi OpenVPN
    curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    chmod +x openvpn-install.sh
    AUTO_INSTALL=y ./openvpn-install.sh
    echo -e "${GREEN}[+] Instalasi OpenVPN selesai! Credit: edholabs${NC}"
    ;;
  4)
    echo -e "\n${GREEN}[+] Mengaktifkan algoritma TCP BBR untuk mempercepat koneksi...${NC}"
    sleep 2
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    echo -e "${GREEN}[+] TCP BBR berhasil diaktifkan! Credit: edholabs${NC}"
    ;;
  x)
    echo -e "${YELLOW}Keluar dari installer. Terima kasih!${NC}"
    exit 0
    ;;
  *)
    echo -e "${RED}[!] Pilihan tidak valid. Silakan coba lagi.${NC}"
    exit 1
    ;;
esac
