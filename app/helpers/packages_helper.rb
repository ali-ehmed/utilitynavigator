module PackagesHelper
  def get_package_type filters
    case filters.length
    when 1
      return Package::SINGLE_PLAY
    when 2
      return Package::DOUBLE_PLAY
    else
      return Package::TRIPLE_PLAY
    end
  end
end
