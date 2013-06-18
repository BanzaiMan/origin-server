##
# @api REST
# Describes a User
#
# Example:
#   ```
#   <user>
#     <login>admin</login>
#     <consumed-gears>4</consumed-gears>
#     <max-gears>100</max-gears>
#     <capabilities>
#       <subaccounts>false</subaccounts>
#       <gear-sizes>
#         <gear-size>small</gear-size>
#       </gear-sizes>
#     </capabilities>
#     <plan-id nil="true"/>
#     <plan-state nil="true"/>
#     <usage-account-id nil="true"/>
#     <links>
#     ...
#     </links>
#   </user>
#   ```
#
# @!attribute [r] login
#   @return [String] The login name of the user
# @!attribute [r] consumed_gears
#   @return [Integer] Number of gears currently being used in applications
# @!attribute [r] max_gears
#   @return [Integer] Maximum number of gears avaiable to the user
# @!attribute [r] capabilities
#   @return [Hash] Map of user capabilities
# @!attribute [r] plan_id
#   @return [String] Plan ID
# @!attribute [r] plan_state
#   @return [String] Plan State
# @!attribute [r] usage_account_id
#   @return [String] Account ID
class RestUser < OpenShift::Model
  include RestUserHelper
  attr_accessor :id, :login, :consumed_gears, :capabilities, :plan_id, :plan_state, :usage_account_id, :links, :max_gears, :created_at

  def initialize(cloud_user, url, nolinks=false)
    [:id, :login, :consumed_gears, :plan_id, :plan_state, :usage_account_id, :created_at].each{ |sym| self.send("#{sym}=", cloud_user.send(sym)) }

    self.capabilities = cloud_user.get_capabilities
    self.max_gears = capabilities["max_gears"]
    self.capabilities.delete("max_gears")

    if self.capabilities["max_tracked_addtl_storage_per_gear"] or self.capabilities["max_untracked_addtl_storage_per_gear"]
      tracked_storage = (self.capabilities["max_tracked_addtl_storage_per_gear"] || 0)
      untracked_storage = (self.capabilities["max_untracked_addtl_storage_per_gear"] || 0)
      self.capabilities["max_storage_per_gear"] = tracked_storage + untracked_storage
      self.capabilities.delete("max_tracked_addtl_storage_per_gear")
      self.capabilities.delete("max_untracked_addtl_storage_per_gear")
    end

    unless nolinks
      @links = rest_user_links(url, cloud_user.parent_user_id)
    end
  end
end
