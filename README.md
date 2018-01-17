# docker_nginx_ubuntu
Docker image of nginx on ubuntu for small static content

## Usage:

## Manual
- Create a swarm on swarm routing mesh as per usual.
  ```shell
  docker swarm init
  ```
- On worker nodes you run the command that swarm init generates
- Create the service like this
  ```shell
  docker service create \
  --name="staticnginx" \
  --publish published=80,target=80,protocol=tcp \
  --mount type=volume, \
  source=nginx, \
  destination=/var/log/ \
  --mount type=volume, \
  source=nginx, \
  destination=/usr/share/nginx/html/ \
  nginxservice
  ```
- Scale the service to 4 containers
  ```shell
  docker service scale nginxservice=4
  ```

## Automagic
- Start a shell and run
  ```shell
  nginx/makeservice.sh
  ```
