#
# Make targets for building and serving a demo/test version of the site
#

CONTAINER_NAME = cloudcompare-jekyll
JEKYLL_IMAGE = docker.io/jekyll/jekyll
JEKYLL_VERSION = 4
DOCKER = docker
DOCKER_PLATFORM = linux/amd64
SITE_ROOT = $(CURDIR)
JEKYLL_TAG = $(JEKYLL_IMAGE):$(JEKYLL_VERSION)
BUNDLE_ROOT = $(SITE_ROOT)/.bundle
BUNDLE_VENDOR = $(BUNDLE_ROOT)/vendor
BUNDLE_CACHE = $(BUNDLE_ROOT)/cache

.DEFAULT_GOAL := build

.PHONY: all build serve clean all_clean

all: build

build:
	mkdir -p "$(BUNDLE_VENDOR)" "$(BUNDLE_CACHE)"
	$(DOCKER) run --rm --name $(CONTAINER_NAME) \
		--platform $(DOCKER_PLATFORM) \
		--volume="$(SITE_ROOT):/srv/jekyll" \
		--volume="$(BUNDLE_ROOT):/bundle" \
		-e BUNDLE_PATH=/bundle/vendor \
		-e BUNDLE_USER_CACHE=/bundle/cache \
		$(JEKYLL_TAG) sh -lc 'bundle install && bundle exec jekyll build'

serve:
	mkdir -p "$(BUNDLE_VENDOR)" "$(BUNDLE_CACHE)"
	$(DOCKER) run --rm --name $(CONTAINER_NAME) \
		--platform $(DOCKER_PLATFORM) \
		--volume="$(SITE_ROOT):/srv/jekyll" \
		--volume="$(BUNDLE_ROOT):/bundle" \
		-e BUNDLE_PATH=/bundle/vendor \
		-e BUNDLE_USER_CACHE=/bundle/cache \
		-p 4000:4000 -it $(JEKYLL_TAG) sh -lc 'bundle install && bundle exec jekyll serve --watch --drafts'

clean:
	rm -rf _site

all_clean: clean
	-$(DOCKER) rm $(CONTAINER_NAME) 
	-$(DOCKER) rmi $(JEKYLL_TAG)
