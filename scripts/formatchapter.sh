# Takes a single directory, and compiles all the text files in that directory

FormatChapter()
{
  convert_function="$1"

  JLog "\n\nCalling FormatChapter\r
  convert_function: $convert_function" ""

  # for each file in directory (ignore any child directories),
  for f in `ls -1 "$LOCATION"`
  do
    inputf="$LOCATION/$f"
    JLog "\ninputf: $inputf" ""
    
    # We don't want to do anything with directories
    [[ -d "$inputf" ]] && continue

    [[ "$verbose" = "y" ]] && echo "Formatting $LOCATION/$f..."

    cp $v "$inputf" "temp"

    # run it through the format_script,
    $convert_function "temp"

    # then add to output file
    cat "temp" >> "$output/$count-$file_name"
    
    # add spacer
    [[ "$TYPE" != "part" ]] && echo -e "`cat \"$TEMPLATE_DIR/$format-spacer.$format\"`" >> "$output/$count-$file_name"
    
    rm $v "temp"
    [[ "$verbose" = "y" ]] && echo "$LOCATION/$f formatted."
  done

  JLog "End FormatChapter\n\n" "$output/$count-$file_name"
}

