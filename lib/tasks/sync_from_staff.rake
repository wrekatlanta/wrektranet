task :sync_from_staff => :environment do |t, args|
  Legacy::Staff.find_each do |staff|
    puts "Staff #{staff.id}: #{staff.initials}"
    user = User.find_or_initialize_by(username: staff.initials)

    unless staff.emails.empty?
      user.email = staff.emails.first.addr
    end

    unless staff.phone_numbers.empty?
      user.phone = staff.phone_numbers.first.number
    end

    user.password ||= Devise.friendly_token[0,20]
    user.status = staff.status
    user.birthday ||= staff.birthday
    user.first_name ||= staff.fname
    user.middle_name ||= staff.mname
    user.last_name ||= staff.lname

    unless staff.pfname.blank?
      user.display_name ||= staff.pfname + " " + staff.lname
    end


    # normalize created_at
    if staff.joined
      # this rarely exists for some reason
      user.created_at = staff.joined
    elsif staff.read_attribute(:private).present?
      # try to set created_at from the private comments
      words = staff.read_attribute(:private).split " "

      # find the first instance of @ to find datetimes
      # e.g. Sep 08 2010 @ 06:48:41pm
      at_index = words.index '@'

      if at_index
        date_string = words[(at_index - 3)..(at_index + 1)]
      
        if date = Chronic.parse(date_string)
          user.created_at = date
        end
      end
    end

    # is the user an admin?
    if staff.admin.present? and staff.admin.downcase == "y"
      user.admin = true
    end

    user.save!

    # add appropriate roles

    # exec is a reserved word, can't be a method name
    is_exec = staff.read_attribute(:exec)
    if is_exec.present? and is_exec.downcase == "y" and not user.has_role? :exec
      user.add_role :exec
    end
  end
end