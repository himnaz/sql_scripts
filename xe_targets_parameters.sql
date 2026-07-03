SELECT p.name AS PackageName,
              o.name AS TargetName,
              c.name AS ParameterName,
              c.type_name AS ParameterType,
              case c.capabilities_desc
                     when 'mandatory' then 'yes'
                     else 'no'
              end AS [Required]
FROM sys.dm_xe_objects o
       INNER JOIN sys.dm_xe_packages p
              ON o.package_guid = p.guid
       INNER JOIN sys.dm_xe_object_columns c
              ON o.name = c.object_name
WHERE o.object_type = 'target'
  AND (p.capabilities IS NULL OR p.capabilities <> 1)
ORDER BY PackageName, TargetName, [Required] desc;