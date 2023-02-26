RDKIT_BRANCH="Release_2022_09"
build:
	docker build -build-arg RDKIT_BRANCH=$(RDKIT_BRANCH) -t rdkit_debian:latest .

build-nocache:
	docker build --no-cache --build-arg RDKIT_BRANCH=$(RDKIT_BRANCH) -t rdkit_debian:latest .

run:
	docker run -ti --rm rdkit_debian:latest

tag:
	docker tag rdkit_debian:latest veyrich/rdkit_debian:latest

push:
	docker push veyrich/rdkit_debian:latest

all: build tag push
	echo "all"

