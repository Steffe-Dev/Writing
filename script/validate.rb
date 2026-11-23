#!/usr/bin/env ruby
# frozen_string_literal: true

require "date"
require "pathname"
require "yaml"

ROOT = Pathname.new(__dir__).join("..").expand_path
FORMS = %w[short-story flash poem essay novel fragment song].freeze
STATUSES = %w[draft revising done shelved].freeze
RESERVED_SLUGS = %w[index readme].freeze
ALLOWED_KEYS = %w[title description form status completed languages tags published].freeze
KEBAB = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/.freeze
LOCALE = /\A[a-z]{2,3}(?:-[A-Z][a-z]{3})?(?:-[A-Z]{2})?\z/.freeze
PUBLISHED_LINE = /\Apublished:[ \t]*(true|false)[ \t]*(?:#.*)?\z/.freeze

def rel(path)
  path.relative_path_from(ROOT).to_s
end

def load_yaml(text)
  if YAML.method(:safe_load).parameters.any? { |kind, name| kind == :key && name == :permitted_classes }
    YAML.safe_load(text, permitted_classes: [Date], aliases: false)
  else
    YAML.safe_load(text, [Date], [], false)
  end
end

def read_text(path, errors)
  raw = File.binread(path)
  if raw.byteslice(0, 3) == "\xEF\xBB\xBF".b
    errors << "#{rel(path)}: file must not start with a byte order mark"
    return nil
  end

  text = raw.dup.force_encoding(Encoding::UTF_8)
  unless text.valid_encoding?
    errors << "#{rel(path)}: file must be valid UTF-8"
    return nil
  end

  text.gsub("\r\n", "\n").gsub("\r", "\n")
end

def visible_children(dir)
  Dir.children(dir).sort.reject { |name| name.start_with?(".") }.map { |name| dir.join(name) }
end

def extract_metadata(text)
  lines = text.split("\n", -1)
  return nil unless lines[0] == "---"

  closing = nil
  index = 1
  while index < lines.length
    if lines[index] == "---"
      closing = index
      break
    end
    index += 1
  end
  return nil if closing.nil?

  lines[1...closing].join("\n")
end

def check_line(path, errors, key, value, max)
  unless value.is_a?(String)
    errors << "#{path}: #{key} must be a non-empty single line of at most #{max} characters"
    return
  end
  if value.include?("\n")
    errors << "#{path}: #{key} must be a single line"
    return
  end

  stripped = value.strip
  errors << "#{path}: #{key} must not have surrounding whitespace" if value != stripped && !stripped.empty?
  return unless stripped.empty? || value.length > max

  errors << "#{path}: #{key} must be a non-empty single line of at most #{max} characters"
end

def check_date(path, errors, value)
  string = case value
           when Date
             value.strftime("%Y-%m-%d")
           when String
             value
           end
  parsed = Date.strptime(string, "%Y-%m-%d") if string.is_a?(String) && string.match?(/\A\d{4}-\d{2}-\d{2}\z/)
  return if parsed && parsed.strftime("%Y-%m-%d") == string

  errors << "#{path}: completed must be a YYYY-MM-DD date"
rescue ArgumentError
  errors << "#{path}: completed must be a YYYY-MM-DD date"
end

def check_languages(path, errors, value)
  unless value.is_a?(Array) && !value.empty?
    errors << "#{path}: languages must be a non-empty list of locale tags"
    return
  end

  seen = {}
  value.each do |tag|
    unless tag.is_a?(String) && tag.match?(LOCALE)
      errors << "#{path}: language #{tag.inspect} must look like en, zh-Hans, or en-ZA"
      next
    end
    errors << "#{path}: duplicate language #{tag.inspect}" if seen[tag]
    seen[tag] = true
  end
end

def check_tags(path, errors, value)
  unless value.is_a?(Array)
    errors << "#{path}: tags must be a list"
    return
  end

  seen = {}
  value.each do |tag|
    unless tag.is_a?(String) && tag.match?(KEBAB)
      errors << "#{path}: tag #{tag.inspect} must be kebab-case"
      next
    end
    errors << "#{path}: duplicate tag #{tag.inspect}" if seen[tag]
    seen[tag] = true
  end
end

def published_lines(yaml_text)
  yaml_text.lines.map(&:chomp).select { |line| line.match?(/\Apublished[ \t]*:/) }
end

def check_published(path, errors, yaml_text, data)
  lines = published_lines(yaml_text)
  if lines.length > 1
    errors << "#{path}: published must appear once"
    return nil
  end
  if lines.length == 1 && (match = lines[0].match(PUBLISHED_LINE))
    return match[1] == "true"
  end

  if !data.key?("published") || data["published"].nil?
    errors << "#{path}: published is required"
  else
    errors << "#{path}: published must be the boolean true or false"
  end
  nil
end

def check_metadata(path, errors, yaml_text, data)
  unless data.is_a?(Hash)
    errors << "#{path}: metadata must be a YAML mapping"
    return
  end

  data.each_key do |key|
    next if key.is_a?(String) && ALLOWED_KEYS.include?(key)

    errors << "#{path}: unknown key #{key.inspect}"
  end

  if !data.key?("title") || data["title"].nil?
    errors << "#{path}: title is required"
  else
    check_line(path, errors, "title", data["title"], 120)
  end

  published = check_published(path, errors, yaml_text, data)

  if published == true
    if !data.key?("description") || data["description"].nil?
      errors << "#{path}: description is required when published is true"
    else
      check_line(path, errors, "description", data["description"], 200)
    end
  elsif data.key?("description")
    if data["description"].nil?
      errors << "#{path}: description must be a non-empty single line of at most 200 characters"
    else
      check_line(path, errors, "description", data["description"], 200)
    end
  end

  if !data.key?("form") || data["form"].nil?
    errors << "#{path}: form is required"
  elsif !FORMS.include?(data["form"])
    errors << "#{path}: form must be one of #{FORMS.join(', ')}"
  end

  if !data.key?("status") || data["status"].nil?
    errors << "#{path}: status is required"
  elsif !STATUSES.include?(data["status"])
    errors << "#{path}: status must be one of #{STATUSES.join(', ')}"
  end

  if data["status"] == "done"
    if !data.key?("completed")
      errors << "#{path}: completed is required when status is done"
    else
      check_date(path, errors, data["completed"])
    end
  elsif data.key?("completed")
    errors << "#{path}: completed must be omitted unless status is done"
  end

  if !data.key?("languages") || data["languages"].nil?
    errors << "#{path}: languages must be a non-empty list of locale tags"
  else
    check_languages(path, errors, data["languages"])
  end

  check_tags(path, errors, data["tags"]) if data.key?("tags")
end

def validate_work_text(path, errors, text)
  yaml_text = extract_metadata(text)
  if yaml_text.nil?
    errors << "#{rel(path)}: a work must open with a metadata block"
    return
  end

  begin
    data = load_yaml(yaml_text)
  rescue Psych::Exception => e
    detail = e.message.to_s.lines.first.to_s.strip
    errors << "#{rel(path)}: metadata is not valid YAML (#{detail})"
    return
  end

  check_metadata(rel(path), errors, yaml_text, data)
end

def validate_work_file(path, errors)
  text = read_text(path, errors)
  validate_work_text(path, errors, text) if text
end

def validate_part(path, errors)
  text = read_text(path, errors)
  return if text.nil?
  return unless text[/\A[^\n]*/] == "---"

  errors << "#{rel(path)}: a part must not open with a metadata block"
end

def validate_slug(path, errors, slug)
  unless slug.match?(KEBAB)
    errors << "#{rel(path)}: work slug must be kebab-case"
    return
  end
  return unless RESERVED_SLUGS.include?(slug)

  errors << "#{rel(path)}: work slug must not be index or readme"
end

def validate_work_directory(dir, errors)
  index = nil
  visible_children(dir).each do |child|
    name = child.basename.to_s
    if child.directory?
      errors << "#{rel(child)}: a work directory must be flat"
    elsif child.file? && name == "index.md"
      index = child
    elsif child.file? && name.end_with?(".md")
      stem = name.chomp(".md")
      errors << "#{rel(child)}: part filename must be kebab-case" unless stem.match?(KEBAB)
      validate_part(child, errors)
    end
  end

  if index.nil?
    errors << "#{rel(dir)}: a multi-file work must contain index.md"
  else
    validate_work_file(index, errors)
  end
end

def validate_shelf_readme(path, errors)
  text = read_text(path, errors)
  return if text.nil?
  return unless text[/\A[^\n]*/] == "---"

  errors << "#{rel(path)}: a shelf README must not open with a metadata block"
end

def validate_shelf(dir, errors)
  file_slugs = {}
  dir_slugs = {}

  visible_children(dir).each do |child|
    name = child.basename.to_s
    if child.directory?
      slug = name
      validate_slug(child, errors, slug)
      validate_work_directory(child, errors)
      dir_slugs[slug] = child
    elsif child.file? && name == "README.md"
      validate_shelf_readme(child, errors)
    elsif child.file? && name.end_with?(".md")
      slug = name.chomp(".md")
      validate_slug(child, errors, slug)
      validate_work_file(child, errors)
      file_slugs[slug] = child
    elsif child.file?
      errors << "#{rel(child)}: shelves may only contain works and an optional README.md"
    end
  end

  file_slugs.each_key do |slug|
    next unless dir_slugs.key?(slug)

    errors << "#{rel(dir)}/#{slug}: work exists as both a file and a directory"
  end
end

def validate_root(errors)
  Dir.children(ROOT).sort.each do |name|
    next if name.start_with?(".")

    path = ROOT.join(name)
    if path.directory?
      next if name == "script"

      validate_shelf(path, errors)
    elsif path.file? && name.end_with?(".md") && name != "README.md"
      errors << "#{name}: the only markdown file allowed at the repo root is README.md"
    end
  end
end

errors = []
validate_root(errors)
if errors.empty?
  exit 0
end

errors.each { |error| warn error }
exit 1
