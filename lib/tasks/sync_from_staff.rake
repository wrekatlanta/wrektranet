task :sync_from_staff => :environment do |t, args|
  Legacy::Staff.find_each do |staff|
    puts "Staff #{staff.id}: #{staff.initials}"

    user = User.find_or_initialize_by(username: staff.initials)

    # set original case
    user.username = staff.initials

    unless staff.emails.empty?
      user.email = staff.emails.first.addr.strip
    end

    # sigh, some people have blank email fields or "asdf@asdf.com"
    if user.email.blank? or user.email == 'asdf@asdf.com' or !user.email.include? '@'
      user.email = "#{user.username}@fake.me"
    end

    unless staff.phone_numbers.empty?
      user.phone = staff.phone_numbers.first.number
    end

    user.legacy_id ||= staff.id
    user.password ||= Devise.friendly_token[0,20]
    user.status = staff.status || "inactive"
    user.birthday ||= staff.birthday
    user.first_name ||= staff.fname
    user.middle_name ||= staff.mname
    user.last_name ||= staff.lname

    unless staff.pfname.blank?
      user.display_name ||= "#{staff.pfname} #{staff.lname}"
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
        date_string = words[(at_index - 3)..(at_index + 1)].join ' '
      
        if date = Chronic.parse(date_string)
          user.created_at = date
        end
      end
    end

    # is the user an admin?
    if staff.admin.present? and staff.admin.downcase == "y"
      user.admin = true
    end

    # exec is a reserved word, can't be a method name
    is_exec = staff.read_attribute(:exec)
    if is_exec.present? and is_exec.downcase == "y" and not user.has_role? :exec
      user.exec_staff = true
    end

    user.save!

    # add appropriate roles here
    # if staff.md_privileges == 1
    #   user.add_role :music_director
    # end

    # if staff.auto_privileges == 1
    #   user.add_role :automation_czar
    #   user.add_role :psa_director
    # end

    unless staff.position.blank?
      if staff.position.include? 'Sports Director'
        user.add_role :sports_director
      end

      if staff.position.include? 'Automation Czar' or staff.position.include? 'PSA Director'
        user.add_role :automation_czar
        user.add_role :psa_director
      end

      if staff.position.include? 'Faculty Advisor'
        user.add_role :faculty_advisor
      end

      if staff.position == 'Chief Engineer'
        user.add_role :chief_engineer
      end

      if staff.position.include? 'Assistant Chief Engineer'
        user.add_role :assistant_chief_engineer
      end

      if staff.position.include? 'Public Affairs Director'
        user.add_role :public_affairs_director
      end

      if staff.position.include? 'Business Manager'
        user.add_role :business_manager
      end

      if staff.position.include? 'Live Sound'
        user.add_role :live_sound
      end

      if staff.position.include? 'IT Director'
        user.add_role :it_director
      end

      if staff.position.include? 'Music Director'
        user.add_role :music_director
      end

      if staff.position.include? 'Program Director'
        user.add_role :program_director
      end

      if staff.position.include? 'Publicity Director'
        user.add_role :publicity_director
      end

      if staff.position.include? 'Historian'
        user.add_role :historian
      end

      if staff.position.include? 'General Manager'
        user.add_role :general_manager
      end

      if staff.position.include? 'Operations Manager'
        user.add_role :operations_manager
      end

      if staff.position.include? 'Contest Director'
        user.add_role :contest_director
      end

      if staff.position.include? 'Student Media'
        user.add_role :media_director
      end
    end
  end
end