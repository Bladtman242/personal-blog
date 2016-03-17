.PHONY: sync all

.DEFAULT_GOAL := all

source_files=$(shell find source -type f -name '*.mkdn')

dest_files=$(patsubst source/%.mkdn,out/%.html, $(source_files))

all: $(dest_files)

out/%.html: source/%.mkdn pandoc.html.format
	pandoc -Ss --highlight-style zenburn -o $@ $< --template pandoc.html.format

sync: $(all)
	docker run -it -v $$PWD/out:/home/aws/out -v $$PWD/aws:/home/aws/.aws fstab/aws-cli bash -c "source /home/aws/aws/env/bin/activate; aws s3 sync out s3://www.howdoi.me --acl public-read"
