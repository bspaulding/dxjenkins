class Job
  PROPERTIES = [:name, :url, :color]

  PROPERTIES.each {|prop| attr_accessor prop}

  def initialize options = {}
    options.each { |k,v| self.send("#{k}=", v) if PROPERTIES.include?(k) }
  end
end
