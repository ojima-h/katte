output :file do
  command do |node, &proc|
    out_file = File.join(app.config.result_root, node.name, app.env.to_hash['date'] + ".txt")
    err_file = File.join(app.config.log_root   , node.name, app.env.to_hash['date'] + ".txt")

    [out_file, err_file].each {|f| FileUtils.makedirs(File.dirname(f)) }

    File.open(out_file, 'w') {|out|
      File.open(err_file, 'a') {|err|
        proc.call out, err
      }
    }
  end
end
