# frozen_string_literal: true

#
# Serveradmin setattr function
#
# Copyright (c) 2020 InnoGames GmbH
#

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::change_attribute') do
  # @param object_id
  #   The Serveradmin object_id
  # @param attribute_id
  #   The Serveradmin attribute_id
  # @param value
  #   The new value for the attribute
  #
  # @return [void]
  dispatch :execute do
    param 'Integer', :object_id
    param 'Adminapi::Attribute_id', :attribute_id
    param 'Adminapi::Attribute_value', :new_value
    return_type 'Undef'
  end

  def execute(object_id, attribute_id, new_value)
    # We need to pass the old value otherwise Serveradmin rejects the commit
    filters = { 'object_id' => object_id }
    result = Adminapi.query(filters, [attribute_id], [])

    fail("Expected Query to return 1 object but got #{result.length}") unless result.length == 1

    current_value = result[0][attribute_id]

    return unless current_value != new_value

    changed = [{
      'object_id' => object_id,
      attribute_id => {
        'action' => 'update',
        'new' => new_value,
        'old' => current_value
      }
    }]

    Adminapi.commit([], changed, [])
  end
end
