# PROYECTO ORIGEN - Laboratorio Web IPv4 para Capa 4

Este proyecto contiene un servidor web HTML estatico sobre Nginx, pensado para el laboratorio de la unidad final de **Internet: Redes y Comunicaciones IP**.

El objetivo pedagogico es observar en GNS3 la relacion entre:

- Direccionamiento IPv4
- Capa 4 del modelo OSI
- TCP
- Puertos
- HTTP
- Captura y analisis de trafico con Wireshark

> Este laboratorio no busca ensenar desarrollo web. El formulario es deliberadamente simple para facilitar el analisis del trafico.

## Topologia de referencia

![Topologia del laboratorio](topologia-lab-ipv4.png)

Direccionamiento propuesto:

| Equipo | IPv4 | Funcion |
|---|---|---|
| R1 | `192.168.10.1/24` | Gateway |
| Raspbian | `192.168.10.11/24` | Cliente Linux |
| PC1 | `192.168.10.12/24` | Cliente VPCS |
| Servidor Web | `192.168.10.13/24` | Servidor HTTP |

## Estructura

```text
origen-web-ipv4/
├── Dockerfile
├── index.html
├── README.md
└── topologia-lab-ipv4.png
```

## Construccion de la imagen

```bash
docker build -t origen-web-ipv4 .
```

## Ejecucion local con Docker

```bash
docker run -d \
  --name origen-web-ipv4 \
  -p 8080:80 \
  origen-web-ipv4
```

Luego abrir:

```text
http://localhost:8080
```

## Uso en GNS3

La recomendacion es importar la imagen `origen-web-ipv4` como un **Docker container appliance** y conectar su interfaz `eth0` al switch del escenario.

Para una prueba temporal dentro del contenedor, se puede asignar:

```bash
ip addr add 192.168.10.13/24 dev eth0
ip link set eth0 up
ip route add default via 192.168.10.1
```

Validacion:

```bash
ip -br addr
ip route
ping -c 4 192.168.10.1
```

## Verificacion del servicio HTTP

Dentro del contenedor:

```bash
ss -lnt
```

Debe observarse el puerto TCP 80 en escucha.

Desde otro host:

```bash
curl http://192.168.10.13
```

## Captura con Wireshark

Filtros sugeridos:

```text
tcp.port == 80
```

```text
http
```

```text
http.request
```

La secuencia esperada incluye:

1. TCP SYN
2. TCP SYN/ACK
3. TCP ACK
4. HTTP GET

## Formulario y credenciales

El formulario utiliza intencionalmente:

```html
<form action="/" method="GET">
```

Esto permite observar que los campos enviados pueden aparecer en la URL y en la captura HTTP.

Ejemplo conceptual:

```text
GET /?usuario=daniel&password=origen123 HTTP/1.1
```

**No usar este patron en sistemas reales.** Su finalidad es exclusivamente didactica para demostrar que HTTP sin cifrado no protege las credenciales.

## Proposito del laboratorio

La idea central para los estudiantes es distinguir:

> La direccion IP identifica el host; el puerto identifica el servicio.

A partir de este escenario se puede evolucionar posteriormente hacia:

- HTTP vs HTTPS
- TCP vs UDP
- Puertos y sockets
- Nginx/Apache
- CMS
- Bases de datos
- Captura de sesiones reales

## PROYECTO ORIGEN

Explorar · Comprender · Conectar · Diagnosticar
