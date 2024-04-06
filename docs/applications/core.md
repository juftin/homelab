# Core Stack

## traefik

[![](https://img.shields.io/static/v1?message=traefik&logo=docker&label=docker&color=blue)](https://hub.docker.com/_/traefik)
[![](https://img.shields.io/static/v1?message=traefik/traefik&logo=github&label=github)](https://github.com/traefik/traefik)
[![](https://img.shields.io/static/v1?message=traefik.io&logo=google+chrome&label=website&color=teal)](https://docs.traefik.io)

<img src="https://i.imgur.com/PfNW7k9.png" width="300" alt="traefik Logo">

Traefik (pronounced traffic) is a modern HTTP reverse proxy and load balancer that makes
deploying microservices easy. Traefik integrates with your existing infrastructure components
(Docker, Swarm mode, Kubernetes, Marathon, Consul, Etcd, Rancher, Amazon ECS, ...)
and configures itself automatically and dynamically. Pointing Traefik
at your orchestrator should be the only configuration step you need.

## oauth

[![](https://img.shields.io/static/v1?message=thomseddon/traefik-forward-auth&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/thomseddon/traefik-forward-auth)
[![](https://img.shields.io/static/v1?message=thomseddon/traefik-forward-auth&logo=github&label=github)](https://github.com/thomseddon/traefik-forward-auth)

<img src="https://i.imgur.com/dEo52mz.png" width="250" alt="oauth">

A minimal forward authentication service that provides Google oauth based
login and authentication for the traefik reverse proxy/load balancer.

## duckdns

[![](https://img.shields.io/static/v1?message=linuxserver/duckdns&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/linuxserver/duckdns)
[![](https://img.shields.io/static/v1?message=linuxserver/docker-duckdns&logo=github&label=github)](https://github.com/linuxserver/docker-duckdns)
[![](https://img.shields.io/static/v1?message=duckdns.org&logo=google+chrome&label=website&color=teal)](https://www.duckdns.org)

<img src="https://i.imgur.com/eCBIhm2.jpg" width="250" alt="duckdns">

Duckdns is a free service which will point a DNS (subdomains of duckdns.org)
to an IP of your choice. The service is completely free, and doesn't
require reactivation or forum posts to maintain its existence.

## docker-socket-proxy

[![](https://img.shields.io/static/v1?message=tecnativa/docker-socket-proxy&logo=docker&label=docker&color=blue)](https://hub.docker.com/r/tecnativa/docker-socket-proxy)
[![](https://img.shields.io/static/v1?message=tecnativa/docker-socket-proxy&logo=github&label=github)](https://github.com/Tecnativa/docker-socket-proxy)

`docker-socket-proxy` is a security-enhanced proxy for the Docker Socket.
It blocks access to the Docker socket API according to the environment
variables you set. It returns a HTTP 403 Forbidden status for those
dangerous requests that should never happen.
