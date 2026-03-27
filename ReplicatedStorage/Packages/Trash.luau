--!strict

--[[
================================================================================
Trash

Jam_Toad
2/19/2026
================================================================================
]]

--[[
================================================================================
Types
================================================================================
]]
type Item <T> = (T & (thread | Instance | RBXScriptConnection | () -> ...any))

type Factory = {
  ["Create"] : (
    self : Factory
  ) -> Trash
}

export type Trash = {
  ["Add"] : <T> (
    self : Trash,
    Item : Item <T>
  ) -> T,

  ["Empty"] : (
    self : Trash
  ) -> (),

  ["Extend"] : (
    self : Trash
  ) -> Trash,

  ["Destroy"] : (
    self : Trash
  ) -> ()
}

--[[
================================================================================
Return
================================================================================
]]
return {
  ["Create"] = function(
    Factory : Factory
  ) : Trash
    local Items : {Item <any>}? = {}

    return {
      ["Add"] = function <T> (
        Trash : Trash,
        Item : Item <T>
      ) : T
        if (not Items) then return Item end

        table.insert(Items, Item)

        return Item
      end,

      ["Empty"] = function(
        Trash : Trash
      ) : ()
        if (not Items) then return end

        -- TODO | Should we iterate backwards?
        for _, Item in Items do
          if (typeof(Item) == "thread") then
            task.cancel(Item)
          elseif (typeof(Item) == "function") then
            task.spawn(Item)
          elseif (typeof(Item) == "Instance") then
            Item:Destroy()
          elseif (typeof(Item) == "RBXScriptConnection") then
            Item:Disconnect()
          else
            warn("Error: Cannot clean up unsupported type.")
          end
        end

        table.clear(Items)
      end,

      ["Extend"] = function(
        Trash : Trash
      ) : Trash
        if (not Items) then return Trash end

        local ExtendedTrash : Trash = Factory:Create()

        Trash:Add(
          function() : ()
            ExtendedTrash:Destroy()
          end
        )

        return ExtendedTrash
      end,

      ["Destroy"] = function(
        Trash : Trash
      ) : ()
        Trash:Empty()

        Items = nil
      end,
    }
  end,
} :: Factory