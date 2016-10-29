class Hash
  def select_keys(hash)
    select {|k,v| hash.include?(k) }
  end
end
