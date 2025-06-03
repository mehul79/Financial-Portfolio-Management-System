/**
 * Oracle Image Starter Guide
 *
 * This module provides instructions for creating and starting an Oracle image inside the `oracle_img` folder.
 *
 * ## Getting Started
 *
 * 1. **Navigate to the oracle_img Directory**
 *    ```sh
 *    cd oracle_img
 *    ```
 *
 * 2. **Build the Oracle Docker Image**
 *    Ensure you have a valid Dockerfile in the `oracle_img` directory.
 *    ```sh
 *    docker build -t my-oracle-db .
 *    ```
 *
 * 3. **Start the Oracle Container**
 *    Run the following command to start the Oracle container:
 *    ```sh
 *    docker run -d --name oracle-db -p 1521:1521 -p 5500:5500 my-oracle-db
 *    ```
 *
 * 4. **Verify the Container is Running**
 *    ```sh
 *    docker ps
 *    ```
 *
 * 5. **Connect to the Oracle Database**
 *    Use your preferred SQL client to connect to `localhost:1521` with the appropriate credentials.
 *
 * ## Notes
 * - Ensure Docker is installed and running on your system.
 * - Adjust port mappings and environment variables as needed for your setup.
 */