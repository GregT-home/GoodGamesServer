desc "Create/update tags file for Emacs"
task :tags do
  # creates a TAGS file in the top level directory
  sh "ripper-tags --tag-file TAGS -R ."
end

