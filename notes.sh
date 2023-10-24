#!/usr/bin/env bash

set -e

usage() {
cat << EOF
USAGE:

	notes [semester|"all"|"index"] [module]

EXAMPLES:

	notes all
		compiles all notes and creates index

	notes index
		creates \$NOTES_DIR/index.html

	notes
		compiles notes for current semester

	notes 1
		compiles notes for semster 1

	notes 1 example
		compiles notes for semster 1 module "example"

EOF
}

make_index() {
	cd $NOTES_DIR
	echo -e "---\ndate: 'Last Update: "$(date "+%H:%M Uhr am %d.%m.%Y")"'\n---" > index.md
	semdirs=(sem*)
	for (( i=${#semdirs[@]}-1; i>=0; i-- )); do
		semester="${semdirs[$i]}"
		if ! [[ "$semester" =~ ^sem[0-9]+$ ]]; then continue; fi
		sem_no=$(echo "$semester" | sed 's/sem//')
		echo -e "\n# Semester $sem_no" >> index.md
		unset sem_no
		for module in "$semester"/*; do
			if ! [[ -d "$module" ]]; then continue; fi
			mod_name=$(basename "$module")
			mod_file="$semester/$mod_name/${mod_name}.html"
			if [[ -f "$mod_file" ]]; then
				echo "* ## [$mod_name]($mod_file)" >> index.md
			fi
			unset mod_name mod_file
		done
	done
	unset semdirs
	pandoc --template="theme/template.html" -c "theme/css/theme.css" \
		-M title="Notes" -s -o "index.html" "theme/metadata/index.md" "index.md" 2>/dev/null &&
		echo "Created $NOTES_DIR/index.html"
	rm "index.md" &>/dev/null
	cd - &>/dev/null
}

get_notes() {
	grep -s -H -m 1 "> Date: " *.md | \
		while read line; do
			file=$(echo "$line" | sed 's/\([^:]*\):>.*$/\1/')
			date=$(echo "$line" | sed 's/[^:]*:> Date: \(.*\)$/\1/')
			echo "$date $file"
		done | \
		sort -n | \
		while read line; do
			file=$(echo "$line" | sed 's/[^ ]* \(.*\)/\1/')
			echo "$file"
		done
	unset course file date
}

make_notes() {
	for semester in "$NOTES_DIR"/sem$1; do
		if ! [[ $(basename "$semester") =~ ^sem[0-9]+$ ]]; then continue; fi
		if [[ "$2" == "*" ]]; then modules=$(for f in "$semester"/*; do echo $f; done)
		else modules="$semester/$2"; fi
		oldifs=$IFS
		IFS=$'\n'
		for module in $modules; do
			if ! [[ -d "$module" ]]; then continue; fi
			cd "$module"
			notes=$(get_notes)
			output_file="$module/"$(basename "$module")".html"
			pandoc --template="../../theme/template.html" \
				-c "https://cdn.jsdelivr.net/gh/erikrl2/Notes/theme/css/theme.css" \
				-c "https://cdn.jsdelivr.net/gh/erikrl2/Notes/theme/css/skylighting-paper-theme.css" \
				--katex --toc --toc-depth=1 -M title=$(basename "$module") \
				-s -o "$output_file" "$NOTES_DIR/theme/metadata/notes.md" $notes &&
				echo "Created $output_file"
			unset notes output_file oldifs
			cd - &>/dev/null
		done
		IFS=$oldifs
	done
}

main() {
	case "$1" in
		"all") echo "Compiling all notes..." && \
			make_notes "*" "*"; exit 0;;
		"index") echo "Creating index..." && make_index; exit 0;;
		"") echo "Compiling semester ${SEMESTER}..." && make_notes "$SEMESTER" "*"; exit 0;;
		[0-9]*)
			if [[ "$2" == "" ]]; then
				echo "Compiling semster ${1}..."
				make_notes "$1" "*"
			elif [[ -d "$NOTES_DIR/sem$1/$2" ]]; then
				echo "Compiling semester $1 / ${2}..."
				make_notes "$1" "$2"
			else
				echo "Module $2 does not exist!"; exit 1
			fi
			exit 0;;
		*) usage; exit 1;;
	esac
}

main "$1" "$2"

