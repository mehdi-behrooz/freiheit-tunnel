### Intro

Reverse tunneling using [Gost](https://github.com/go-gost/gost)

### Usage

##### Tunnel Server (Tunnel Enterance)

```yaml
  tunnel-server:
    image: ghcr.io/mehdi-behrooz/freiheit-tunnel
    container_name: tunnel-server
    restart: unless-stopped
    ports:
      - 8000:8000
    environment:
      - MODE=server
      - LISTEN_ON=8000
      - USERNAME=myusername
      - PASSWORD=mypassword
      - LOG_LEVEL=info

```


##### Tunnel Client (Tunnel Endpoint)


```yaml

  tunnel-client:
    image: ghcr.io/mehdi-behrooz/freiheit-tunnel
    container_name: tunnel-client
    restart: unless-stopped
    environment:
      - MODE=client
      - SERVER_HOST=tunnel-server.host.com
      - SERVER_PORT=8000
      - USERNAME=myusername
      - PASSWORD=mypassword
      - MAP=:80>nginx1:8080;:443>nginx2:443 
      - LOG_LEVEL=info

  nginx1:
    image:nginx
    ...

  nginx2:
    image:nginx
    ...  

```
The map variable uses the syntax `server_destination_1>client_destination_1;server_destination_2>client_destination_2;....` 
For example, the expression `:80>nginx1:8080;:443>nginx2:443` above, tells the tunnel to redirect all traffic on port 80 of 
the tunnel server to the port 8080 of the local container named 'nginx1' and all traffic on port 443 of the tunnel server to 
the port 443 of the other container named 'nginx2'.
