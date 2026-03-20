#
# Make targets for building and serving a demo/test version of the site
#

CONTAINER_NAME = cloudcompare-jekyll
JEKYLL_IMAGE = docker.io/jekyll/jekyll
JEKYLL_VERSION = 4
DOCKER = docker
SITE_ROOT = $(CURDIR)
JEKYLL_TAG = $(JEKYLL_IMAGE):$(JEKYLL_VERSION)

.DEFAULT_GOAL := build

.PHONY: all build serve clean all_clean

all: build

build:
	$(DOCKER) run --rm --name $(CONTAINER_NAME) --volume="$(SITE_ROOT):/srv/jekyll" $(JEKYLL_TAG) jekyll build

serve:
	$(DOCKER) run --rm --name $(CONTAINER_NAME) --volume="$(SITE_ROOT):/srv/jekyll" -p 4000:4000 -it $(JEKYLL_TAG) jekyll serve --watch --drafts

clean:
	rm -rf _site

all_clean: clean
	-$(DOCKER) rm $(CONTAINER_NAME) 
	-$(DOCKER) rmi $(JEKYLL_TAG)
