desc "Run spinach generate"
task :spin_gen do
  # i.e., spin_gen
  sh "spinach --generate"
end

desc "Run spinach on :target"
task :spin, [:target] do | task, args |
  # i.e., spin[welcome]
  sh "spinach -t #{args[:target]}"
end
