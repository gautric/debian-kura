DOCKER_IMAGE_VERSION=1.3.0
DOCKER_IMAGE_NAME=gautric/debian-kura$(RPI_MODEL)
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)


default: build

docker:
	eval "$(docker-machine env default)"

build: docker
	docker build --build-arg RPI_VERSION=raspberry-pi$(RPI_MODEL)-nn -t $(DOCKER_IMAGE_TAGNAME) .
	docker tag -f $(DOCKER_IMAGE_TAGNAME) $(DOCKER_IMAGE_NAME):latest

push: build
	docker push $(DOCKER_IMAGE_NAME)

test: build
	docker run --rm $(DOCKER_IMAGE_TAGNAME) /bin/echo "Success."

version: build
	docker run --rm $(DOCKER_IMAGE_TAGNAME) java -version

all:
			# For first version
		  make
			# for other version
	    for model in bplus 2 ; do \
					export RPI_MODEL=-$$model ; \
					make build ; \
	    done
