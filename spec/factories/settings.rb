FactoryGirl.define do
  factory :setting_1, :class => Setting do
    partner_id '819442'
    category '4629071'
    player_id 'player_1'
    login 'hasan@somewherein.net'
    password '12ab@#CD'
    admin_secret '175c396a37474df785be97968b652bce'
  end

  factory :setting_2, :class => Setting do
    partner_id '829252'
    category '4629071'
    player_id 'player_2'
    login 'nafi@somewherein.net'
    password 'kaltura123!!!'
    admin_secret '2dc13a578b884ff373cb1f389ad54ba8'
  end
end
