module LdapHelper

  def self.ldap_connect
    # Load piece of LDAP config we need
    @@ldap_conf ||= YAML::load(open("#{Rails.root}/config/ldap.yml"))["production"].symbolize_keys

    # Translate admin fields and encryption to Net-LDAP fields
    @@ldap_conf[:auth] = {method: :simple, username: ldap_conf[:admin_user], password: ldap_conf[:admin_password]}
    @@ldap_conf[:encryption] = ldap_conf[:ssl] ? {method: :simple_tls} : nil

    # Connect with LDAP
    @@ldap_handle ||= Net::LDAP.new(ldap_conf)

    return @@ldap_handle
  end

  def self.find_user(username)
    ldap_handle = self.ldap_connect

    result = ldap_handle.search(base: 'ou=People,dc=staff,dc=wrek,dc=org',
                                filter: Net::LDAP::Filter.eq("cn", username),
                                return_result: true,
                                size: 1)

    if result.empty?
      return false
    else
      return result.first
    end
  end
end