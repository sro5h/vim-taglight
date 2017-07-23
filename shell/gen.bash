#! /bin/bash
# gen.bash: Generate a set of vim commands to highlight a list of tags generated by
#   [exuberant ctags](ctags.sourceforge.com).
# Author: Paul Meffle

# Global variables
tagsFile="tags"
ctagsCommand="ctags -R -o-"
forceCtags=0
tagsList=""
typeList=""
cList=""
fList=""
sList=""
tList=""

showUsage() {
        echo "Usage:"
        echo "    gen.bash <options>"
        echo ""
        echo "    -c [cmd]: The ctags command to run"
        echo "    -d [dir]: The directory to search for the tags file"
        echo "    -f:       Force to invoke ctags even if a tag file exists"
}

# Parse arguments
while getopts "hfc:d:" opt; do
        case "${opt}" in
                h)
                        showUsage
                        exit 0
                        ;;
                f)
                        forceCtags=1
                        ;;
                c)
                        ctagsCommand="${OPTARG}"
                        ;;
                d)
                        workingDirectory="${OPTARG}"
                        tagsFile="${workingDirectory}/${tagsFile}"
                        ;;
                :|?)
                        exit 1
                        ;;
        esac
done

# Use an existing tags file if found and forcing is disabled, otherwise invoke
# ctags.
if [ ${forceCtags} == 0 ] && [ -f ${tagsFile} ]; then
        tagsList=$(cat ${tagsFile})
else
        tagsList=$(${ctagsCommand})
fi

# Convert the ctags output into a list only containing the the tag kind and
# keyword. The type list has the following form where each line is separated by
# a newline character:
#   type1,kind1
#   type2,kind2
typeList="$(echo -n "${tagsList}" | awk -F "\t" '/^!/ {next} /^operator/ {next} {printf("%s,%s\n", $1, $4)}')"

# Determine the highlight group for each line using the language specific ctags
# 'kind' (ctags --list-kinds). The definition of each 'kind' is language specific
# although most languages follow the definitions of the c language:
#   c - classes
#   f - functions
#   s - structs
#   t - typedefs
while read -r line; do
        tagKeyword="${line%,*}"
        tagKind="${line#*,}"
        highlightGroup=""

        case "${tagKind}" in
                "c")
                        highlightGroup="Identifier"
                        cList="${cList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
                "f")
                        highlightGroup="Function"
                        fList="${fList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
                "s")
                        highlightGroup="Identifier"
                        sList="${sList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
                "t")
                        highlightGroup="Identifier"
                        tList="${tList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
                *)
                        highlightGroup="";;
        esac
done <<< "${typeList}"

# Output the vim syntax commands in the correct order to avoid e.g. a
# constructor overriding the class highlight.
echo "${fList}${tList}${sList}${cList}"
