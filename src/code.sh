#!/bin/bash

#echo "Here is the content of /opt/dxfuse"
#ls -lh /opt/dxfuse

#echo "=== Mounting project data to /mnt/project ==="
#mkdir -p /mnt/project
#/opt/dxfuse/dxfuse /mnt/project project-Gx25k98J08pkk84J3V1JPPGY
#Using startup.sh script we mount project data into /mnt/project

echo "== Prepare env =="
bash /opt/startup.sh

echo "=== Content of project data ==="
ls /mnt/project

echo "=== Starting JupyterLab ==="
echo "Display url: $DX_PUBLIC_HOSTNAME"
echo "Display url: $DX_CLUSTER_HOSTNAME"
echo "Docker image: ${docker_image}"

gpu_option=""
if [[ "${use_gpu}" == "true" ]]; then
	gpu_option="--gpus all"
	echo "Using GPU: ${gpu_option}"
fi

docker run -p 443:443 ${gpu_option} \
	-v /mnt/project:/home/dnanexus/project_data \
	-v /home/dnanexus \
	${additional_mounts} \
	${docker_image} \
	jupyter lab \
	--ip=* \
	--port=443 \
	--no-browser \
	--NotebookApp.token='' \
	--NotebookApp.allow_remote_access=True \
	--NotebookApp.disable_check_xsrf=True \
	--allow-root \
	--log=INFO \
	--notebook-dir="/home/dnanexus" \
	--NotebookApp.custom_display_url=$DX_CLUSTER_HOSTNAME
