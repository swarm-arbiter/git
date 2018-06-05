run:
	sudo docker run -it \
		-v "$(shell pwd)/vols/hostkeys:/etc/ssh/hostkeys" \
		-v "$(shell pwd)/vols/admin.pub:/home/git/admin.pub" \
		-v "$(shell pwd)/vols/repositories:/home/git/repositories" \
		"gitolite:$(shell cat VERSION)"

build:
	sudo docker build . -t "gitolite:$(shell cat VERSION)"

clean:
	sudo rm -rf vols/hostkeys
