class Parser
  def self.parse(data)
    YAML.safe_load(data)
  end
end