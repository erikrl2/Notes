set -e

usage() {
cat << EOF
USAGE:

	notes [semester|"all"] [module]

EXAMPLES:

	notes
		compiles notes for current semester

	notes all
		compiles all notes

	notes 1
		compiles notes for semster 1

	notes 1 example
		compiles notes for semster 1 module "example"

EOF
}

getnotes() {
	grep -s -a -H -m 1 "> Date: " *.txt | \
		while read line; do
			file=$(echo "$line" | sed 's/\([^:]*\):>.*$/\1/')
			date=$(echo "$line" | sed 's/[^:]*:> Date: \(.*$\)/\1/')
			echo "$module$date $file"
		done | \
		sort -n | \
		while read line; do
			file=$(echo "$line" | sed 's/[^ ]* \(.*\)/\1/')
			echo "$file"
		done
	unset course file date
}

makehtml() {
	pandoc --template=$NOTES_DIR/theme/template.html \
		-c $NOTES_DIR/theme/css/theme.css -c $NOTES_DIR/theme/css/skylighting-paper-theme.css \
		--katex --toc --toc-depth=1 -M title=$(basename "$module") \
		-s -o "${1}.html" $NOTES_DIR/metadata.md $2 </dev/null &&
		echo "	Created ${1}.html"
}

makenotes() {
	for semester in $NOTES_DIR/sem$1; do
		for module in $semester/$2; do
			if [[ -f $module ]]; then continue; fi
			cd "$module"
			notes=$(getnotes)
			output_file="$module/"$(basename "$module")

			oldifs=$IFS
			IFS=$'\n'

			makehtml "$output_file" "$notes"

			IFS=$oldifs

			unset notes output_file oldifs
			cd - &>/dev/null
		done
	done
}

main() {
	case "$1" in
		"all") echo "Compiling all notes..." && makenotes "*" "*"; exit 0;;
		'') echo "Compiling sem${SEMESTER}..." && makenotes "$SEMESTER" "*"; exit 0;;
		[0-9]*)
			if [[ "$2" == "" ]]; then
				echo "Compiling sem${1}..."
				makenotes "$1" "*"
			elif [[ -d "$NOTES_DIR/sem$1/$2" ]]; then
				echo "Compiling sem$1/${2}..."
				makenotes "$1" "$2"
			else
				usage; exit 1
			fi
			exit 0;;
		*) usage; exit 1;;
	esac
}

main "$1" "$2"
