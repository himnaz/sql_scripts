SELECT p.name AS PackageName,
       o.name AS TargetName,
       o.description AS TargetDescription
FROM sys.dm_xe_objects o
       INNER JOIN sys.dm_xe_packages p
              ON o.package_guid = p.guid
WHERE o.object_type = 'target'
  AND (p.capabilities IS NULL OR p.capabilities <> 1)
ORDER BY PackageName, TargetName;