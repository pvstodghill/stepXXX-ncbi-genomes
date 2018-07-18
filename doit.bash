#! /bin/bash

# ------------------------------------------------------------------------

# exit on error
set -e

if [ "$PVSE" ] ; then
    # In order to help test portability, I eliminate all of my
    # personalizations from the PATH.
    export PATH=/usr/local/bin:/usr/bin:/bin
fi

# ------------------------------------------------------------------------

# Check the config file

THIS_DIR=$(dirname $BASH_SOURCE)
CONFIG_SCRIPT=$THIS_DIR/config.bash
if [ ! -e "$CONFIG_SCRIPT" ] ; then
    echo 1>&2 Cannot find "$CONFIG_SCRIPT"
    exit 1
fi

# ------------------------------------------------------------------------
# The actual computation starts here
# ------------------------------------------------------------------------

# create empty `results` and `temp` directories

(
    set -x
    cd $THIS_DIR
    rm -rf results temp
    mkdir results temp
)

# # Download the taxonomy database
# (
#     set -x
#     for f in taxdump_readme.txt  taxdump.tar.gz ; do
# 	wget -Otemp/$f ftp://ftp.ncbi.nih.gov/pub/taxonomy/$f
#     done
#     mkdir temp/taxdump
#     tar -C temp/taxdump -z -x -f temp/taxdump.tar.gz
# )

# ------------------------------------------------------------------------

function ensure_repo_summary {
    case X"$1"X in
	XgenbankX) flag=-g ;;
	XrefseqX) flag=-r ;;
	*)
	    echo 1>&2 "Do not recognize repo name: $1"
	    exit 1
    esac
    if [ ! -e temp/$1.txt ] ; then
	(
	    set -x
	    ./scripts/ncbi-assembly-summary $flag > temp/$1.txt
	)
    fi
}

function get_assembly_files {
    repo=$1
    shift 1
    for a in "$@" ; do
	cat temp/$repo.txt \
	    | ./scripts/ncbi-assembly-grep $a \
	    | ./scripts/ncbi-assembly-fetch -A temp \
	    | bash
    done
}

function accession_path {
    echo $1 | sed -r -e 's|^(GC.)_(...)(...)(...)\.(.)$|\1/\2/\3\/\4/&_*|'
}

function download_genomes {
    DIR=results
    if [ "$1" = "-d" ] ; then
	if [ -z "$2" ] ; then
	    echo 1>&2 "Missing argument after -d"
	    exit 1
	fi
	DIR=results/$2
	shift 2
	rm -rf $DIR
	mkdir -p $DIR
    fi
    for a in "$@" ; do
	echo "# Downloading $a ($DIR)"
	case "$a" in
	    GCA_*) db=genbank ;;
	    GCF_*) db=refseq ;;
	    *) echo 1>&2 cannot happen
	esac
	ensure_repo_summary $db
	get_assembly_files $db $a
	echo "# Unpacking $a ($DIR)"
	asm_dir=`accession_path ${a}`
	ls temp/$asm_dir/*_genomic.fna.gz | fgrep -v _from_ | xargs gunzip -c > $DIR/$db.fna
	ls temp/$asm_dir/*_genomic.fna.gz | fgrep -v _from_ | xargs ./scripts/ncbi-split-fxa -d $DIR
	#ls temp/$asm_dir/*_protein.faa.gz | xargs ./scripts/ncbi-split-fxa -d $DIR
	ls temp/$asm_dir/*_protein.faa.gz | xargs gunzip -c > $DIR/$db.faa
	./scripts/ncbi-split-gff -d $DIR temp/$asm_dir/*.gff.gz
	gunzip -c temp/$asm_dir/*.gff.gz > $DIR/$db.gff
	./scripts/ncbi-split-gxff -d $DIR temp/$asm_dir/*.gbff.gz
    done
}

# ------------------------------------------------------------------------

. "$CONFIG_SCRIPT"

# ------------------------------------------------------------------------

