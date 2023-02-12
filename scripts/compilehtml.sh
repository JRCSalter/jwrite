# Takes the HTML output, and compiles it into an .epub file

CompileEpub()
{
  epub_output="$main_output/epub/$formatted_title"
  mkdir $v -p "$epub_output"
  cp -r $v "$TEMPLATE_DIR/epub_folder_template/"* "$epub_output/"
  counter=0

  # Need to refresh the Metadata, as it may no longer be correct
  . "$input/.metadata"
  
  JLog "\n\nCalling CompileEpub\r
  epub_output: $epub_output\r
  counter:     $counter\n
  Contents:\r
  `ls -laR \"$epub_output\"`\n" ""

  [[ "$verbose" = "y" ]] && echo "\nCompiling Epub."

  for f in `ls -1 "$main_output/html"`
  do
    # We don't want to do anything with the compiled HTML file
    [[ "$f" = "$formatted_title" ]] && continue

    cp $v "$main_output/html/$f" "$epub_output/EPUB/xhtml/$f.xhtml"
    [[ "$verbose" = "y" ]] && echo "Adding $f.xhtml to template..."
    InsertIntoTemplate "$TEMPLATE_DIR/epub-chapter_template.xhtml" "$epub_output/EPUB/xhtml/$f.xhtml"
    [[ "$verbose" = "y" ]] && echo "$f.xhtml added to template."
    JLog "\n$epub_output/EPUB/xhtml/$f.xhtml:\n" "$epub_output/EPUB/xhtml/$f.xhtml"
    
    # As we are using the same template for each entry, we just need to specify that the CHAPTER_TITLE needs to hold the PART_TITLE instead.
    # There is a possibility we can change this later to have a more hierachically organised file, but for the moment, it works.
    [[ "$TYPE" = "part" ]] && CHAPTER_TITLE="$PART_TITLE"
    
    [[ "$verbose" = "y" ]] && echo "Adding auxilliary information to templates..."
    
    InsertIntoTemplate    "$TEMPLATE_DIR/epub-manifest_template.xhtml" "manifest_temp"
    JLog "manifest_temp:" "manifest_temp"
    cat "manifest_temp"   >> "manifest_temp_all"
    
    InsertIntoTemplate "$TEMPLATE_DIR/epub-nav_template.xhtml"      "nav_temp"
    JLog "nav_temp:"   "nav_temp"
    cat "nav_temp"      >> "nav_temp_all"
    
    InsertIntoTemplate "$TEMPLATE_DIR/epub-spine_template.xhtml"    "spine_temp"
    JLog "spine_temp:" "spine_temp"
    cat "spine_temp"   >> "spine_temp_all"
    
    InsertIntoTemplate "$TEMPLATE_DIR/epub-toc_template.xhtml"      "toc_temp"
    JLog "toc_temp:"   "toc_temp"
    cat "toc_temp"     >> "toc_temp_all"

    [[ "$verbose" = "y" ]] && echo "Auxilliary information added to templates."

    counter=$((counter + 1))

    # As the error keeps telling me, /.metadata doesn't exist because on the last file $NEXT=""
    [[ -f "$NEXT/.metadata" ]] && . "$NEXT/.metadata"
  done
  
  JLog "\nmanifest_temp_all:" "manifest_temp_all"
  JLog "\nnav_temp_all:"      "nav_temp_all"
  JLog "\nspine_temp_all:"    "spine_temp_all"
  JLog "\ntoc_temp_all:"      "toc_temp_all"

  # Add the compiled auxilliary files to their relevant templates
  sed -i -e "/\[MANIFEST\]/{r manifest_temp_all" -e "d}" "$epub_output/EPUB/package.opf"
  sed -i -e "/\[SPINE\]/{r spine_temp_all" -e "d}"       "$epub_output/EPUB/package.opf"
  sed -i -e "/\[TEXT\]/{r toc_temp_all" -e "d}"          "$epub_output/EPUB/toc.ncx"
  sed -i -e "/\[TEXT\]/{r nav_temp_all" -e "d}"          "$epub_output/EPUB/nav.xhtml"
  
  JLog "\npackage.opf" "$epub_output/EPUB/package.opf"
  JLog "\ntoc.ncx"     "$epub_output/EPUB/toc.ncx"
  JLog "\nnav.xhtml"   "$epub_output/EPUB/nav.xhtml"

  [[ "$verbose" = "y" ]] && echo "Removing temporary files..."
  rm $v manifest_temp* nav_temp* spine_temp* toc_temp*
  [[ "$verbose" = "y" ]] && echo "Temporary files removed."
  
  InsertIntoTemplate   "$epub_output/EPUB/package.opf" "package_temp"
  mv $v "package_temp" "$epub_output/EPUB/package.opf"
  InsertIntoTemplate   "$epub_output/EPUB/toc.ncx"     "toc_temp"
  mv $v "toc_temp"     "$epub_output/EPUB/toc.ncx"
  InsertIntoTemplate   "$epub_output/EPUB/nav.xhtml"   "nav_temp"
  mv $v "nav_temp"     "$epub_output/EPUB/nav.xhtml"

  JLog "\npackage.opf final" "$epub_output/EPUB/package.opf"
  JLog "\ntoc.ncx final"     "$epub_output/EPUB/toc.ncx"
  JLog "\nnav.xhtml final"   "$epub_output/EPUB/nav.xhtml"
  
  # Finally, compile the finished epub file
  [[ "$verbose" = "y" ]] && echo "Compressing epub file..."
  cd $epub_output
  zip $q $v -X "../$formatted_title.epub" "mimetype"
  zip $q $v -rX "../$formatted_title.epub" * -x "mimetype"
  cd - > /dev/null
  [[ "$verbose" = "y" ]] && echo "Epub file compressed."

  if [[ "$mobi" = "y" ]]
  then
    [[ "$verbose" = "y" ]] && echo "\n\nCreating mobi file..."
    mkdir $v "$main_output/mobi"
    cd "$epub_output"
    ebook-convert "../$formatted_title.epub" "../../mobi/$formatted_title.mobi"
    cd - > /dev/null
    JLog "\n$main_output/mobi:\n`ls -la \"$main_output/mobi/\"`" "" 
    [[ "$verbose" = "y" ]] && echo "mobi file created."
  fi
}

# Compiles the input for .html files

CompileHtml()
{
  input=$1
  output="$main_output/html"
  mkdir $v -p "$output"

  # Sanitising input and output directories so we can compare them
  cd "$input";  input=`pwd  -P`; cd - > /dev/null
  cd "$output"; output=`pwd -P`; cd - > /dev/null

  JLog "\n\nCalling CompileHtml\r
  input:  $input\r
  output: $output" ""

  CompileInput "ConvertToHTML" "html"

  # concatenate chapters in output directory
  [[ "$verbose" = "y" ]] && echo "Adding title to $formatted_title..."
  echo -e "<h1 class="book_title">$BOOK_TITLE</h1>\n\n\n" > "$output/$formatted_title"
  [[ "$verbose" = "y" ]] && echo "$formatted_title created."

  for f in `ls -1 "$output"`
  do
    # We don't want to cat a file to itself
    [[ "$f" = "$formatted_title" ]] && continue
  
    [[ "$verbose" = "y" ]] && echo "Adding $f to $formatted_title..."
    cat "$output/$f" >> "$output/$formatted_title"
    echo -e "\n\n  " >> "$output/$formatted_title"
    [[ "$verbose" = "y" ]] && echo "$f added to $formatted_title."
  done

  JLog "\n$output:\n`ls -la $output`\n" ""
  
  InsertIntoTemplate "$TEMPLATE_DIR/html-book_template.html" "$output/$formatted_title"

  if [[ "$epub" = "y" ]]
  then
    CompileEpub
  fi
  
  # Just adding the file extension
  for f in `ls -1 "$output"`
  do
    mv $v "$output/$f" "$output/$f.html"
  done

  JLog "\n$output:\n`ls -la \"$output\"`\n" ""

  JLog "\nEnd CompileHtml\n\n" "$output/$formatted_title.html"
}

