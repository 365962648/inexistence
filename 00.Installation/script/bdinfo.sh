#!/bin/bash

black=$(tput setaf 0); red=$(tput setaf 1); green=$(tput setaf 2); yellow=$(tput setaf 3); blue=$(tput setaf 4)
magenta=$(tput setaf 5); cyan=$(tput setaf 6); white=$(tput setaf 7); bold=$(tput bold); normal=$(tput sgr0)

lolcat_location=`command -v lolcat`
mono_location=`command -v mono`
if [[ -e $lolcat_location ]]; then    lolcat=Yes;    fi
if [[ -e $mono_location ]]; then    mono=Yes;    fi

outputpath=/etc/inexistence/08.BDinfo
bdinfocli_path=/etc/inexistence/02.Tools/bdinfocli.exe
mkdir -p $outputpath

if [[ ! -e $bdinfocli_path ]]; then
    mkdir -p /etc/inexistence/02.Tools
    wget --no-check-certificate -qO /etc/inexistence/02.Tools/bdinfocli.exe https://raw.githubusercontent.com/Aniverse/inexistence/master/02.Tools/bdinfocli.exe
    chmod 777 /etc/inexistence/02.Tools/bdinfocli.exe
fi

if [[ ! $mono == Yes  ]]; then
    echo; echo "${bold}${red}警告 ${white}未检测到 mono，因此无法扫描 BDinfo ...${normal}"; echo
    exit 1
fi

if [[ $1 == ""  ]] || [[ ! -d $1 ]]; then
    echo; echo "${bold}${red}警告 ${white}你必须输入一个到BDMV的路径。如果路径里带空格的话还需要加上双引号${normal}"; echo
    exit 1
fi

bdmvpath=`echo "$1"`
file_title=`basename "$bdmvpath"`
file_title_clean="$(echo "$file_title" | tr '[:space:]' '.')"
file_title_clean="$(echo "$file_title_clean" | sed s'/[.]$//')"
file_title_clean="$(echo "$file_title_clean" | tr -d '(')"
file_title_clean="$(echo "$file_title_clean" | tr -d ')')"

echo;echo
mono $bdinfocli_path "$bdmvpath" $outputpath
if [ ! $? -eq 0 ];then exit 1; else

sed -n '/QUICK SUMMARY/,//p' "${outputpath}/BDINFO.${file_title}.txt" > temptext
count=`wc -l temptext | awk '{print $1-1}' `
head -n $count temptext > "${outputpath}/bdinfo.quick.summary.txt"
rm temptext

sed -n '/DISC INFO/,/FILES/p' "${outputpath}/BDINFO.${file_title}.txt" > temptext
count=`wc -l temptext | awk '{print $1-2}' `
head -n $count temptext > "${outputpath}/${file_title_clean}.bdinfo.main.summary.txt"
rm temptext

mv "${outputpath}/BDINFO.${file_title}.txt" "${outputpath}/${file_title_clean}.bdinfo.txt"

clear
echo -e "${bold}扫描完成。生成的 BDinfo 报告存放在 ${blue}\"${outputpath}\"${normal}"
echo
echo -ne "${yellow}${bold}是否需要在 SSH 上显示 BDinfo Quick Summary ? 你可以直接从 SSH 上复制 BDinfo，无需下载回本地 ${white} [${green}Y${white}]es or [N]o: ${normal}"; read responce

case $responce in
    [yY] | [yY][Ee][Ss] | "" ) showbdinfo=Yes ;;
    [nN] | [nN][Oo]) showbdinfo=No ;;
    *) showbdinfo=Yes ;;
esac

if [ $showbdinfo == Yes ]; then
    echo
    if [ $lolcat == Yes ]; then
        cat "${outputpath}/bdinfo.quick.summary.txt" | lolcat
    else
        cat "${outputpath}/bdinfo.quick.summary.txt"
    fi
    echo
fi

fi

