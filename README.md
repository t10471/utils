#dockerの使い方
==============

## **buildコマンド**
```
.はDockerfileの場所
docker build -t user/image:tag .
```

## **起動しながらcontainerに入る方法**
```
docker run -it --name conatainername user/image:tag /bin/bash
```

## **便利シェル**

- rmi_none_image.sh   
  noneになっているimageを削除する
- rm_stop_container.sh   
  停止しているcontainerを削除する
