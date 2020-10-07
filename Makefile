#
##
NOCLR=\x1b[0m
OKCLR=\x1b[32;01m
ERRCLR=\x1b[31;01m
WARNCLR=\x1b[33;01m
EXECUTABLES=docker

define usage =
Build and development task automation tool

Usage:
  make [task]
endef

## Built in tasks ##

#: help - Show targets info
help:
	$(info $(usage))
	@echo -e "\n  Available targets:"
	@egrep -o "^#: (.+)" [Mm]akefile  | sed 's/#: /    /'

#: check - Check that system requirements are met
check:
	$(info Required programs:)
	$(foreach bin,$(EXECUTABLES),\
	    $(if $(shell command -v $(bin) 2> /dev/null),$(info Found `$(bin)`),$(error Please install `$(bin)`)))

#: build - build image
build:
	docker build . -t zentekmx/freeradius -t zentekmx/freeradius:latest -t zentekmx/freeradius:1.0

#: start - Start containers
start:
	docker-compose up -d

#: push - Push to docker hub
push: build
	docker push zentekmx/freeradius

.PHONY: help
.DEFAULT_GOAL := help
