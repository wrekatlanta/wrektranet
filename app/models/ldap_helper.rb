module LdapHelper

  def self.get_handle
    # Load piece of LDAP config we need
    ldap_conf = YAML::load(open("#{Rails.root}/config/ldap.yml"))["production"].symbolize_keys

    # Translate admin fields and encryption to Net-LDAP fields
    ldap_conf[:auth] = {method: :simple, username: ldap_conf[:admin_user], password: ldap_conf[:admin_password]}
    ldap_conf[:encryption] = ldap_conf[:ssl] ? {method: :simple_tls} : nil

    # Connect with LDAP
    ldap_handle = Net::LDAP.new(ldap_conf)

    return ldap_handle
  end
end