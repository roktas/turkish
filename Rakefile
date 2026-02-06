# frozen_string_literal: true

require "yaml"
require "fileutils"

module Function
  ALPHABET = %w[ a b c ç d e f g ğ h ı i j k l m n o ö p q r s ş t u ü v w x y z ].freeze

  def turkish_sort_list_by(list, by: nil)
    if by.nil? && !list.empty?
      by = (item = list.first).is_a?(Hash) ? item.keys.first : item.members.first
    end
    list.sort_by do |item|
      word = item.is_a?(Hash) ? item[by] : item.public_send(by)
      word.downcase(:turkic).chars.map { ALPHABET.index(it) || Float::INFINITY }
    end
  end

  def nvim_valid_lhs_for_iabbrev?(lhs)
    !lhs.to_s.empty? && !lhs.match?(/[|"'\s-]/)
  end

  extend self
end and (F = Function)

Misspelling = Data.define(:wrong, :right) do
  MISSPELLINGS = "#{__dir__}/srv/misspellings.yaml"

  def self.load_file(file = MISSPELLINGS) = YAML.load_file(file).map { new(**it.transform_keys(&:to_sym)) }

  def self.sort_file(file = MISSPELLINGS)
    data        = YAML.load_file file
    sorted_data = F.turkish_sort_list_by data
    File.write file, sorted_data.to_yaml
  end

  def self.src = MISSPELLINGS

  def self.to_tsv(list)
    String.new("Wrong\tRight\n").tap do |tsv|
      list.each { tsv << "#{it.wrong}\t#{it.right}\n" }
    end
  end
end

Confusable = Data.define(:word, :meaning, :confused) do
  CONFUSABLES = "#{__dir__}/srv/confusables.yaml"

  def self.load_file(file = CONFUSABLES) = YAML.load_file(file).map { new(**it.transform_keys(&:to_sym)) }

  def self.sort_file(file = CONFUSABLES)
    data        = YAML.load_file file
    sorted_data = F.turkish_sort_list_by data
    File.write file, sorted_data.to_yaml
  end

  def self.src = CONFUSABLES

  def self.to_tsv(list)
    String.new("Word\tMeaning\tConfused\n").tap do |tsv|
      list.each { tsv << "#{it.word}\t#{it.meaning}\t#{it.confused}\n" }
    end
  end
end

namespace :srv do
  desc "Sort misspellings.yaml with Turkish rules"
  task :sort do
    Misspelling.sort_file
  end
end

namespace :nvim do
  desc "Generate Neovim data"
  task :build

  abbreviations = "#{__dir__}/opt/nvim/data/abbreviations.lua"

  file abbreviations => Misspelling.src do |t|
    misspelings = Misspelling.load_file
    pairs       = {}

    misspelings.each do |m|
      next unless F.nvim_valid_lhs_for_iabbrev?(m.wrong)

      pairs[m.wrong]                     = m.right
      pairs[m.wrong.capitalize(:turkic)] = m.right.capitalize(:turkic)
    end

    lua = String.new("return {\n")

    max_wrong_length = pairs.keys.map { it.gsub("\"", "\\\"").length }.max
    max_right_length = pairs.values.map { it.gsub("\"", "\\\"").length }.max

    pairs.sort.each do |wrong, right|
      w = wrong.gsub("\"", "\\\"")
      r = right.gsub("\"", "\\\"")

      padding_wrong = " " * (max_wrong_length - w.length)
      padding_right = " " * (max_right_length - r.length)

      lua << "  { \"#{w}\",#{padding_wrong} \"#{r}\"#{padding_right} },\n"
    end
    lua << "}\n"

    FileUtils.mkdir_p File.dirname(t.name)
    File.write t.name, lua

    puts "Generated #{t.name}"
  end

  desc "Generate Neovim abbreviations data"
  task build: abbreviations
end

%i[ agents ].each do |llm|
  namespace llm do
    misspellings = "#{__dir__}/opt/#{llm}/skills/turkish-check/references/misspellings.tsv"

    file misspellings => Misspelling.src do |t|
      FileUtils.mkdir_p File.dirname(t.name)
      File.write t.name, Misspelling.to_tsv(Misspelling.load_file)

      puts "Generated #{t.name}"
    end

    confusables = "#{__dir__}/opt/#{llm}/skills/turkish-check/references/confusables.tsv"

    file confusables => Confusable.src do |t|
      FileUtils.mkdir_p File.dirname(t.name)
      File.write t.name, Confusable.to_tsv(Confusable.load_file)

      puts "Generated #{t.name}"
    end

    desc "Generate #{llm.capitalize} data"
    task build: [misspellings, confusables]
  end
end

desc "Build all"
task build: [
  "agents:build",

  "nvim:build"
]

task default: :build
