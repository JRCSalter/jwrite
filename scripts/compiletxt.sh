# Compiles the input for .txt files

CompileTxt()
{
  input="$1"
  output="$main_output/txt"
  mkdir $v -p "$output"

  # Sanitising input and output directories so we can compare them
  cd "$input";  input=`pwd  -P`; cd - > /dev/null
  cd "$output"; output=`pwd -P`; cd - > /dev/null

  JLog "\n\nCalling CompileTxt\r
  input:  $input\r
  output: $output" ""

  CompileInput "ConvertToTxt" "txt"

  # concatenate chapters in output directory
  [[ "$verbose" = "y" ]] && echo -e "Adding title to $formatted_title.txt."
  echo -e "$BOOK_TITLE\n\n\n" > "$output/$formatted_title.txt"
  [[ "$verbose" = "y" ]] && echo -e "$formatted_title.txt created."

  for f in `ls -1 "$output"`
  do
    # We don't want to cat a file to itself
    [[ "$f" = "$formatted_title.txt" ]] && continue

    mv $v "$output/$f" "$output/$f.txt"
  
    [[ "$verbose" = "y" ]] && echo "Adding $f.txt to $formatted_title.txt..."
    cat "$output/$f.txt" >> "$output/$formatted_title.txt"
    echo -e "\n\n" >> "$output/$formatted_title.txt"
    [[ "$verbose" = "y" ]] && echo "$f.txt added to $formatted_title.txt."
  done

  JLog "\n$formatted_title.txt:\n" "$output/$formatted_title.txt"
  JLog "\n$output:\n`ls -la \"$output\"`" ""
  JLog "End CompileTxt\n\n" "$output/$formatted_title.txt"
}

