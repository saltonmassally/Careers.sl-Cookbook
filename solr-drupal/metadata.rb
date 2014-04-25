name             'solr-drupal'
maintainer       'Salton Massally'
maintainer_email 'salton.massally@gmail.com'
license          'All rights reserved'
description      'Installs/Configures apache solr'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

%w[ubuntu].each do |os|
  supports os
end

depends 'hipsnip-solr'

