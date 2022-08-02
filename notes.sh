set -e

SEMESTER=1

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
	grep -s -a -H "> Date: " *.txt 2>/dev/null | \
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

makepdf() {
	pandoc --pdf-engine=lualatex -H $NOTES_DIR/fonts.tex --toc \
		-o "${1}.pdf" $NOTES_DIR/about.md $2 &&
		echo "	Created ${1}.pdf"
}

makehtml() {
	# pandoc -w slidy -H $NOTES_DIR/slidy.html -s $2 </dev/null 2>/dev/null | \
		# sed -e 's/<h[2-9]/<\/div><div class=\"slide\">&/' \
		# -e 's/slidy.js.gz/slidy.js/' > "${1}.html" &&
		# echo "Created ${1}.html"

	pandoc -w slidy -H $NOTES_DIR/slidy.html --metadata title=$(basename "$module") -s -o "${1}.html" $2 </dev/null &&
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

			makepdf "$output_file" "$notes"
			makehtml "$output_file" "$notes"

			IFS=$oldifs

			unset notes output_file oldifs
			cd - &>/dev/null
		done
		cd "$semester"
		mgs -sDEVICE=pdfwrite \
			-dQUIET \
			-o "$(basename "$semester").pdf" \
			*/*.pdf &&
			echo "Created ${semester}.pdf"
		cd - &>/dev/null
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
