name             'chef-ec2-ebs-snapshot'
maintainer       'Salton Massally'
maintainer_email 'salton.massally@gmail.com'
license          'All rights reserved'
description      'Installs/Configures ec2-consistent-snapshot and ec2-expire-snapshot '
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

%w[ubuntu].each do |os|
  supports os
end


