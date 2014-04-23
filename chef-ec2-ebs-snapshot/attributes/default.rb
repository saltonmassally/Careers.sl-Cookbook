default[:chef_ec2_ebs_snapshot] = {
   :description => "Database Backup $(date +'%Y-%m-%d %H:%M:%S')", 
   :region => 'eu-west-1a',
   :aws_access_id => 'secret',
   :aws_secret_access_key => 'secret',
   :volume_id => '',
   :ec2_consistent_snapshot => {
      :freeze => 'true',
   }
   :ec2_expire_snapshot => {
      :keep_most_recent => 10,
      :keep_first_daily => 7,
      :keep_first_monthly => 12,
   }	

}


