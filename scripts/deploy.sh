- name: Create deploy.sh
  run: |
    cat << EOF > scripts/deploy.sh
    #!/bin/bash
    set -e

    # Update and install dependencies
    sudo apt-get update
    sudo apt-get install -y python3-pip

    sudo rm -rf /home/useradmin/app

    # Clone the repository
    git clone https://github.com/yourusername/yourrepository.git /home/useradmin/app

    # Set up the application
    cd /home/useradmin/app

    python3 -m venv venv
    source venv/bin/activate

    sudo chown -R useradmin:useradmin /home/useradmin/app/venv

    pip3 install -r requirements.txt

    # Set up systemd service
    cat << EOT > /etc/systemd/system/fastapi.service
    [Unit]
    Description=FastAPI application
    After=network.target

    [Service]
    User=useradmin
    WorkingDirectory=/home/useradmin/app
    ExecStart=/home/useradmin/app/venv/bin/python -m uvicorn main:app --host 0.0.0.0 --port 8000
    Restart=always
    Environment="PATH=/home/useradmin/app/venv/bin"  
    
    [Install]
    WantedBy=multi-user.target
    EOT

    # Start the service
    sudo systemctl daemon-reload
    sudo systemctl enable fastapi
    sudo systemctl restart fastapi


    echo "Deployment completed successfully"
    EOF

    chmod +x scripts/deploy.sh