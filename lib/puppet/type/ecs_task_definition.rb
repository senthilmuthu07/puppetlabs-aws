Puppet::Type.newtype(:ecs_task_definition) do
  @doc = 'Type representing ECS clusters.'

  ensurable

  newparam(:name, namevar: true) do
    desc 'The name of the task to manage.'
    validate do |value|
      fail Puppet::Error, 'Empty ECS task names are not allowed' if value == ''
    end
  end

  newproperty(:arn) do
    desc 'Read-only unique AWS resource name assigned to the ECS service'
  end

  newproperty(:revision) do
    desc 'Read-only revision number of the task definition'
  end

  newproperty(:volumes) do
    desc 'An array of hashes to handle for the task'
  end

  newproperty( :container_definitions, :array_matching => :all) do
    desc 'An array of hashes representing the container definition'
    isrequired
    def insync?(is)
      # Compare the merged result of the container_definitions with what *is* currently.
      one = provider.class.rectify_container_delta(is, should)
      two = provider.class.normalize_values(is)
      one == two
    end
  end
end

