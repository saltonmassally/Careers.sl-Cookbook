name             "drupal"
maintainer       "Salton Massally"
maintainer_email "salton.massally@gmail.com"
license          "All rights reserved"
description      "Installs/Configures cookbooks/drupal"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

depends 'wkhtmltopdf'
depends 's3fs'
depends 'cron'
