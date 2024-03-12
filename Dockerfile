# Use a specific version of Ubuntu to ensure consistency across builds.
FROM ubuntu:latest

# Update the system and install Python3, pip, and other necessary tools.
RUN apt-get update && \
    apt-get install -y python3 python3-pip 

# Set the working directory to /app
WORKDIR /app

# Copy the requirements file first to leverage Docker cache
COPY requirements.txt .

# Create user for running applications
RUN useradd -m -s /bin/bash jupyter && \
    chown -R jupyter:jupyter /app

# Install Python dependencies from requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

# Actualizar  dependencias específicas.
RUN pip3 install --no-cache-dir --upgrade langchain-openai

# Switch to the non-root user
USER jupyter

# Set the user's home directory as the working directory
WORKDIR /home/jupyter

# Copy the rest of the application with appropriate permissions
COPY --chown=jupyter:jupyter .env .env
COPY --chown=jupyter:jupyter docs/ docs/
COPY --chown=jupyter:jupyter chatbot.ipynb chatbot.ipynb

# Set the default command to run the Jupyter notebook server
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--NotebookApp.token=", "--port=8888", "--no-browser", "--allow-root"]