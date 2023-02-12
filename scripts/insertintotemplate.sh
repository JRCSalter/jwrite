# Takes input and inserts it into a template
# Also replaces placeholders

InsertIntoTemplate()
{
  template="$1"
  text_file="$2"

  cp $v "$template"                            "temp"
  sed -i "s/\[BOOKTITLE\]/$BOOK_TITLE/g"       "temp"
  sed -i "s/\[PARTTITLE\]/$PART_TITLE/g"       "temp"
  sed -i "s/\[CHAPTERTITLE\]/$CHAPTER_TITLE/g" "temp"
  sed -i "s/\[AUTHOR\]/$AUTHOR/g"              "temp"
  sed -i "s/\[PUBDATE\]/$PUB_DATE/g"           "temp"
  sed -i "s/\[LANG\]/$LANG/g"                  "temp"
  sed -i "s/\[COUNTER\]/$counter/g"            "temp"
  sed -i "s/\[FILE\]/$f.xhtml/g"               "temp"
  sed -i -e "/\[TEXT\]/{r $text_file" -e "d}"  "temp"
  mv $v "temp" "$text_file"
}

