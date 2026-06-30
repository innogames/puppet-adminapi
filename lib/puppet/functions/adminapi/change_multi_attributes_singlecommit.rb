#
# Serveradmin bulk multiadd/multiremove function
#
# Like change_multi_attribute, but applies many object changes in a single
# commit (one HTTP round trip) instead of one commit per object. Use this
# when you need to edit the same multi-attribute on many objects at once.
#
# Copyright (c) 2026 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::change_multi_attributes_singlecommit') do

    dispatch :execute do
        param 'Array[Struct[{
            object_id => Integer,
            attribute => Adminapi::Attribute_id,
            additions => Array[Adminapi::Attribute_value],
            removals  => Array[Adminapi::Attribute_value],
        }]]', :changes
        return_type 'Undef'
    end

    def execute(changes)
        # Skip entries that would not change anything, otherwise Serveradmin
        # gets noise. Each remaining entry touches one object/one attribute,
        # so there are no colliding object_id keys within a single commit.
        changed = changes.reject do |change|
            change['additions'].empty? && change['removals'].empty?
        end.map do |change|
            {
                'object_id'        => change['object_id'],
                change['attribute'] => {
                    'action' => 'multi',
                    'add'    => change['additions'],
                    'remove' => change['removals'],
                },
            }
        end

        return nil if changed.empty?

        Adminapi.commit([], changed, [])
        nil
    end
end
