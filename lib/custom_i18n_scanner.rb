# frozen_string_literal: true

# From https://github.com/thewca/worldcubeassociation.org/blob/master/WcaOnRails/lib/custom_i18n_scanner.rb
# License for this file is GPLv3

require 'i18n/tasks/scanners/file_scanner'

class CustomI18nScanner < I18n::Tasks::Scanners::FileScanner
  include I18n::Tasks::Scanners::RelativeKeys
  include I18n::Tasks::Scanners::OccurrenceFromPosition

  def extract_model_name(key)
    model_key = key.gsub(/^(\w+)\..*$/, '\1').singularize
    # Some dirty tricks to assign the detected field to the "correct" model
    # For most controllers the forms modify a model which has the same name
    # as the controller, however for some of them they modified a single different
    # model (eg: the `admin` forms modify `person`s, and only that model).
    case model_key
    when "devise" then "user"
    else model_key
    end
  end

  # @return [Array<[absolute key, Results::Occurrence]>]
  def scan_file(path)
    text = read_file(path)
    retval = []

    # First scan for inputs (or labels for inputs) that are not hidden
    text.scan(/^\s*<%= f.(input|label|input_field) :(\w+)(?!.*hidden)(.*)%>/) do |_, attribute, input_params|
      # 'absolute_key' returns something that we assume looks like model.(.*).attribute
      abskey = absolute_key(".#{attribute}", path)
      occurrence = occurrence_from_position(path, text, Regexp.last_match.offset(0).first)
      model = extract_model_name(abskey)

      # Mark the hint as used if we don't use custom hint
      if !input_params.include?("hint:")
        retval << ["simple_form.hints.#{model}.#{attribute}", occurrence]
      end

      # Mark the label as used if we don't use custom hint.
      if !input_params.include?("label:")
        retval << ["simple_form.labels.#{model}.#{attribute}", occurrence]
      end
    end

    # Then scan for collection options.
    text.scan(/^\s*<%= f.input :(\w+).* collection: \[(.*)\](.*)%>/) do |attribute, collection|
      abskey = absolute_key(".#{attribute}", path)
      occurrence = occurrence_from_position(path, text, Regexp.last_match.offset(0).first)
      model = extract_model_name(abskey)
      # Get all choices from the f.input
      options = collection.gsub(/[: ]/, '').split(',')
      options.each do |o|
        # Mark every choice as used
        retval << ["simple_form.options.#{model}.#{attribute}.#{o}", occurrence]
      end
    end

    retval
  end
end
