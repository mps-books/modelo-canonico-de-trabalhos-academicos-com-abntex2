#!/usr/bin/env bash
name="moisespsena/md2latex"
script=`pwd`"/$0"
wd=`dirname $(dirname "$script")`
dist="$wd/dist"

case "$1" in
make-tex)
  md2latex --config "$wd/src/.md2latex.yaml" -w "$wd"
  exit $?
  ;;

build)
  rm -rf "$dist/*"
  (
    cd "$wd/latex" || exit $?
    find . -type d | \
    while read d; do
      [ ! -d "$dist/latex/$d" ] && {
        mkdir -pv "$dist/latex/$d" || exit $?
      }
    done
  )

  export UID=$(id -u)
  export GID=$(id -g)

  md2latex --config "$wd/src/.md2latex.yaml" -w "$wd" && \
  docker run -i --rm \
    --user $UID:$GID \
    -v "$wd":/usr/src/app \
    -w /usr/src/app texlive \
    xelatex \
    -synctex=1 \
    -interaction=nonstopmode \
    -output-directory=dist \
    -jobname=main \
    latex/main.tex

  exit $?
  ;;

texlive)
  shift
  # -e TZ=$(cat /etc/timezone)
  case "$1" in
  build)
    cd "$wd/.texlive"
    docker build -t texlive .
    ;;

  *)
    echo "ERROR: invalid command 'texlive $1'" >&2
    exit 1
    ;;

  esac

  ;;

*)
  echo "ERROR: invalid command 'texlive $1'" >&2
  exit 1
  ;;

esac