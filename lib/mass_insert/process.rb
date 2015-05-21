module MassInsert
  class Process
    attr_reader :values, :options

    def initialize(values, options)
      @values  = values
      @options = options
    end

    def start
      results = []

      ActiveRecord::Base.transaction do
        values.each_slice(per_batch).each do |batch|
          query = builder.build(batch, options)
          result = executer.execute(query)

          result.values.each {|v| results << v }
        end
      end

      results if results.any?
    end

    private

    def builder
      @builder ||= Builder.new
    end

    def executer
      @executer ||= Executer.new
    end

    def per_batch
      options[:per_batch] || Utilities.per_batch
    end

    def primary_key
      @options[:class_name].primary_key
    end
  end
end
