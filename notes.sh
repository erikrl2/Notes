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
		--katex --toc --toc-depth=1 -M title="$mod_name" \
		-s -o "$1" "$NOTES_DIR/metadata.md" $2 &&
		echo "	Created $1"
}

makehtml_index() {
	pandoc --template=$NOTES_DIR/theme/template.html \
		-c $NOTES_DIR/theme/css/theme.css -c $NOTES_DIR/theme/css/skylighting-paper-theme.css \
		-M title="$3" -s -o "$1" "$2" 2>/dev/null &&
		echo "	Created $1"
}

makenotes() {
	echo -n "" > "$NOTES_DIR/index.md"
	for semester in $NOTES_DIR/sem$1; do
		echo -n "" > "$semester/index.md"
		for module in $semester/$2; do
			if [[ -f $module ]]; then continue; fi
			cd "$module"
			notes=$(getnotes)
			mod_name=$(basename "$module")
			output_file="$module/${mod_name}.html"

			oldifs=$IFS
			IFS=$'\n'

			makehtml "$output_file" "$notes"

			IFS=$oldifs

			echo "* ## [$mod_name]($mod_name/${mod_name}.html)" >> "$semester/index.md"

			unset notes mod_name output_file oldifs
			cd - &>/dev/null
		done
		echo "<br/>[_← Go Back_](../index.html)" >> "$semester/index.md"
		makehtml_index "$semester/index.html" "$semester/index.md" "Semester $1 Modules"
		rm "$semester/index.md" &>/dev/null

		echo "* # [Semester $1](sem$1/index.html)" >> "$NOTES_DIR/index.md"
	done
	makehtml_index "$NOTES_DIR/index.html" "$NOTES_DIR/index.md"
	rm "$NOTES_DIR/index.md" &>/dev/null
}

main() {
	case "$1" in
		"") echo "Compiling semester ${SEMESTER}..." && makenotes "$SEMESTER" "*"; exit 0;;
		"all") echo "Compiling all notes..." && makenotes "*" "*"; exit 0;;
		[0-9]*)
			if [[ "$2" == "" ]]; then
				echo "Compiling semster ${1}..."
				makenotes "$1" "*"
			elif [[ -d "$NOTES_DIR/sem$1/$2" ]]; then
				echo "Compiling semester $1 / module ${2}..."
				makenotes "$1" "$2"
			else
				echo "Module $2 does not exist!"; exit 1
			fi
			exit 0;;
		*) usage; exit 1;;
	esac
}

main "$1" "$2"
