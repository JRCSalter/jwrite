# This logs any necessary output.
# Will also output to terminal if --debug is selected
# If $output_file is used, then this will output the entire contents of that file

JLog()
{
  message="$1"
  output_file="$2"

  [[ "$debug" = "y" ]] && echo -e "$message"
  [[ "$debug" = "y" && "$output_file" != "" ]] && cat "$output_file"
  if [[ "$LOG_ENABLED" = true ]]
  then
    echo -e "  $message" >> "$LOG_FILE"
    if [[ "$output_file" != "" ]]; then cat "$output_file" >> "$LOG_FILE"; fi
  fi
}
