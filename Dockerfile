FROM python:3.9-alpine3.13
LABEL maintainer="nguyenhuelinh.97@gmail.com"
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py && \
    /py/bin/pip  install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = "true" ]; \
      then /py/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \ 
    adduser \
      --disabled-password \
      --no-create-home \
      django-user

ENV PATH="/py/bin:$PATH"

USER django-user

# FROM python:3.9-alpine3.13 => python: ten image of docker image size on docker hub, 3.9-alpine3.13: name of the tag, 
# alpine is lightweight version of linux, it 's ideal for r unning docker container because it very stripped back, 
# It doesn't have any unnecessary dependencies that you would need.

# ENV PYTHONUNBUFFERED 1: it tells Python that you don't want to buffer the output.

# COPY ./requirements.txt /tmp/requirements.txt: copy our requirements.txt from our local machine to /tmp/requirements.txt
# COPY ./app /app: copy app directory into /app
# EXPOSE 8000: expose port 8000 from our container to out machine when we run the container

# python -m venv /py : create a new virtual env that we are going to use to store our dependencies
# there may be some edge cases where there are some python dependencies on the actual base image that might conflict with your python dependencies for your project.
# to avoid this happening and to reduce any risk, you can create a virtual environment in the Docker image and it doesn't really add that much overhead.
 
# /py/bin/pip  install --upgrade pip => upgrade python package manager inside our virtual env

# /py/bin/pip install -r /tmp/requirements.txt => install list of requiments inside the docker image
 
#  rm -rf /tmp  => remove tmp directory, we don't want ay extra dependencies on our image => make sure docker image lightweight as possible, save space and speed when deploy to prod

# adduser --disabled-password --no-create-home django-user => call the ADD user command, which add a new user inside our image , we do this because best practice not to use root user 
# DON'T RUN APPLICATION USING ROOT USER: if your app get compromised => attacker may have full access everything 

# ENV PATH="/py/bin:$PATH" => update environment variables inside the image and we're updating the path enviroment variable, the path is the env that's automatically created on linux operating systems

# USER django-user => this should be our last line of docker file and this specifies the user that we're switching to 

# ARG DEV=false: this defines a build argument called dev and sets the default value to false.