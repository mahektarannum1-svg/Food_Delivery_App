# Setup & Installation Guide
## JEE Food App - Development and Production Deployment

**Version:** 1.0  
**Date:** December 2024  
**DevOps Team:** Development Team  

---

## Overview

This guide provides step-by-step instructions for setting up and deploying the JEE Food App in both development and production environments.

## Prerequisites

### System Requirements

**Development Environment:**
- Operating System: Windows 10/11, macOS 11+, or Ubuntu 20.04+
- RAM: Minimum 8GB (16GB recommended)
- Storage: 20GB available space
- Processor: Intel i5/AMD Ryzen 5 or equivalent
- Network: Broadband internet connection

**Production Environment:**
- Operating System: Ubuntu Server 20.04 LTS or CentOS 7+
- RAM: 8GB minimum (32GB recommended for high traffic)
- Storage: 100GB SSD
- Processor: 4-core CPU, 2.5GHz minimum
- Network: Dedicated server with static IP

### Software Requirements

**Required Software:**
- Java Development Kit (JDK) 17 or later
- Apache Tomcat 9.0 or later
- MySQL Server 8.0 or later
- Git for version control (optional)
- Apache Maven 3.6+ (optional, for build automation)

## Development Environment Setup

### Step 1: Install Java Development Kit (JDK)

#### On Windows:
```bash
1. Download JDK 17 from oracle.com or adoptopenjdk.net
2. Run the installer
3. Follow installation wizard
4. Set JAVA_HOME environment variable:
   - Right-click "This PC" → Properties
   - Click "Advanced system settings"
   - Click "Environment Variables"
   - Click "New" under System variables
   - Variable name: JAVA_HOME
   - Variable value: C:\Program Files\Java\jdk-17
   - Click OK
5. Verify installation: open cmd and type "java -version"
```

#### On macOS:
```bash
brew install openjdk@17
echo 'export JAVA_HOME=$(/usr/libexec/java_home -v 17)' >> ~/.zshrc
source ~/.zshrc
java -version
```

#### On Ubuntu/Linux:
```bash
sudo apt update
sudo apt install openjdk-17-jdk
java -version
```

### Step 2: Install MySQL Server

#### On Windows:
```
1. Download MySQL installer from mysql.com
2. Run mysql-installer-community-x.x.x.msi
3. Choose "Developer Default" setup type
4. Configure MySQL Server:
   - Port: 3306 (default)
   - MySQL X Protocol Port: 33060
5. Configure MySQL as Windows Service
6. Set password for root user
7. Complete installation
8. Verify: mysql -u root -p (enter password)
```

#### On macOS:
```bash
brew install mysql@8.0
brew services start mysql@8.0
mysql_secure_installation
```

#### On Ubuntu/Linux:
```bash
sudo apt update
sudo apt install mysql-server
sudo mysql_secure_installation
sudo systemctl start mysql
```

### Step 3: Install Eclipse IDE

#### Installation Steps:
```
1. Download Eclipse IDE for Enterprise Java from eclipse.org
2. Extract the downloaded file to desired location
3. Navigate to extracted folder and run eclipse.exe (Windows) or eclipse (Mac/Linux)
4. Choose workspace directory (default is fine)
5. Click "Launch"
```

#### Configure Eclipse:
```
1. Go to Window → Preferences
2. Set Java compiler to version 17:
   - Java → Compiler → Set to 17
3. Configure Tomcat server:
   - Server → Runtime Environments → Add
   - Select Apache Tomcat 9.0
   - Browse to Tomcat installation directory
   - Click Apply and Close
```

### Step 4: Download Tomcat Server

#### Installation Steps:
```
1. Download Tomcat 9.0.x from tomcat.apache.org
2. Extract to C:\Apache Tomcat (Windows) or /usr/local/tomcat (Linux)
3. Add Tomcat to Eclipse:
   - Window → Preferences → Server → Runtime Environments
   - Click Add → Apache Tomcat v9.0
   - Browse to Tomcat directory
   - Click Apply and Close
```

### Step 5: Set Up Project in Eclipse

#### Import/Create Project:
```
1. Open Eclipse
2. File → New → Dynamic Web Project
3. Project name: JEE_Food_APP
4. Target runtime: Apache Tomcat 9.0
5. Dynamic web module version: 4.0 (or latest)
6. Click Finish
```

#### Download and Extract Project Files:
```
1. Clone repository or download project files:
   git clone <repository-url>
2. Copy src/ contents to Eclipse project src/ folder
3. Copy WebContent/ contents to Eclipse project WebContent/ folder
4. Refresh project: F5
```

### Step 6: Configure Database

#### Create Database and Tables:

```sql
-- Create database
CREATE DATABASE IF NOT EXISTS instant_food;
USE instant_food;

-- Create tables (see 5_Database_Schema_Documentation.md for full schema)
CREATE TABLE user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    password_salt VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    phone_number VARCHAR(15),
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER',
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create other tables...
-- (Run complete SQL script from database documentation)
```

#### Insert Sample Data:
```sql
-- Insert sample users
INSERT INTO user (username, email, password_hash, password_salt, full_name) 
VALUES ('testuser', 'test@example.com', 'hashed_password', 'salt', 'Test User');

-- Insert sample restaurants
INSERT INTO restaurant (restaurant_name, cuisine_type, address, delivery_time) 
VALUES ('Pizza Palace', 'Italian', '123 Main St', 30);

-- Insert sample menu items
-- (See 5_Database_Schema_Documentation.md for complete sample data)
```

### Step 7: Configure Database Connection

#### Update DBConnection.java:
```java
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/instant_food";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "your_password_here";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName(DRIVER);
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
```

### Step 8: Add MySQL JDBC Driver

#### Add to Project:
```
1. Download mysql-connector-java-8.0.33.jar from mysql.com
2. Copy jar file to: WebContent/WEB-INF/lib/
3. Right-click project → Build Path → Add External Archives
4. Select the MySQL JAR file
5. Click OK
```

### Step 9: Run Application in Development

#### Start Tomcat Server in Eclipse:
```
1. Window → Show View → Servers
2. Right-click in Servers panel → New → Server
3. Select Apache Tomcat 9.0
4. Click Next and configure as needed
5. Click Finish
6. Right-click server → Start
```

#### Deploy Project:
```
1. Right-click project → Run As → Run on Server
2. Select Apache Tomcat 9.0
3. Click Finish
4. Application opens in default browser at http://localhost:8080/JEE_Food_APP
```

#### Access Application:
```
URL: http://localhost:8080/JEE_Food_APP/
Default pages: 
- index.jsp (home page)
- login.jsp (authentication)
- restaurants.jsp (restaurant listing)
```

## Production Deployment

### Step 1: Prepare Production Server

#### Ubuntu Server Setup:
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Java
sudo apt install openjdk-17-jdk -y

# Install MySQL
sudo apt install mysql-server -y
sudo mysql_secure_installation

# Install Tomcat
sudo groupadd tomcat
sudo useradd -M -s /bin/nologin -g tomcat tomcat
cd /opt
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.x/bin/apache-tomcat-9.0.x.tar.gz
sudo tar xzf apache-tomcat-9.0.x.tar.gz
sudo mv apache-tomcat-9.0.x /opt/tomcat
sudo chown -R tomcat:tomcat /opt/tomcat
```

### Step 2: Configure Database for Production

#### Create Database and User:
```sql
-- Create application database
CREATE DATABASE instant_food CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Create database user
CREATE USER 'foodapp'@'localhost' IDENTIFIED BY 'strong_password_here';

-- Grant privileges
GRANT ALL PRIVILEGES ON instant_food.* TO 'foodapp'@'localhost';
FLUSH PRIVILEGES;

-- Create tables and insert data
USE instant_food;
-- (Run complete SQL schema script)
```

### Step 3: Build Application for Deployment

#### Using Eclipse:
```
1. Right-click project → Export → WAR file
2. Specify export destination: app.war
3. Click Finish
```

#### Manual Build Process:
```bash
# Compile Java files
javac -d build/classes src/com/dcl/**/*.java

# Create WAR file
jar cvf JEE_Food_APP.war -C build/classes . -C WebContent .
```

### Step 4: Deploy to Production

#### Deploy WAR File:
```bash
# Copy WAR file to Tomcat
sudo cp JEE_Food_APP.war /opt/tomcat/webapps/

# Tomcat automatically extracts and deploys
# Verify deployment
ls -la /opt/tomcat/webapps/JEE_Food_APP/
```

### Step 5: Configure SSL/TLS

#### Install SSL Certificate:
```bash
# Using Let's Encrypt (free)
sudo apt install certbot python3-certbot-apache -y
sudo certbot certonly --standalone -d yourdomain.com

# Certificate location: /etc/letsencrypt/live/yourdomain.com/
```

#### Configure Tomcat with SSL:
```xml
<!-- Edit /opt/tomcat/conf/server.xml -->
<Connector port="8443" protocol="org.apache.coyote.http11.Http11NioProtocol"
           maxThreads="150" SSLEnabled="true">
    <SSLHostConfig>
        <Certificate certificateKeyFile="/etc/letsencrypt/live/yourdomain.com/privkey.pem"
                     certificateFile="/etc/letsencrypt/live/yourdomain.com/cert.pem"
                     certificateChainFile="/etc/letsencrypt/live/yourdomain.com/chain.pem"
                     type="RSA" />
    </SSLHostConfig>
</Connector>
```

### Step 6: Configure Reverse Proxy (Nginx)

#### Nginx Configuration:
```nginx
# /etc/nginx/sites-available/default

upstream tomcat {
    server localhost:8080;
}

server {
    listen 80;
    server_name yourdomain.com;
    
    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com;
    
    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;
    
    location / {
        proxy_pass http://tomcat;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### Reload Nginx:
```bash
sudo nginx -t  # Test configuration
sudo systemctl restart nginx
```

### Step 7: Start Services

#### Start Tomcat Service:
```bash
# Create systemd service file
sudo nano /etc/systemd/system/tomcat.service
```

```ini
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

[Install]
WantedBy=multi-user.target
```

#### Enable and Start Services:
```bash
# Enable Tomcat service
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

# Verify services
sudo systemctl status tomcat
sudo systemctl status nginx
sudo systemctl status mysql
```

### Step 8: Configure Monitoring and Logs

#### View Tomcat Logs:
```bash
# Real-time log monitoring
tail -f /opt/tomcat/logs/catalina.out

# Application logs
tail -f /opt/tomcat/logs/localhost.log
```

#### Set Up Log Rotation:
```bash
# Create logrotate configuration
sudo nano /etc/logrotate.d/tomcat
```

```
/opt/tomcat/logs/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 tomcat tomcat
    sharedscripts
    postrotate
        /bin/kill -SIGUSR1 `cat /opt/tomcat/tomcat.pid 2>/dev/null` 2>/dev/null || true
    endscript
}
```

## Verification Checklist

### Development Environment
- [ ] Java 17 installed and JAVA_HOME set
- [ ] MySQL server running
- [ ] Eclipse IDE configured
- [ ] Tomcat runtime added to Eclipse
- [ ] Project imported/created in Eclipse
- [ ] Database created with tables
- [ ] DBConnection credentials correct
- [ ] MySQL JDBC driver in WEB-INF/lib
- [ ] Application accessible at localhost:8080

### Production Environment
- [ ] Server OS installed and updated
- [ ] Java 17 JDK installed
- [ ] MySQL server installed and secured
- [ ] Tomcat installed and running as service
- [ ] Database created with proper user permissions
- [ ] SSL certificate installed
- [ ] Nginx reverse proxy configured
- [ ] Application accessible via HTTPS
- [ ] All services set to auto-start
- [ ] Monitoring and logging configured

## Troubleshooting

### Common Issues and Solutions

**Issue: "Connection refused" to MySQL**
```
Solution:
1. Check MySQL service is running: sudo systemctl status mysql
2. Verify credentials in DBConnection.java
3. Check MySQL is listening on 3306: sudo netstat -tulpn | grep mysql
4. Create database if it doesn't exist
```

**Issue: Tomcat won't start**
```
Solution:
1. Check logs: tail -f /opt/tomcat/logs/catalina.out
2. Verify Java is installed: java -version
3. Check JAVA_HOME environment variable
4. Ensure port 8080 is not in use: sudo netstat -tulpn | grep 8080
```

**Issue: JSP pages not rendering**
```
Solution:
1. Rebuild project: Project → Clean
2. Restart Tomcat server
3. Check WebContent folder has JSP files
4. Verify web.xml configuration
5. Check Tomcat logs for errors
```

**Issue: Database connection pool exhausted**
```
Solution:
1. Implement connection pooling (HikariCP)
2. Increase max connections in MySQL: max_connections=200
3. Monitor connection usage
4. Implement connection timeout handling
```

---

**Document Status:** Approved  
**Next Review Date:** Q2 2025  
**DevOps Team:** Development Team, Infrastructure Team