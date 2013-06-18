module RestUserHelper

	def rest_user_links(url, has_parent)
		links = {
        "LIST_KEYS" => Link.new("Get SSH keys", "GET", URI::join(url, "user/keys")),
        "ADD_KEY" => Link.new("Add new SSH key", "POST", URI::join(url, "user/keys"), [
          Param.new("name", "string", "Name of the key"),
          Param.new("type", "string", "Type of Key", SshKey.get_valid_ssh_key_types()),
          Param.new("content", "string", "The key portion of an rsa key (excluding ssh-rsa and comment)"),
        ]),
    }
    if has_parent
    	links["DELETE_USER"] = Link.new("Delete user. Only applicable for subaccount users.", "DELETE", URI::join(url, "user"), nil, [
        OptionalParam.new("force", "boolean", "Force delete user. i.e. delete any domains and applications under this user", [true, false], false)
      ])
    end
    links
	end

  def to_xml(options={})
    options[:tag_name] = "user"
    super(options)
  end

end
