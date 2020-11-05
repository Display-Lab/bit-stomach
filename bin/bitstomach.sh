#!/usr/bin/env bash

# Check if R is installed
command -v Rscript 1> /dev/null 2>&1 || \
  { echo >&2 "Rscript required but it's not installed.  Aborting."; exit 1; }

# Usage message
read -r -d '' USE_MSG <<'HEREDOC'
Usage:
  bitstomach.sh -h
  bitstomach.sh [options]
  bitstomach.sh [options] spek.json  

Bitstomach reads a spek from stdin or provided file path.  Unless output dir 
is specified, it prints updated spek to stdout.

Options:
  -h | --help   print help and exit
  -s | --spek   path to spek file (default to stdin)
  -d | --data   path to data file
  -a | --anno   path to annotations file
  --version     print package version
  --verbose     print logging output
HEREDOC

# Parse args
PARAMS=()
while (( "$#" )); do
  case "$1" in
    -h|--help)
      echo "${USE_MSG}"
      exit 0
      ;;
    -d|--data)
      DATA_FILE="'${2}'"
      shift 2
      ;;
    -a|--anno)
      ANNO_FILE="'${2}'"
      shift 2
      ;;
    -s|--spek)
      SPEK_FILE="'${2}'"
      shift 2
      ;;
    --verbose)
      VERBOSE_ARG="TRUE"
      echo "VERBOSE"
      shift 1
      ;;
    --version)
      VER_EXPR='cat(as.character(packageVersion("bitstomach")))'
      VER_STRING=$(Rscript --default-packages=utils -e "${VER_EXPR}")
      echo "bitstomach package version: ${VER_STRING}"
      exit 0
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      echo "Aborting: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS+=("${1}")
      shift
      ;;
  esac
done

if [[ -z $OUTPUT_DIR ]]; then
    OUTPUT_DIR="${PWD}"
fi

INPUT_ARGS="spek_path=${SPEK_FILE:-NULL}, data_path=${DATA_FILE:-NULL},\
  annotation_path=${ANNO_FILE:-NULL}, verbose=${VERBOSE_ARG:-FALSE}"

EXPR="bitstomach::main(${INPUT_ARGS})"
Rscript --default-packages=bitstomach -e "${EXPR}"
