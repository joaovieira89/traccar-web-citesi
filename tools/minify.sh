#!/bin/sh

# Sencha Variables
if [ -z "${SENCHAROOT}" ]
then
	SENCHAROOT="../../.."
fi

SDK="${SENCHAROOT}/ext-6.2.0"
CORE="${SDK}/packages/core"
CLASSIC="${SDK}/classic/classic"
CMDDIR="${SENCHAROOT}/Cmd"

if [ ${#} -gt 1 ]
then
	echo "usage: $(basename ${0}) [ <traccar-web directory> ]"
	exit 1
fi

if [ ${#} -eq 0 ]
then
	# Maintain default behavior where CWD is assumed to be traccar-web/tools.
	TRACCARWEB="$(dirname $0)/../web"
else
	TRACCARWEB="${1}"
fi

if [ ! -d "${TRACCARWEB}" ]
then
	echo "${TRACCARWEB}: directory not found" 1>&2
	exit 2
fi

INPUTFILE="${TRACCARWEB}/app.js"
OUTPUTFILE="${TRACCARWEB}/app.min.js"
APPDIR="${TRACCARWEB}/app"

# Assemble CLASSPATH
CLASSPATH="${INPUTFILE},${APPDIR}"

for d in "${CORE}" "${CLASSIC}"
do
	for e in "src" "overrides"
	do
		if [ ! -d "${d}/${e}" ]
		then
			echo "${d}/${e}: directory not found" 1>&2
			exit 2
		fi

		CLASSPATH="${CLASSPATH},${d}/${e}"
	done
done

# Minify
"${CMDDIR}/sencha" compile \
	--classpath="${CLASSPATH}" \
	exclude -all and \
	include -recursive -file "${INPUTFILE}" and \
	exclude -namespace=Ext and \
	concatenate -closure "${OUTPUTFILE}"

