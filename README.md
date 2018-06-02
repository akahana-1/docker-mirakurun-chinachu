# docker-mirakurun-chinachu for PX-S1UD and ACR39U
[公式Dockerコンテナ](https://github.com/Chinachu/docker-mirakurun-chinachu)をベースに

- チューナー : [Mygica S270](https://www.geniatech.com/product/s270-fullseg-usb-tv/)
- カードリーダー : [ACR39U-NTTcom](http://www.ntt.com/business/services/application/authentication/jpki/download6.html)

に変更

## Constitution
### Mirakurun
- Alpine Linux 3.6
- [Mirakurun](https://github.com/kanreisa/Mirakurun)
  - branch: master

### Chinachu
- Alpine Linux 3.6
- [Chinachu](https://github.com/kanreisa/Chinachu)
  - branch: gamma

## 動作確認環境
> OS
>>Debian GNU/Linux 9.4 (stretch)  
>> Linux 4.9.82-1+deb9u3  

>Docker
>>version 18.03.0-ce, build 0520e24  

>Tuner
>>ISDB-T Tuner Mygica S270  

>Smart card reader
>>USB SmartCard Reader NTT Communications Corp. ACR39U-NTTcom  

## 利用方法
- 最新のdocker & docker-compose がインストール済
- SELinuxの無効化推奨
- ホストマシンにチューナーのファームウェアがインストール済み
    + Mygica S270のドライバはLinuxカーネルに取り込まれているため/dev/dvb/adapter\*で認識される
```
$ ls -l /dev/dvb/adapter*/
crw-rw---- 1 root video 212, 0 Jun 26 16:07 demux0
crw-rw---- 1 root video 212, 1 Jun 26 16:07 dvr0
crw-rw---- 1 root video 212, 2 Jun 26 16:07 frontend0
```
- B-CAS 用に利用するスマートカードリーダーはMirakurunコンテナ内で管理しますので  
ホストマシン上のpcscdは停止してください
```
sudo systemctl stop pcscd.socket
sudo systemctl disable pcscd.socket
```

- docker-composeを利用しておりますので、プロジェクトディレクトリ内で下記コマンドを実行してください  
プロジェクトディレクトリ名はビルド時のレポジトリ名になりますので、適当に短いフォルダ名が推奨です

### 取得例
```shell
git clone https://github.com/h-mineta/docker-mirakurun-chinachu.git tvs
cd tvs
```
### 起動
```shell
docker-compose up -d
```
### 停止
```shell
docker-compose down
```

### デーモン化(systemd)
初期では「WorkingDirectory」が「/usr/local/projects/tvs/」となっています  
設置した箇所に応じて、書き換えてください
```shell
vi mirakurun-chinachu.service
```

mirakurun-chinachu.serviceをコピーします
```shell
sudo cp mirakurun-chinachu.service /usr/lib/systemd/system
sudo systemctl enable mirakurun-chinachu

# systemdによる起動
sudo systemctl start mirakurun-chinachu

# systemdによる停止
sudo systemctl stop mirakurun-chinachu
```

## 設定
エリア、環境によって変更が必要なファイルは下記の通りとなります
### Mirakurun
- ポート番号 : 40772
- mirakurun/conf/tuners.yml  
チューナー設定
- mirakurun/conf/channels.yml  
チャンネル設定

### Chinachu
- ポート番号 : 10772, 20772(local network only), 5353/udp(mDNS)
- chinachu/conf/config.json  
チューナー設定  
チャンネル設定

### 録画ファイル保存先
また録画ファイルはプロジェクトフォルダ内の./recordedに保存されます  
> 保存先を別HDDにしたい場合は、docker-compose.ymlの
>> ./recorded:/usr/local/chinachu/recorded
>
> の./recordedを変更することで保存先を変更可能

## License
This software is released under the MIT License, see LICENSE.
