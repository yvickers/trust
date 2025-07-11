---------------------------
-- Action representing equipping an equip set.
-- @class module
-- @name EquipSet

local CanEquipSetCondition = require('cylibs/conditions/can_equip_set')
local EquipSetAction = require('cylibs/actions/equip_set')
local GearSet = require('cylibs/inventory/equipment/equip_set')
local serializer_util = require('cylibs/util/serializer_util')

local EquipSet = {}
EquipSet.__index = EquipSet
EquipSet.__type = "EquipSet"
EquipSet.__class = "EquipSet"

-------
-- Default initializer for a new equip set.
-- @tparam string equip_set_name Equip set name
-- @treturn EquipSet An equip action.
function EquipSet.new(equip_set_name, conditions)
    local self = setmetatable({}, EquipSet)

    self.equip_set_name = equip_set_name
    self.conditions = conditions or L{}

    local matches = (conditions or L{}):filter(function(c)
        return c.__class == CanEquipSetCondition.__class
    end)
    if matches:length() == 0 then
        self:add_condition(CanEquipSetCondition.new(equip_set_name))
    end

    return self
end

-------
-- Adds a condition to the list of conditions.
-- @tparam Condition condition Condition to add
function EquipSet:add_condition(condition)
    if not self:get_conditions():contains(condition) then
        self.conditions:append(condition)
    end
end

-------
-- Returns the list of conditions for turning around.
-- @treturn list List of conditions
function EquipSet:get_conditions()
    return self.conditions
end

-------
-- Returns the maximum range in yalms.
-- @treturn number Range in yalms
function EquipSet:get_range()
    return 999
end

-------
-- Returns the name for the action.
-- @treturn string Action name
function EquipSet:get_name()
    return 'EquipSet'
end

-------
-- Returns the localized name for the action.
-- @treturn string Localized name
function EquipSet:get_localized_name()
    return 'Equip Set'
end

function EquipSet:get_ability_id()
    return 'EquipSet'
end

-------
-- Return the Action to use this action on a target.
-- @treturn Action Action to use ability
function EquipSet:to_action(target_index, _)
    return SequenceAction.new(L{
        EquipSetAction.new(GearSet.named(self.equip_set_name)),
    }, self.__class..'_equip_set')
end

function EquipSet:serialize()
    local conditions_classes_to_serialize = Condition.defaultSerializableConditionClasses()
    local conditions_to_serialize = self.conditions:filter(function(condition)
        return conditions_classes_to_serialize:contains(condition.__class)
    end)
    return "EquipSet.new(" .. serializer_util.serialize_args(self.equip_set_name, conditions_to_serialize) .. ")"
end

function EquipSet:is_valid()
    return true
end

function EquipSet:__eq(otherItem)
    if otherItem.__type == self.__type
            and otherItem.equip_set_name == self.equip_set_name then
        return true
    end
    return false
end

return EquipSet