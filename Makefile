run:
	sudo docker run -itd \
		-v "/docker/git/hostkeys:/etc/ssh/hostkeys" \
		-v "/docker/git/home:/home/git" \
		"gitolite:$(shell cat VERSION)"

build:
	sudo docker build . -t "gitolite:$(shell cat VERSION)"

clean:
	sudo rm -rf vols/hostkeys
