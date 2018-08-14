
SOURCE_DIR=`pwd`/src
SYNC_DIR=`pwd`/docs

oPWD=`pwd`
cd ${SOURCE_DIR}

for file in `find ${SOURCE_DIR} -mindepth 2 -name '*.odt'`; do
    filename=`basename $file`
    prefix=${filename/.odt}
    srcdir=`dirname $file`
    srcdir=`readlink -f $srcdir`
    syncdir=${SYNC_DIR}${srcdir/${SOURCE_DIR}}
    echo filename=$filename srcdir=$srcdir syncdir=$syncdir prefix=$prefix >&2
    (cd $srcdir; soffice --convert-to pdf $filename)

    srcpdf=${srcdir}/${prefix}.pdf

    oldpdf=`ls -1 $syncdir/${prefix}*.pdf`
    if [ -z "$oldpdf" ] ; then
        cp $srcpdf $syncdir/${prefix}.pdf
    else
        pdftotext $oldpdf
        pdftotext $srcpdf

        old_md5sum=`md5sum ${oldpdf/.pdf/.txt} | cut -d' ' -f1`
        src_md5sum=`md5sum ${srcpdf/.pdf/.txt} | cut -d' ' -f1`

        rm ${oldpdf/.pdf/.txt} ${srcpdf/.pdf/.txt}
        echo old_md5sum=$old_md5sum src_md5sum=$src_md5sum >&2

        if [ "$old_md5sum" != "$src_md5sum" ] ; then
            echo !!!!!!!!! oldpdf=$oldpdf newpdf=$syncdir/${prefix}.pdf
            cp $srcpdf $syncdir/${prefix}.pdf
        fi

        rm $srcpdf
    fi
done

cd $oPWD
