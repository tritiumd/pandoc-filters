redownload=false
function downloadFilterPandocExt() {
  REPO="https://raw.githubusercontent.com/pandoc-ext"
  EXT_NAME=$1
  EXT_VERSION=$2
  redownload=$3
  if [ ! -f ${EXT_NAME}.lua ] || [ $redownload = true ]
  then
      wget ${REPO}/${EXT_NAME}/${EXT_VERSION}/_extensions/${EXT_NAME}/${EXT_NAME}.lua -O ${EXT_NAME}.lua
  fi
}

# Install pandoc lua filter
downloadFilterPandocExt diagram v1.1.0 $redownload
downloadFilterPandocExt multibib dd7de577e8e9ebb58f13edc3f7615141552b02c5 $redownload
downloadFilterPandocExt multibib main $redownload

function downloadFilter() {
  REPO=$1
  EXT_NAME=$2
  EXT_VERSION=$3
  redownload=$4
  if [ ! -f ${EXT_NAME}.lua ] || [ $redownload = true ]
  then
      wget ${REPO}/${EXT_VERSION}/${EXT_NAME}/${EXT_NAME}.lua -O ${EXT_NAME}.lua
  fi
}

REPO="https://raw.githubusercontent.com/pandoc/lua-filters/"
downloadFilter $REPO include-code-files master $redownload
downloadFilter $REPO include-files master $redownload
downloadFilter $REPO abstract-to-meta master $redownload
downloadFilter $REPO author-info-blocks master $redownload

REPO="https://raw.githubusercontent.com/chrisaga/hk-pandoc-filters/main/"
downloadFilter $REPO tables-rules master $redownload
downloadFilter $REPO column-div master $redownload