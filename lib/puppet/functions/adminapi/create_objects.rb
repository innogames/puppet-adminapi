#
# Serveradmin create_objects function
#
# Can also update objects if they already exist, if requested.
#
# Copyright (c) 2024 InnoGames GmbH
#

require 'puppet/util/errors'

require_relative './adminapi'

Puppet::Functions.create_function(:'adminapi::create_objects') do

    dispatch :execute do
        param 'Array[Hash[Adminapi::Attribute_id, Adminapi::Attribute_value]]', :created_objects
        optional_param 'Boolean', :update_if_exists
        return_type 'Undef'
    end

    def execute(created_objects, update_if_exists=false)
        all_changes = []
        all_creates = []
        if update_if_exists
            created_objects.each do |new_object|
                current_object = Adminapi.query({
                    'hostname' => new_object['hostname']
                }, new_object.keys, [])
                if current_object.length == 0
                    # Means the object does not exist, just create it and switch to the next
                    all_creates.push(new_object)
                    next
                end
                # The object already exists, we need to compare the attributes
                # and collect all changes to commit them at once
                change = {
                    'object_id' => current_object[0]['object_id'].to_i
                }
                new_object.each_pair do |attribute_id, attr_to_change|
                    if attribute_id == 'object_id'
                        # We can't change the object_id
                        next
                    end
                    if attr_to_change.class == Array
                        # This is a multi-attribute
                        # Let's first check the missing values
                        to_add = []
                        unless (current_object[0][attribute_id] & attr_to_change ) == attr_to_change
                            to_add = attr_to_change - current_object[0][attribute_id]
                        end
                        # Now let's check the values to remove
                        to_remove = []
                        unless (current_object[0][attribute_id] & attr_to_change ) == current_object[0][attribute_id]
                            to_remove = current_object[0][attribute_id] - attr_to_change
                        end
                        # Now construct the change hash if we have any changes
                        if to_add.any? || to_remove.any?
                          change[attribute_id] = {
                              'action' => 'multi',
                              'add' => to_add,
                              'remove' => to_remove
                          }
                        end
                    else
                        # This is a single attribute
                        if current_object[0][attribute_id] != attr_to_change
                            change[attribute_id] = {
                                'action' => 'update',
                                'new' => attr_to_change,
                                'old' => current_object[0][attribute_id]
                            }
                        end
                    end
                end
                # If we have anything other than the object_id, we can commit the change
                if change.values.length > 1
                    all_changes.push(change)
                end
            end
            if all_changes.any? || all_creates.any?
                # Commit the changes
                Adminapi.commit(all_creates, all_changes, [])
            end
        else
            # Normal usage, just create the objects
            # If the object exists, it will raise an error
            Adminapi.commit(created_objects, [], [])
        end
        # Specifically return undef
        nil
    end
end
