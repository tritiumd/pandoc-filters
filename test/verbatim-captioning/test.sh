cp ../../verbatim-captioning.lua ./
docker run --rm --user `id -u`:`id -g` -v .:/workspace \
  ngocptblaplafla/pandoc-texlive-full:latest --defaults example main.md
