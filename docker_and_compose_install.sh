#!/bin/sh

start_time=$(date +%s) # 获取当前时间戳（秒）
docker-compose -v
if [ "$?" -ne 127 ]; then
  echo "已经安装过docker-compose"
  exit 0
fi

file="/etc/docker/daemon.json"
if [ ! -f "$file" ]; then
    echo '{
      "log-driver":"json-file",
      "log-opts": {"max-size":"500m", "max-file":"3"},
      "insecure-registries": ["172.16.0.145:8083","172.16.0.145:8929"],
      "registry-mirrors": ["http://172.16.0.145:8083/","http://172.16.0.145:8929/","https://registry.cn-hangzhou.aliyuncs.com/"]
    }' | sudo tee "$file" > /dev/null
    echo "File $file created and content written."
else
    echo "File $file already exists."
fi

sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum makecache fast
sudo yum -y install docker-ce
sudo systemctl start docker
docker -v
echo "安装docker成功"

yum install -y python3-pip #python3安装pip3!!!
pip3 install -U pip setuptools
pip3 install docker-compose --default-timeout=100

end_time=$(date +%s)                # 获取当前时间戳（秒）
duration=$((end_time - start_time)) # 计算脚本执行时间（秒）
echo "安装docke-composer成功,脚本执行时间：${duration} 秒"
