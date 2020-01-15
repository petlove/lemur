# frozen_string_literal: true

require 'yaml'

BASE_FILE_PATH_HEADER = '# base:'
CF_FILE_PATH_HEADER = '# file:'

namespace :lemur do
  desc 'Build environments for codefresh'
  task :build_envs do
    beautify_envs(env_paths)
    update_envs(env_paths)
  end
end

def update_envs(envs)
  envs.each do |path|
    cf_file_paths = []
    envs = []
    base_file_paths = []

    handle_file(path, envs, cf_file_paths, base_file_paths)
    next if cf_file_paths.empty?

    envs = pick_final_envs(handle_base_envs(envs, base_file_paths), envs)
    next if envs.empty?

    cf_file_paths.each do |cf_file_path|
      File.read(cf_file_path)
          .then { |content| YAML.safe_load(content) }
          .then { |yml| File.open(cf_file_path, 'w') { |file| file.write(build_new_yml(yml, envs)) } }
    end
  end
end

def handle_base_envs(_envs, base_file_paths)
  base_file_paths.each_with_object([]) do |base_path, obj|
    base_envs = []
    handle_file(base_path, base_envs, [], [])
    pick_final_envs(obj, base_envs).each { |picked| obj << picked }
  end
end

def pick_final_envs(obj, envs)
  sobj = obj.map { |e| e.split('=', 2) }
  senvs = envs.map { |e| e.split('=', 2) }

  (sobj.map { |s| s[0] } & senvs.map { |s| s[0] })
    .map { |o| senvs.find { |e| e[0] == o } || sobj.find { |e| e[0] == o } }
    .compact
    .map { |o| o.join('=') }
    .sort
end

def beautify_envs(envs)
  envs.each do |path|
    cf_file_paths = []
    envs = []
    base_file_paths = []
    original_envs = []

    handle_file(path, envs, cf_file_paths, base_file_paths, original_envs)
    beautify(path, cf_file_paths, base_file_paths, original_envs)
  end
end

def beautify(env_path, cf_file_paths, base_file_paths, original_envs)
  File.open(env_path, 'w') do |file|
    base_file_paths.each { |l| file.puts "#{BASE_FILE_PATH_HEADER}#{l}" }
    cf_file_paths.each { |l| file.puts "#{CF_FILE_PATH_HEADER}#{l}" }
    file.puts '' unless (base_file_paths + cf_file_paths).empty?

    original_envs.sort.each { |l| file.puts l }
  end
end

def handle_file(env_path, envs, cf_file_paths, base_file_paths, original_envs = [])
  File.foreach(env_path) do |env_file_line|
    env_file_line.chomp!
    cf_file_path_by_line(env_file_line).then { |file| cf_file_paths << file if file }
    base_file_path_by_line(env_file_line).then { |file| base_file_paths << file if file }
    env_formatter(env_file_line).then do |env|
      if env
        envs << env if env
        original_envs << env_file_line
      end
    end
  end
end

def build_new_yml(yml, envs)
  yml.tap { yml['spec']['template']['spec']['containers'][0]['env'] = codefresh_envs(envs) }.to_yaml
end

def codefresh_envs(envs)
  envs.map { |env| codefresh_env(*env.split('=')) }.compact
end

def codefresh_env(name, value)
  return unless name && value

  { 'name' => name }.merge(handle_value(value))
end

def handle_value(value)
  JSON.parse(value).then { |result| result.is_a?(Numeric) ? { 'value' => value } : result }
rescue StandardError
  { 'value' => value }
end

def env_paths
  Dir.children('.').grep(/.env.lemur/)
end

def envs_by_file(env_path, cf_file_path, envs)
  File.foreach(env_path) do |env_file_line|
    env_file_line.chomp!
    cf_file_path = cf_file_path_by_line(cf_file_path, env_file_line)
    env_formatter(env_file_line).then { |env| envs << env if env }
  end
end

def cf_file_path_by_line(line)
  line.split(CF_FILE_PATH_HEADER)[1] if line.include?(CF_FILE_PATH_HEADER)
end

def base_file_path_by_line(line)
  line.split(BASE_FILE_PATH_HEADER)[1] if line.include?(BASE_FILE_PATH_HEADER)
end

def env_formatter(line)
  return if line.include?(CF_FILE_PATH_HEADER)
  return unless line.include?('=')

  line.strip
end
