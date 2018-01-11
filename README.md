# Redis HA

This docker compose files contains creation of a Redis Master-Slave replication nodes with Sentinel processes to guarantee high availability.

It creates three containers, one master and two slaves. Sentinel processes are installed in the three containers.

## Installation

Download this files. Execute a command line window and locate to the folder that contain this files and execute

`docker-compose up -d`
