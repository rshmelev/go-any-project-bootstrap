#!/bin/bash

function setupTheProject {
    # just in case you're using this only file without downloading the repo
    go get github.com/rshmelev/go-any-project-bootstrap/launcher

    SRC="${GOPATH}/src/github.com/rshmelev/go-any-project-bootstrap/"
    DST=`pwd -P`

    carefulcp ${SRC}/Makefile ${DST}/Makefile
    carefulcp ${SRC}/Vagrantfile ${DST}/Vagrantfile

    mkdir -p ${DST}/code
    [ ! -f "${DST}/code/main.go" ] && cat <<EOT > ${DST}/code/main.go
package code

// BuildVars are configured from outside, mostly used to get build-time data
var BuildVars = map[string]string{
	"DebugMode": debugMode(),
}

// Main func is real entry point
func Main() int {
	print("hello world!")
	return 0
}
EOT

    [ ! -f "${DST}/code/debug.go" ] && cat <<EOT > ${DST}/code/debug.go
package code

// any dirty hacks should be placed in this file
// dont forget to adjust isForProduction func

// isForProduction may be used by your app to ensure it is compiled without debug things
func isForProduction() bool {
	return false
}

// debugMode is used in main.go to fill BuildVars during app initialization process
func debugMode() string {
	if isForProduction() {
		return "false"
	}
	return "SOME CONSTANTS HAVE UNUSUAL VALUES"
}
EOT


    if [ -f "${DST}/build.sh" ] ; then
        read -p "Update build.sh (default=no)? " updatebuildsh
        if [ "$updatebuildsh" == "y" ] || [ "$updatebuildsh" == "yes" ] ; then
            BUILD_OPTION=just-gather-project-details
            . ${DST}/build.sh
            echo "updating build.sh ..."
            doupdatebuildsh
        fi
    else
        defaultappname=`basename ${DST}` && defaultappname=${defaultappname#go-*}
        read -p "App name (default='"${defaultappname}"'): " APPNAME
        [ -z "$APPNAME" ] && APPNAME=default
        read -p "Author long (e.g. John Doe and mycompany.com): " AUTHOR_LONG
        read -p "Author short (e.g. mycompany or even mc): " AUTHOR_SHORT
        read -p "Site (e.g. mycompany.com): " SITEURL
        [ -z "${SITEURL}" ] || SITEURL="http://${SITEURL}"

        DEFAULT_OSARCH="linux/amd64"
        TRIM_GO_PREFIX=true
        AUTHOR_PREFIX="${AUTHOR_SHORT}-"
        FILENAME_SUFFIX="-{{.OS}}"

        doupdatebuildsh
    fi

    echo ""
    echo "let's try to build something... "
    cd ${DST} && chmod +x build.sh && make
}

function carefulcp {
    if [ -f $2 ]; then
        if diff $1 $2 2>&1 >/dev/null ; then
            echo "file "`basename $1`" wasn't modified"
        else
            cp -i $1 $2
        fi
    else
        cp -i $1 $2
    fi
}

function sedeasy {
  sed -i .bak "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}

function doupdatebuildsh {
    cp ${SRC}/build.sh ${DST}

    sedeasy 'DEFAULT_OSARCH="linux\\/amd64"' "DEFAULT_OSARCH=\"${DEFAULT_OSARCH}\"" ${DST}/build.sh
    sedeasy 'TRIM_GO_PREFIX=true' "TRIM_GO_PREFIX=${TRIM_GO_PREFIX}" ${DST}/build.sh
    sedeasy 'AUTHOR_PREFIX="${AUTHOR_SHORT}-"' "AUTHOR_PREFIX=\"${AUTHOR_PREFIX}\"" ${DST}/build.sh
    sedeasy 'FILENAME_SUFFIX="-{{.OS}}"' "FILENAME_SUFFIX=\"${FILENAME_SUFFIX}\"" ${DST}/build.sh

    sedeasy 'APPNAME="default"' "APPNAME=\"${APPNAME}\"" ${DST}/build.sh
    sedeasy '_________AUTHORLONG__________' "${AUTHOR_LONG}" ${DST}/build.sh
    sedeasy '_________AUTHORSHORT__________' "${AUTHOR_SHORT}" ${DST}/build.sh
    sedeasy '_________SITE__________' "${SITEURL}" ${DST}/build.sh
    rm ${DST}/build.sh.bak
}

setupTheProject