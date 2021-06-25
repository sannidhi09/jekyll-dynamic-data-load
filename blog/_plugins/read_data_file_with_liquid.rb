require 'tmpdir'

module Jekyll
    class DataReader
      def read_data_file_with_liquid(path)
        begin
          dir = File.dirname(path)
          filename = File.basename(path)
          site = Jekyll.sites.last
  
          content = File.read(site.in_source_dir(dir, filename))
          template = Liquid::Template.parse(content)
  
          context = Liquid::Context.new({}, {}, { :site => site })
          rendered = template.render(context)

          Dir.mktmpdir do |tmp_dir|
            tmp_path = File.join(tmp_dir, filename)
            File.write(tmp_path, rendered)
            read_data_file_without_liquid(tmp_path)
          end
        rescue => e
          Jekyll.logger.warn(
            "[Liquid Data] Error parsing data files " +
            "for Liquid content at file #{path}: #{e.message}")
        end
      end
  
      # Make our function overwrite the existing read_data_file function
      # but keep the ability to still call back to the original
      alias_method :read_data_file_without_liquid, :read_data_file
      alias_method :read_data_file, :read_data_file_with_liquid
    end
  end