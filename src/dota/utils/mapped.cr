module Dota
  module Utilities
    module Mapped
      @@mapping : YAML::Any?
      @@all : YAML::Any?

      def mapping
        @@mapping ||= begin
          filename = "#{{{@type.name.split("::").last.downcase}}}.yml"
          path = File.join(".", "data", filename)
          YAML.parse(File.read(path))
        end
      end

      def all
        @@all ||= mapping.map { |id| new(id.to_s.to_i32) }
      end
    end
  end
end