while read -r FILE; do
  NEW_FILE=${FILE#target/.prefix}
  [[ ${NEW_FILE} == /etc* ]] || NEW_FILE=/usr${NEW_FILE}

  NEW_DIR=$(dirname "${NEW_FILE}")
  [[ -d ${NEW_DIR} ]] || sudo mkdir -p "${NEW_DIR}"

  echo "Creating '${NEW_FILE}'"
  #sudo cp "${FILE}" "${NEW_FILE}"
done < <(command find target/.prefix -type f)
