# Run Mock API Server
1. Start Mocki service 
    ```bash
    docker-compose up -d mocki
    ```
2. Restart Mocki when have some updates on config.yml (eg. edited or pulled from upstream)
    ```bash
    docker-compose restart mocki
    ```