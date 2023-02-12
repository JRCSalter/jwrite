ConvertToTex()
{
  file=$1
  
  [[ "$verbose" = "y" ]] && echo "Converting $file to TeX..."
  sed -i 's/\\/\\\\/g'            "$file"
  sed -i 's/\[em\]/\\emph{/g'     "$file"
  sed -i 's/\[\/em\]/}/g'         "$file"
  sed -i 's/\[b\]/\\textbf{/g'    "$file"
  sed -i 's/\[\/b\]/}/g'          "$file"
  sed -i 's/\[i\]/\\textit{/g'    "$file"
  sed -i 's/\[\/i\]/}/g'          "$file"
  sed -i 's/\[u\]/\\underline{/g' "$file"
  sed -i 's/\[\/u\]/}/g'          "$file"
  
  # Requires the ulem package
  sed -i 's/\[s\]/\\sout{/g' "$file"
  sed -i 's/\[\/s\]/}/g'     "$file"
  
  sed -i 's/\[sub\]/\\textsubscript{/g'   "$file"
  sed -i 's/\[\/sub\]/}/g'                "$file"
  sed -i 's/\[sup\]/\\textsuperscript{/g' "$file"
  sed -i 's/\[\/sup\]/}/g'                "$file"
  sed -i 's/\[center\]/\\begin{center}/g' "$file"
  sed -i 's/\[\/center\]/\\end{center}/g' "$file"
  sed -i 's/\[ol\]/\\begin{enumerate}/g'  "$file"
  sed -i 's/\[\/ol\]/\\end{enumerate}/g'  "$file"
  sed -i 's/\[ul\]/\\begin{itemize}/g'    "$file"
  sed -i 's/\[\/ul\]/\\end{itemize}/g'    "$file"
  sed -i 's/\[li\]/\\item /g'             "$file"
  sed -i 's/\[\/li\]//g'                  "$file"
  sed -i 's/\[wbr\]//g'                   "$file"
  
  # Requires defining in preamble
  sed -i 's/\[cite\]/\\jcite{/g' "$file"
  sed -i 's/\[\/cite\]/}/g'      "$file"
  sed -i 's/\[dfn\]/\\jdfn{/g'   "$file"
  sed -i 's/\[\/dfn\]/}/g'       "$file"
  sed -i 's/\[img:"/\\jimg{/g'   "$file"
  sed -i 's/\[\/img\]/}/g'       "$file"
  
  # Requires thge hyperref package
  sed -i 's/\[a:"/\\href{/g' "$file"
  sed -i 's/"]/}{/g'         "$file"
  sed -i 's/\[\/a\]/}/g'     "$file"
  
  
  # The following replaces a normal space with a thin space
  sed -i "s/' '/' '/g" "$file"
  sed -i 's/` `/` `/g' "$file"
  
  sed -i 's/\[el\]/\\dots /g' "$file"
  sed -i 's/_/\\_/g'          "$file"
  sed -i 's/\&/\\\&/g'        "$file"
  sed -i 's/%/\\%/g'          "$file"
  [[ "$verbose" = "y" ]] && echo "$file converted to TeX..."
}
