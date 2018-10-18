import boto3
 
def lambda_handler(event, context):
    client = boto3.client('ec2')
    # List all regions
    region_iterator = client.describe_regions()['Regions']
    for region in region_iterator:
        # Use the filter() method of the instances collection to retrieve
        # all running EC2 instances.
        ec2 = boto3.resource('ec2', region_name=region['RegionName']) 
        instance_iterator = ec2.instances.filter(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
        for instance in instance_iterator:
            print 'stopped your instances: ' + str(instance.id) + str(instance.instance_type) + ' ' + str(region['RegionName'])
            instance.stop()
 
        autoscaling = boto3.client('autoscaling', region_name=region['RegionName'])
        asg_iterator = autoscaling.describe_auto_scaling_groups()
        for asg in asg_iterator['AutoScalingGroups']:
            response = autoscaling.suspend_processes(
                AutoScalingGroupName=asg['AutoScalingGroupName'],
                ScalingProcesses=['Launch', 'AddToLoadBalancer', 'HealthCheck', 'AZRebalance', 'AlarmNotification', 'ScheduledActions', 'ReplaceUnhealthy'],
            )
    #    print(response) 