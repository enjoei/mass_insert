module MassInsert
  module Adapters
    class PostgreSQLAdapter < AbstractAdapter
      def returning_keys
        " RETURNING #{keys_to_return}"
      end

      def keys_to_return
        @options[:returning] && @options[:returning].join(', ') || @options[:class_name].primary_key
      end
    end
  end
end
