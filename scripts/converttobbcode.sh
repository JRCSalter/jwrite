ConvertToBBCode()
{
  file=$1
  
  [[ "$verbose" = "y" ]] && echo "Converting $file to BBCode..."
  sed -i 's/\[em\]/\[i\]/g'       "$file"
  sed -i 's/\[\/em\]/\[\/i\]/g'   "$file"
  sed -i 's/\[wbr\]//g'           "$file"
  sed -i 's/\[cite\]/\[i\]/g'     "$file"
  sed -i 's/\[\/cite\]/\[\/i\]/g' "$file"
  sed -i 's/\[dfn\]/\[i\]/g'      "$file"
  sed -i 's/\[\/dfn\]/\[\/i\]/g'  "$file"
  sed -i 's/``/“/g'               "$file"
  sed -i 's/`/‘/g'                "$file"
  sed -i "s/''/”/g"               "$file"
  sed -i "s/'/’/g"                "$file"
  sed -i 's/---/​—​/g'  "$file"
  sed -i 's/--/​–​/g'   "$file"
  sed -i 's/\[el\]/\. \. \./g'    "$file"
  sed -i 's/\[a:"/\[url:/g'       "$file"
  sed -i 's/\[\/a\]/\[\/url\]/g'  "$file"
  sed -i 's/\[img:"/Image: \[/g'  "$file"
  sed -i 's/\[\/img\]//g'         "$file"
  sed -i 's/"\]/\]/g'             "$file"
  [[ "$verbose" = "y" ]] && echo "$file converted to BBCode."
}
