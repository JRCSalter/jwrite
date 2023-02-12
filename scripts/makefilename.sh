# Sanitizes a string to include all lower case, no spaces, and only alphanumeric characters

MakeFileName()
{
  name="$1"

  name_formatted=`echo "${name,,}"`
  name_formatted=`echo "${name_formatted//[^[:alnum:]]/_}"`

  file_name="$name_formatted"
}

