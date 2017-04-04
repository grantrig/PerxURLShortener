class Hash
  def assert_required_keys(*required_keys)
    required_keys.each do |rk|
      raise ArgumentError.new("Key missing #{rk}") unless key? rk
    end
  end
end
