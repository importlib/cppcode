file(READ testfhello.txt IN)
message("${IN}")
if(IN MATCHES Hello AND IN MATCHES World)
  message("Passed")
else()
  message(FATAL_ERROR "Hello world not found")
endif()
file(WRITE testfhello2.txt ${IN})
