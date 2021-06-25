docker build ./chaingreen-docker --build-arg BRANCH=main -t joeharrison714/chaingreen-docker
docker push joeharrison714/chaingreen-docker:latest

docker build ./flax-docker --build-arg BRANCH=main -t joeharrison714/flax-docker
docker push joeharrison714/flax-docker:latest

docker build ./spare-docker --build-arg BRANCH=master -t joeharrison714/spare-docker
docker push joeharrison714/spare-docker:latest