- name: Create deploy.sh
  run: |
    cat << EOF > scripts/deploy.sh
    #!/bin/bash
    set -e

    # Update and install dependencies
    sudo apt-get update
    sudo apt-get install -y python3-pip

    # Clone the repository
    git clone https://github.com/yourusername/yourrepository.git /home/azureuser/app

    # Set up the application
    cd /home/azureuser/app
    pip3 install -r requirements.txt

    # Set up systemd service
    cat << EOT > /etc/systemd/system/fastapi.service
    [Unit]
    Description=FastAPI application
    After=network.target

    [Service]
    User=azureuser
    WorkingDirectory=/home/azureuser/app
    ExecStart=/usr/bin/python3 -m uvicorn main:app --host 0.0.0.0 --port 8000
    Restart=always

    [Install]
    WantedBy=multi-user.target
    EOT

    # Start the service
    sudo systemctl daemon-reload
    sudo systemctl enable fastapi
    sudo systemctl start fastapi

    echo "Deployment completed successfully"
    EOF

    chmod +x scripts/deploy.sh