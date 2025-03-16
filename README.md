# Multi-Tor-Proxy

A Docker-based solution that creates multiple Tor proxy connections with HAProxy load balancing and Privoxy for web proxy functionality. This project allows you to route your traffic through multiple Tor circuits simultaneously, providing enhanced anonymity and distribution of requests across different exit nodes.

## Features

- **Multiple Tor Circuits**: Create and manage multiple Tor connections simultaneously
- **Load Balancing**: HAProxy distributes traffic across all Tor circuits using round-robin algorithm
- **Web Proxy Support**: Privoxy integration for HTTP/HTTPS proxy functionality
- **Configurable**: Easily adjust the number of Tor connections and port settings
- **Monitoring**: Built-in HAProxy stats page for monitoring connection status
- **Containerized**: Fully Dockerized solution for easy deployment
- **SOCKS5 Support**: Connect via SOCKS5 protocol
- **Circuit Rotation**: Automatic circuit rotation for enhanced anonymity

## Prerequisites

- Docker (version 19.03.0+)
- Docker Compose (optional, for easier management)
- Basic understanding of proxy configuration

## Installation

### Option 1: Using Docker directly

1. Clone this repository:

   ```bash
   git clone https://github.com/andyfarthing/multi-tor-proxy.git
   cd multi-tor-proxy
   ```

2. Build the Docker image:

   ```bash
   docker build -t multi-tor-proxy .
   ```

3. Run the container:
   ```bash
   docker run -d --name multi-tor-proxy \
     -p 8118:8118 \
     -p 16859:16859 \
     -p 80:80 \
     -e NUMBER_OF_CONNECTIONS=5 \
     -e STARTING_PORT_NUMBER=9050 \
     multi-tor-proxy
   ```

### Option 2: Using Docker Compose

1. Create a `docker-compose.yml` file:

   ```yaml
   version: "3"
   services:
     multi-tor-proxy:
       build: .
       ports:
         - "8118:8118"
         - "16859:16859"
         - "80:80"
       environment:
         - NUMBER_OF_CONNECTIONS=5
         - STARTING_PORT_NUMBER=9050
       restart: unless-stopped
   ```

2. Start the service:
   ```bash
   docker-compose up -d
   ```

## Usage

### HTTP/HTTPS Proxy

Configure your browser or application to use the HTTP proxy at:

- Host: `localhost` (or your Docker host IP)
- Port: `8118`

Example with curl:

```bash
curl --proxy http://localhost:8118 https://check.torproject.org/api/ip
```

### SOCKS5 Proxy

For applications that support SOCKS5:

- Host: `localhost` (or your Docker host IP)
- Port: `16859`

Example with curl:

```bash
curl --socks5 localhost:16859 https://check.torproject.org/api/ip
```

### Monitoring

Access the HAProxy stats page to monitor your Tor connections:

- URL: `http://localhost:80/`

## Configuration

### Environment Variables

| Variable                | Description                          | Default |
| ----------------------- | ------------------------------------ | ------- |
| `NUMBER_OF_CONNECTIONS` | Number of Tor circuits to create     | 5       |
| `STARTING_PORT_NUMBER`  | Base port number for Tor SOCKS ports | 9050    |

### Advanced Configuration

You can modify the following configuration files before building the Docker image:

- `torrc`: Tor configuration
- `haproxy.cfg`: HAProxy load balancer configuration
- `privoxy.cfg`: Privoxy web proxy configuration

## Project Structure

```
multi-tor-proxy/
├── .dockerignore        # Files to exclude from Docker build
├── .gitignore           # Files to exclude from Git
├── build_connections.sh # Script to build Tor connections
├── Dockerfile           # Docker image definition
├── haproxy.cfg          # HAProxy configuration
├── privoxy.cfg          # Privoxy configuration
├── README.md            # This documentation
└── torrc                # Tor configuration
```

## How It Works

1. The container starts and runs the `build_connections.sh` script
2. The script creates the specified number of Tor connections (default: 5)
3. Each Tor instance listens on a different port starting from the base port (default: 9050)
4. HAProxy is configured to load balance across all Tor instances
5. Privoxy forwards HTTP/HTTPS requests to HAProxy
6. Traffic is distributed across multiple Tor circuits

## Testing

To verify that your traffic is going through Tor:

```bash
# Using the HTTP proxy
curl --proxy http://localhost:8118 https://check.torproject.org/api/ip

# Using the SOCKS proxy
curl --socks5 localhost:16859 https://check.torproject.org/api/ip
```

You should see a response confirming you're using the Tor network.

To test that you're getting different exit nodes:

```bash
# Run multiple times to see different IPs
for i in {1..5}; do
  curl --proxy http://localhost:8118 https://api.ipify.org
  echo
  sleep 2
done
```

## Contributing

Contributions are welcome! Here's how you can contribute:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Submit a pull request

### Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation for any changes
- Keep pull requests focused on a single feature/fix

## Troubleshooting

### Common Issues

1. **Connection refused errors**:

   - Ensure the container is running: `docker ps`
   - Check container logs: `docker logs multi-tor-proxy`

2. **Slow connections**:

   - This is normal for Tor. Consider adjusting `NewCircuitPeriod` in torrc

3. **Cannot access HAProxy stats**:
   - Verify port mapping: `docker port multi-tor-proxy`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Tor Project](https://www.torproject.org/) for the anonymous network
- [HAProxy](http://www.haproxy.org/) for the load balancing solution
- [Privoxy](https://www.privoxy.org/) for the web proxy functionality
- [Alpine Linux](https://alpinelinux.org/) for the lightweight base image

## Changelog

### v1.0.1 (Current)

- Minor bug fixes and improvements

### v1.0.0

- Initial release with core functionality
- Support for multiple Tor connections
- HAProxy load balancing
- Privoxy integration
