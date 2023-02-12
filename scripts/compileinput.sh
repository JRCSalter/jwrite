# Takes the entire input directory and compiles it all

CompileInput()
{
  convert_function="$1"
  format="$2"

  count=0
  count=`printf "%04d" "$count"`;
  clean=`cat "$TEMPLATE_DIR/$format-spacer.$format" | wc -l`
  last=false

  JLog "\n\nCalling CompileInput:\r
  convert_function: $convert_function\r
  format:           $format\r
  count:            $count\r
  clean:            $clean\r
  last:             $last" ""

  . "$input/.metadata"

  while
    # Sanitise file paths to be absolute so we can compare them later
    cd "$LOCATION"; LOCATION=`pwd -P`; cd - > /dev/null

    if [[ "$NEXT" != "" ]]
    then
      cd "$NEXT"; NEXT=`pwd -P`; cd - > /dev/null
    elif [[ "$NEXT" = "" ]]
    then
      last=true
    fi

    # compile chapter at LOCATION into a single file
    file_name="$BOOK_TITLE"
    [[ "$verbose" = "y"    ]] && echo -e      "Retreiving titles..."
    [[ "$TYPE" = "part"    ]] && MakeFileName "$PART_TITLE"
    [[ "$TYPE" = "chapter" ]] && MakeFileName "$CHAPTER_TITLE"
    [[ "$verbose" = "y"    ]] && echo -e      "Titles retrieved."
    [[ "$verbose" = "y"    ]] && echo -e      "Formatting $LOCATION for $format..."
    
    FormatChapter "$convert_function"
    
    [[ "$verbose" = "y" ]] && echo -e "$LOCATION formatted for $format."

    JLog "\nIn Loop\r
    LOCATION:  $LOCATION\r
    NEXT:      $NEXT\r
    TYPE:      $TYPE\r
    last:      $last\r
    file_name: $file_name" ""

    # insert file into template.
    # Parts will not have a separator, but chapters do, and so we need to trim that off the bottom
    [[ "$verbose" = "y" ]] && echo "Inserting $count-$file_name into template..."

    if [[ "$TYPE" = "part" ]]
    then
      InsertIntoTemplate "assets/templates/$format-part_template.$format" "$output/$count-$file_name"
    elif [[ "$TYPE" = "chapter" ]];
    then
      JLog "\n$count-$file_name before template:\n" "$output/$count-$file_name"
      InsertIntoTemplate "assets/templates/$format-chapter_template.$format" "$output/$count-$file_name"
      JLog "\n$count-$file_name after template:\n" "$output/$count-$file_name"
      head -n -"$clean" "$output/$count-$file_name" >> "chapter_temp"
      JLog "\n$count-$file_name after clean:\n" "chapter_temp"
      mv $v "chapter_temp" "$output/$count-$file_name"
    fi

    [[ "$verbose" = "y" ]] && echo "$count-$file_name inserted into template."

    count=`printf "%04d" $((10#$count + 1))`
    
    # If $NEXT goes outside of the $input directory, then we want to stop.
    # This enables user to only compile part of a project
    if [[ `echo "$NEXT" | grep "$input"` = "" ]]; then break; fi

    if [[ -f "$NEXT/.metadata" ]]; then . "$NEXT/.metadata"; else $NEXT=""; fi

    JLog "\nEnding loop\r
    LOCATION: $LOCATION\r
    NEXT:     $NEXT\r" ""
  [[ "$last" = false ]]
  do :
  done

  JLog "\n$output:\n`ls -la \"$output\"`\n" ""
  JLog "End CompileInput\n\n" ""
}
