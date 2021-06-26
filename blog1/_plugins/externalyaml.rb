require 'yaml'
require 'net/http'

module ExternalYAML
  class ExternalYAML_tag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
        if /(.+) from (.+)/.match(@text)
            resp = Net::HTTP.get_response(URI($2.strip))
            data = resp.body
            context[$1] = YAML.dump(data)
            return data
        else
            raise ArgumentError, 'ERROR:bad_syntax'
        end
    end

  end
end

Liquid::Template.register_tag('externalYAML', ExternalYAML::ExternalYAML_tag)