## Laji Scripts


> 这只是一个不会 shell、不会 Linux 的刷子无聊写着玩的产物 ……


不保证本脚本能正常使用，翻车了不负责；上车前还请三思。  
本介绍的内容不会及时更新。目前最新的脚本在界面上和截图里有一点不一样  
有 bug 的话最好 QQ 私聊通知我,**但不保证能解决**  


-------------------
# Inexistence


#### 使用方法
``` 
wget -q https://github.com/Aniverse/inexistence/raw/master/inexistence.sh && bash inexistence.sh
```
-------------------
#### 安装介绍

`Checking your server's public IP address ...
If you stuck here for a while, please press Ctrl+C to stop the script` 

如果你卡在这一步，应该是获取公网 IP 地址的时候卡了……除了去掉这个检测或者换个检测地址外我暂时不知道这个情况要怎么解决（ifconfig 出来在某些 VPS 上是内网的IP）

![引导界面](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.01.png)

检查是否 root，检查系统是不是 `Ubuntu 16.04、Debian 8、Debian 9`  
如果没用 root 权限运行或者系统不是如上的三个，脚本会自动退出

![安装时的选项](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.02.png)

1. **账号密码**  
根据你输入的账号会新建一个 UNIX 用户，rTorrent 的运行也是用这个用户来运行（其他软件用 root 来运行），Deluge auth、qBittorrent 用的也都是这个账号；密码用于各类软件的 WebUI。
目前这个功能有一个问题，脚本不会检测输入的用户名和密码是否合法。所以如果你用了不合法的用户名（比如数字开头）或者不合法的密码（密码复杂度太低），脚本不会提示出错，但实际在软件的使用中你可能会碰到问题……
2. 是否更换**系统源**  
大多数情况下无需换源。某些 VPS 默认的源有点问题我才加入了这个选项
3. 编译时使用的**线程数量**（四个 BT 客户端默认都是编译安装的）  
一般来说独服用默认的选项，也就是全部线程都用于编译就可以了…… 某些 VPS 可能限制下线程数量比较好，不然可能会翻车
4. **qBittorrent**  
其实有安装 4.0.2 版本的选项，不过似乎编译不成功，因此我就没显示出来了。以后再测试这个的编译 
5. **Deluge libtorrent**  
libtorrent 版本不知道选什么的话选默认的就可以了
6. **rTorrent + ruTorrent**  
这部分是调用我修改的 rtinst 来安装的（SSH端口22，不关闭 root 登陆，安装 webmin 和 h5ai）。目前这个脚本安装的 0.9.6 版本不支持 IPv6，我还不知道哪里出了问题； 0.9.4 支持 IPv6 用的是打好补丁的版本。理论上来说这是一个修改版，所以是否要安装这个版本就由你自己来定夺了…… 此外如果系统是 Debian 9的话，rTorrent 版本强制会指定成 0.9.6（其他版本不支持）
7. **Transmission**  
会自动安装修改版的 WebUI。Debian 9下的编译安装我失败了，不知道为什么。因此针对 Debian 9 就强制采用 从 repo 安装的办法
8. 实际上针对 tr/de/qb 我加入了不编绎，从 PPA 或者 repo 里安装的选项，不过默认是不显示这些选项的……输入30是从 repo 安装，输入 40 是添加 ppa 后安装（ppa 仅对 Ubuntu 有效 ）
9. **Flexget**  
默认不安装。我启用了 daemon 模式（关闭shedules）和 WebUI。还预设了一些模板，仅供参考（crontab我没改）
10. **rclone**  
这个没什么可以说的……默认不安装。安装好后自己输入 rclone config 进行配置
11. **BBR**  
会检测你当前的内核版本，大于4.9是默认不安装，高于4.9是默认启用BBR（不更换内核）。BBR的安装调用了秋水逸冰菊苣的脚本，会安装最新版本的内核
12. **系统设置**  
主要是修改时区为 UTC+8（似乎然并卵，我以后再修复）、`alias`、编码设置为 UTF-8、提高系统文件打开数。默认是不启用的……

![确认信息是否有误](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.03.png)

由于安装时候没有提示二次确认和纠错的功能，所以如果你哪里写错了，只能先退出脚本重新再选择…… 没什么问题的话就敲回车继续……

![安装完成](https://github.com/Aniverse/filesss/raw/master/Images/inexistence.04.png)

安装完成后会输出各类 WebUI 的网址，以及本次安装花了多少时间，然后问你是否重启系统（默认是不重启；不过如果装了BBR的话是需要重启的）

有一点需要注意的是，Flexget WebUI 的密码强制被指定为 Flexget，无法修改…… 密码是你之前预设的密码

在我的10欧（i3 2100／4GB／2×1TB HW RAID0）上安装这些花了16分钟。感觉比自己手动安装还是更省时间的（如果不编译安装的话速度更快）……

-------------------
## BD Upload

#### 下载与安装
```
wget --no-check-certificate -qO /usr/local/bin/bdupload https://raw.githubusercontent.com/Aniverse/inexistence/master/00.Installation/script/bdupload.sh
chmod +x /usr/local/bin/bdupload
```
#### 运行
```
bdupload
```
#### 介绍

转发 BD 原盘时可以使用的一个脚本。**不支持 UltraHD Blu-ray**  
目前可以实现以下功能：  

- **判断是 BDISO 还是 BDMV**  
输入一个路径，判断是不是文件夹；是文件夹的话认为是 BDMV，不是文件夹的话认为是 BDISO  
（所以如果你输的不是 BD 或者一个文件夹内包含多个 BD 的话是会出错的）
- **自动挂载镜像**  
如果是 BDISO，会挂载成 BDMV，并问你是否需要对这个挂载生成的文件夹重命名（有时候 BDISO 的标题就是 DISC1 之类的，重命名下可能更好）。全部操作完成后 BDISO 会自动解除挂载
- **截图**  
自动寻找 BD 里体积最大的 m2ts 截 10 张 png 图。默认用 1920×1080 的分辨率，也可以手动填写分辨率  
指定 1920×1080 分辨率是因为某些原盘用 ffmepg 自动检测分辨率截图的话截出来的图是 1440 ×1080 的，不符合某些站的要求  
自定义分辨率主要是考虑到有些原盘的分辨率不是 1080 （有些蓝光原盘甚至是 480i ）  
- **扫描 BDinfo**  
默认是自动扫描第一个最长的 mpls；也可以手动选择扫描哪一个 mpls  
BDinfo 会有三个文件，一个是原版的，很长；一个是 Main Summary，一个是 Quick Summary。一般而言发种写个 Quick Summary 就差不多了  
- **生成缩略图**  
这个功能默认不启用；其实也不是很有用 ……
- **制作种子**  
针对 BDISO，默认选择重新做种子；针对 BDMV，默认选择不重新做种子  

#### To Do List

- **自动上传到 ptpimg**  
调用 ptpimg_uploader 来完成，脚本跑完后会输出 ptpimg 的链接。运行之前你需要自己设置好 ptpimg_uploader  
- **自动上传到 Google Drive**  
调用 rclone 来完成，需要你自己设置好 rclone，且在脚本里设置 rclone remote path（我会把这个设置项放在脚本开头的注释里）  

![检查是否缺少软件](https://github.com/Aniverse/filesss/raw/master/Images/bdupload.01.png)

这一步脚本会检查是否存在缺少的软件，如缺少会提示你安装，如果选择不安装的话脚本会退出

![正常运行界面](https://github.com/Aniverse/filesss/raw/master/Images/bdupload.02.png)
看着选项多，其实一般情况下，输入完路径后一路敲回车就可以了 ……  

![输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdupload.03.png)
需要注意的是，我脚本里挂载、输出文件都是指定了一个固定的目录`/etc/inexistence`  一般情况下你需要 root 权限才能访问这个目录  

-------------------
## mingling

#### 下载与安装
```
wget --no-check-certificate -qO /usr/local/bin/mingling https://raw.githubusercontent.com/Aniverse/inexistence/master/00.Installation/script/mingling.sh
chmod +x /usr/local/bin/mingling
```

#### 运行
```
mingling
```

#### 介绍

方便刷子们使用的一个脚本，有很多功能如果你没安装 `inexistence` 的话是用不了的。  
此外有些功能还没有做完……  
不做具体的介绍了，自己看图吧  

![mingling.03](https://github.com/Aniverse/filesss/raw/master/Images/mingling.03.png)
![mingling.04](https://github.com/Aniverse/filesss/raw/master/Images/mingling.04.png)
![mingling.05](https://github.com/Aniverse/filesss/raw/master/Images/mingling.05.png)
![mingling.06](https://github.com/Aniverse/filesss/raw/master/Images/mingling.06.png)
![mingling.07](https://github.com/Aniverse/filesss/raw/master/Images/mingling.07.png)
![mingling.08](https://github.com/Aniverse/filesss/raw/master/Images/mingling.08.png)

#### To Do List
- 添加 AutoDL-Irssi 的开关
- 添加锐速的开关与状态检测
- 完成脚本菜单的功能

 -------------------
## bdjietu

这个是单独抽出来的，用于给 BD 截图的脚本。输入 BDMV 的路径后会自动从中找出最大的 m2ts 文件，截图 10 张到特定的目录。  
其实就是用 ffmepg 来截图，不过指定了分辨率和输出的路径  
 
 ![bdjietu输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdjietu.01.png)
 
  -------------------
 ## bdinfo


这个是单独抽出来的，用于给 BDMV 扫描 BDinfo 的脚本。  
运行完以后会问你是否在 SSH 上输出 BDinfo Quick Summary  
（个人认为直接输出到 SSH 上复制下来就行了，没必要下回本地）  

![bdinfo输出结果](https://github.com/Aniverse/filesss/raw/master/Images/bdinfo.01.png)
 
BDinfo 输出结果彩色是因为使用了 lolcat，如果你没安装 lolcat 的话是不会有彩色的……
 
 
  -------------------

还有一些脚本，比如 `jietu`、`guazai`、`zuozhong` 等等，在此不作介绍了，大多看名字都知道是干什么用的了  
这些脚本在 `inexistence` 脚本里带上了但默认是不启用的  

  -------------------
### Some references

https://github.com/arakasi72/rtinst  
https://github.com/QuickBox/QB  
https://github.com/qbittorrent/qBittorrent/wiki  
https://flexget.com  
https://rclone.org/install  
http://dev.deluge-torrent.org/wiki/UserGuide  
https://mkvtoolnix.download/downloads.html  
http://outlyer.net/etiq/projects/vcs  
http://wilywx.com  
https://www.dwhd.org  
https://moeclub.org  
https://github.com/teddysun/across  
https://github.com/oooldking/script  
https://github.com/outime/ipv6-dhclient-script  
https://github.com/GalaxyXL/qBittorrent-autoremove  
https://xxxxxx.org/forums/viewtopic?topicid=61434  

