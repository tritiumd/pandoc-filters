cp ../../pandoc-latex-env.lua ./
docker run --rm --user `id -u`:`id -g` -v .:/workspace \
  ngocptblaplafla/pandoc-texlive-full:latest main.md -o result.pdf \
  -L pandoc-latex-env.lua --pdf-engine xelatex --verbose
