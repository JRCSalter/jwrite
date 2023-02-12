# Compiles the input for BBCode files

CompileBBCode()
{
  input="$1"
  output="$main_output/bbc"
  mkdir $v -p "$output"

  # Sanitising input and output directories so we can compare them
  cd "$input";  input=`pwd  -P`; cd - > /dev/null
  cd "$output"; output=`pwd -P`; cd - > /dev/null

  JLog "\n\nCalling CompileBbc\r
  input:  $input\r
  output: $output" ""

  CompileInput "ConvertToBBCode" "bbc"

  # concatenate chapters in output directory
  [[ "$verbose" = "y" ]] && echo "Adding title to $output/$formatted_title.bbc"
  echo -e "[h1]$BOOK_TITLE[/h1]\n\n\n" > "$output/$formatted_title.bbc"
  [[ "$verbose" = "y" ]] && echo "$formatted_title.bbc created"
  JLog "\n$formatted_title.bbc after creation:\n" "$output/$formatted_title.bbc"

  for f in `ls -1 "$output"`
  do
    # We don't want to cat a file to itself
    [[ "$f" = "$formatted_title.bbc" ]] && continue
    mv $v "$output/$f" "$output/$f.bbc"
  
    [[ "$verbose" = "y" ]] && echo "Adding $f.bbc to $formatted_title.bbc..."
    cat "$output/$f.bbc" >> "$output/$formatted_title.bbc"
    echo -e "\n\n" >> "$output/$formatted_title.bbc"
    [[ "$verbose" = "y" ]] && echo "$f.bbc added to $formatted_title.bbc.\n"
  done

  JLog "`ls -la \"$output\"`" ""
  JLog "End CompileBbc\n\n"   "$output/$formatted_title.bbc"
}

