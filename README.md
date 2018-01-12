# docker_nginx_ubuntu
Docker image of nginx on ubuntu for small static content

## Usage:

- Create a swarm on swarm routing mesh as per usual.
  ```shell
  docker swarm init
  ```
- On worker nodes you run the command that swarm init generates
- Create the service like this
  ```shell
  docker service create --name="staticnginx" --publish published=80,target=80 --mount type=volume, \
  source=/var/lib/docker/dansta_docker_nginx_ubuntu/var/log, \
  destination=/var/log/ \
  --mount type=volume, \
  source=/var/lib/docker/dansta_docker_nginx_ubuntu/usr/share/nginx/html/, \
  destination=/usr/share/nginx/html/ \
  dansta/docker_nginx_ubuntu
  ```
- Scale the service to 4 containers
  ```shell
  docker service scale staticnginx=4
  ```
