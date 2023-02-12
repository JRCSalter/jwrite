# Compiles the input for TeX files

CompileTex()
{
  input="$1"
  output="$main_output/tex"
  mkdir $v -p "$output"

  # Sanitising input and output directories so we can compare them
  cd "$input";  input=`pwd  -P`; cd - > /dev/null
  cd "$output"; output=`pwd -P`; cd - > /dev/null

  JLog "\n\nCalling CompileTex\r
  input:  $input\r
  output: $output" ""

  CompileInput "ConvertToTex" "tex"

  # concatenate chapters in output directory

  for f in `ls -1 $output`
  do
    # We don't want to cat a file to itself
    [[ "$f" = "$formatted_title.tex" ]] && continue
    mv $v "$output/$f" "$output/$f.tex"
    echo "\input{$f}" >> "$output/$formatted_title.tex"
  done
  
  JLog "\n$formatted_title.tex:\n" "$output/$formatted_title.tex"
  [[ "$verbose" = "y" ]] && echo -e "$formatted_title.tex created"

  InsertIntoTemplate "$TEMPLATE_DIR/tex-book_template.tex" "$output/$formatted_title.tex"
  cp $v "$TEMPLATE_DIR/tex-preamble_template.tex" "$output/preamble.tex"
  JLog "\n$formatted_title.tex after template:\n" "$output/$formatted_title.tex"

  if [[ "$pdf" = "y" ]]
  then
    [[ "$verbose" = "y" ]] && echo -e "Creating PDF..."
    cd "$output"
    xelatex "$formatted_title.tex" $quiet
    xelatex "$formatted_title.tex" $quiet
    xelatex "$formatted_title.tex" $quiet
    cd - > /dev/null
    mkdir $v -p "$main_output/pdf"
    mv $v "$output/$formatted_title.pdf" "$main_output/pdf"
  fi

  [[ "$debug" = "y" ]] && ls -la "$output"
  JLog "End CompileTex\n\n" "$output/$formatted_title.tex"
}

