# Build the docker image with
# "docker build -t <name for image> ."

# Image source for the docker image. ubuntu/fedora/nginx/apache
FROM nginx

# Pass through specific port from docker image onto the actual computer
EXPOSE 443
# Map exposed port to a different port on the machine from command line with
# "docker run -p <different port>:443 <image name>"



# Run commands when building the docker image
# Install openssl package in order to create ssl certificates
RUN apt-get update && apt-get install -y openssl nano

# Generate the ssl certificates without interaction by passing the fields as a argument
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/key.key -out /etc/ssl/certs/cert.crt \
    -subj "/C=US/ST=State/L=Locality/O=Organization/CN=Common"

# Create the folder to hold the enabled websites
RUN mkdir -p /etc/nginx/sites-enabled



# Copy files over from the computer onto the docker image
# Copy the nginx configuration file and replace the default one
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the html folder that contains the html files
COPY html/ /usr/share/nginx/html/

# Copy the configuration for the website
COPY default /etc/nginx/sites-enabled/default
