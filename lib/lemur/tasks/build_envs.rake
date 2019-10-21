# frozen_string_literal: true

require 'yaml'

CF_FILE_PATH_HEADER = '# file:'

namespace :lemur do
  desc 'Build environments for codefresh'
  task :build_envs do
    env_paths.each do |env_path|
      cf_file_paths = []
      envs = []

      File.foreach(env_path) do |env_file_line|
        env_file_line.chomp!
        cf_file_path_by_line(env_file_line).then { |cf_file_path| cf_file_paths << cf_file_path if cf_file_path }
        env_formatter(env_file_line).then { |env| envs << env if env }
      end

      next if cf_file_paths.empty? || envs.empty?

      cf_file_paths.each do |cf_file_path|
        File.read(cf_file_path)
            .then { |content| YAML.safe_load(content) }
            .then { |yml| File.open(cf_file_path, 'w') { |file| file.write(build_new_yml(yml, envs)) } }
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

  { 'name' => name, 'value' => value }
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

def env_formatter(line)
  return if line.include?(CF_FILE_PATH_HEADER)
  return unless line.include?('=')

  line.strip
end
