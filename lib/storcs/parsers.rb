require 'storcs/parsers/utils'
require 'storcs/parsers/df_nas'
require 'storcs/parsers/ibm'
require 'storcs/parsers/equalogic'
require 'storcs/parsers/nss'
require 'storcs/parsers/netapp'

module Storcs
  module Parsers
    AVAILABLE_PARSERS = %w(df_nas)
  end
end
