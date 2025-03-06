---
title: Container orchestration
draft: true 
date: 2025-03-06
pin: false
# links:
#   - Test: setup/setting-up-site-search.md
# tags:
#     - test
authors:
    - louison
---

In a homelab environment, selecting the most suitable container orchestration tool is crucial for optimizing experimentation and management.  
This article compares Docker Compose, Docker Swarm, Kubernetes light distribution (like K0S and Minikube), and Kubernetes to identify the best fit for my use case. Docker Compose simplifies multi-container setups while Docker Swarm provides straightforward clustering and scaling, and K0S and Minikube offer lightweight Kubernetes experiences for testing and learning.
<!-- more -->

# Definitions

Docker Compose
: A tool for defining and running multi-container Docker applications using a simple YAML file to configure services, networks, and volumes.

Docker Swarm
: Docker's native clustering and orchestration tool that allows you to manage a group of Docker engines as a single virtual system for deploying applications.

Lightweight Kubernetes distributions (K0s, K3s, minikube, etc.)
: Simplified versions of Kubernetes designed for local development or small-scale deployments, making it easy to run Kubernetes clusters on personal machines.

Kubernetes
: An open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications across clusters of machines.

# General comparison

| **Feature/Aspect**   | **Docker Compose**                  | **Docker Swarm**                        | **Lightweight Kubernetes**            | **Kubernetes**                                   |
| -------------------- | ----------------------------------- | --------------------------------------- | ------------------------------------- | ------------------------------------------------ |
| **Purpose**          | Define and run multi-container apps | Cluster management and orchestration    | Local development and testing         | Full-scale container orchestration               |
| **Complexity**       | Simple and easy to use              | Moderate complexity                     | Low complexity                        | High complexity                                  |
| **Deployment Scale** | Best for single-host applications   | Multi-host, but simpler than Kubernetes | Local or small clusters               | Large-scale, production-grade clusters           |
| **Networking**       | Basic networking capabilities       | Built-in overlay networking             | Basic networking                      | Advanced networking features                     |
| **State Management** | Stateless by default                | Supports stateful services              | Limited state management              | Robust state management with persistent storage  |
| **Use Case**         | Development and testing             | Simple production deployments           | Local development and experimentation | Production environments and complex applications |
| **Learning Curve**   | Low                                 | Moderate                                | Low                                   | High                                             |

# Key features rating

| **Drivers**                 | **Docker Compose** | **Docker Swarm** | **Lightweight Kubernetes** | **Kubernetes** |
| --------------------------- | :----------------: | :--------------: | :------------------------: | :------------: |
| Ease of use                 |       *****        |       ****       |            ***             |       **       |
| Leaning goals               |         *          |       ****       |            ***             |       **       |
| Resource efficiency         |        ****        |       ****       |            ***             |       *        |
| Documentation and community |        ****        |       ****       |            ***             |     *****      |
| Ease of maintenance         |       *****        |      *****       |            ***             |      ***       |
| Ease of evolution           |       *****        |      *****       |             **             |       **       |
| Total                       |         24         |      ==26==      |             17             |       15       |

# Detailed Pros and cons

## Docker Compose

On my previous (actual at the time i'm writing this) NAS I used Docker Compose to deploy my services. Docker Compose allow the definition of the deployments in a simple `docker-compose.yaml` file and with minimal configuration. I consider Docker Compose as an easy and efficient way to deploy stuff but it can lack some features.


Pros
: - Easy to use and setup
: - Easy deployment declaration

Cons
: - Not really an orchestrator
: - Already known
: - Limited to single-host deployments


## Docker Swarm

Docker Swarm is a native clustering and orchestration tool for Docker. It provides more feature that Docker Compose like load balancing, service discovery, and scaling for containerized applications.

Pros
: - Easy to use and setup
: - Built-in load balancing and service discovery

Cons
: - Less feature than Kubernetes
: - Potential leaning experience (Never used neither as a hobby nor at work)

## Lightweight Kubernetes

Lightweight Kubernetes are designed to provide a simplified Kubernetes experience for local development and testing. It provide a way to run Kubernetes clusters on a local machines with minimal setup and resource requirements.

Pros
: - Easy to use and setup
: - Provides simplified Kubernetes experience

Cons
: - Less featured than Kubernetes
: - For testing and developing purpose (not for prod in theory)

## Kubernetes

Kubernetes automates the deployment, scaling, and management of containerized applications across clusters of hosts. It offers advanced features like self-healing, load balancing, and service discovery.

Pros
: - Highly scalable and robust
: - Huge ecosystem, tools and plugins

Cons
: - More complex to setup
: - Less resource efficient