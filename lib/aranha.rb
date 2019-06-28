# frozen_string_literal: true

require 'httpclient'
require 'active_support/dependencies'
require_dependency 'aranha/engine'
require_dependency 'active_scaffold'

module Aranha
end

require_dependency 'aranha/default_processor'
require_dependency 'aranha/fixtures/download'
require_dependency 'aranha/processor'
require_dependency 'aranha/parsers/base'
require_dependency 'aranha/parsers/html/base'
require_dependency 'aranha/parsers/html/item_list'
require_dependency 'aranha/parsers/invalid_state_exception'
require_dependency 'aranha/dom_elements_traverser'
require_dependency 'aranha/selenium/driver_factory'
