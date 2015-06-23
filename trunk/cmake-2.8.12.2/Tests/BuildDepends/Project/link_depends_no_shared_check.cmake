if(NOT EXISTS "${lib}" OR NOT EXISTS "${exe}")
  file(REMOVE "${out}")
elseif("${exe}" IS_NEWER_THAN "${lib}")
  file(WRITE "${out}" "1\n")
else()
  file(WRITE "${out}" "0\n")
endif()
