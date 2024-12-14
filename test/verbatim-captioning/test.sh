cp ../../verbatim-captioning.lua ./
docker run --rm -v .:/workspace --user 0 ngocptblaplafla/pandoc-texlive-full:latest --defaults example main.md
