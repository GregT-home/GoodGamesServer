desc "Delete any temporary files (Emacs *~ files, in particular)"
task :clean do
  sh 'find . -name "*~" -exec rm -v {} \;'
  sh 'find . -name "*pagedump.html*" -exec rm -v {} \;'  
end

